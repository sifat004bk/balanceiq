import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import 'package:dolfin_core/error/failures.dart';
import '../../data/models/auth_request_models.dart';

abstract class AuthRepository {
  // OAuth Methods
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> isSignedIn();

  // Backend API Methods
  Future<Either<Failure, SignupResponse>> signup({
    required String username,
    required String password,
    required String fullName,
    required String email,
  });

  Future<Either<Failure, LoginResponse>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, UserInfo>> getProfile(String token);

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  });

  Future<Either<Failure, void>> forgotPassword({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  });

  // Email Verification Methods
  Future<Either<Failure, void>> sendVerificationEmail(String token);
  Future<Either<Failure, void>> resendVerificationEmail(String email);
}
