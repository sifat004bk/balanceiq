import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:dolfin_core/error/app_exception.dart';
import 'package:dolfin_core/error/failures.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_request_models.dart';
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
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(AuthFailure('Failed to sign in with Google: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUser();
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
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

  @override
  Future<Either<Failure, SignupResponse>> signup({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    try {
      final request = SignupRequest(
        username: username,
        password: password,
        fullName: fullName,
        email: email,
      );
      final response = await remoteDataSource.signup(request);
      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to signup: $e'));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> login({
    required String username,
    required String password,
  }) async {
    try {
      final request = LoginRequest(
        username: username,
        password: password,
      );
      final response = await remoteDataSource.login(request);

      // Save user to local storage after successful login
      if (response.success && response.data != null) {
        final userModel = UserModel(
          id: response.data!.userId.toString(),
          email: response.data!.email,
          name: response.data!.username,
          photoUrl: null,
          authProvider: 'email',
          createdAt: DateTime.now(),
          isEmailVerified: response.data!.isEmailVerified,
        );
        await localDataSource.saveUser(userModel);
        await localDataSource.saveAuthToken(response.data!.token);
      }

      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to login: $e'));
    }
  }

  @override
  Future<Either<Failure, UserInfo>> getProfile(String token) async {
    try {
      final profile = await remoteDataSource.getProfile(token);
      return Right(profile);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to get profile: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      await remoteDataSource.changePassword(request, token);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to change password: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      final request = ForgotPasswordRequest(email: email);
      await remoteDataSource.forgotPassword(request);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to send forgot password email: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final request = ResetPasswordRequest(
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      await remoteDataSource.resetPassword(request);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to reset password: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationEmail(String token) async {
    try {
      await remoteDataSource.sendVerificationEmail(token);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to send verification email: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resendVerificationEmail(String email) async {
    try {
      await remoteDataSource.resendVerificationEmail(email);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to resend verification email: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCurrency(String currency) async {
    try {
      await remoteDataSource.updateCurrency(currency);
      // Also update local user cache if needed, but SessionCubit usually reloads or updates state
      // We can update the cached user's currency here if we want to be consistent
      final currentUser = await localDataSource.getCachedUser();
      if (currentUser != null) {
        // Assuming UserModel doesn't have currency field yet?
        // Based on previous reads, UserModel has id, email, name, etc.
        // Currency is handled by CurrencyCubit separately in dolfin_core.
        // So we don't need to update UserModel here.
      }
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to update currency: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        photoUrl: user.photoUrl,
        authProvider: user.authProvider,
        currency: user.currency,
        createdAt: user.createdAt,
        isEmailVerified: user.isEmailVerified,
      );
      await localDataSource.saveUser(userModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save user: $e'));
    }
  }

  Failure _mapExceptionToFailure(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is AuthException) {
      return AuthFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    } else {
      return ServerFailure(exception.message);
    }
  }
}
