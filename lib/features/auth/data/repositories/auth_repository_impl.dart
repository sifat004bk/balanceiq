import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Failed to sign in with Google: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    try {
      final user = await remoteDataSource.signInWithApple();
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure('Failed to sign in with Apple: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Failed to sign out: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final isSignedIn = await localDataSource.isSignedIn();
      return Right(isSignedIn);
    } catch (e) {
      return Left(CacheFailure('Failed to check sign in status: $e'));
    }
  }
}
