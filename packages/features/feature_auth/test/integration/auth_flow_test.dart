import 'package:dartz/dartz.dart';
import 'package:feature_auth/data/datasources/auth_remote_datasource.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:feature_auth/domain/usecases/signup.dart';
import 'package:feature_auth/domain/usecases/sign_out.dart';
import 'package:feature_auth/domain/usecases/forgot_password.dart';
import 'package:feature_auth/domain/usecases/reset_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

/// Integration tests for auth feature
/// Tests complete flows from datasource → repository → use case
void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repository;
  late Signup signupUseCase;
  late Login loginUseCase;
  late SignOut signOutUseCase;
  late ForgotPassword forgotPasswordUseCase;
  late ResetPassword resetPasswordUseCase;

  setUpAll(() {
    registerFallbackValue(
      SignupRequest(username: '', password: '', fullName: '', email: ''),
    );
    registerFallbackValue(
      LoginRequest(username: '', password: ''),
    );
    registerFallbackValue(
      ForgotPasswordRequest(email: ''),
    );
    registerFallbackValue(
      ResetPasswordRequest(token: '', newPassword: '', confirmPassword: ''),
    );
  });

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();

    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: MockAuthLocalDataSource(),
    );

    signupUseCase = Signup(repository);
    loginUseCase = Login(repository);
    signOutUseCase = SignOut(repository);
    forgotPasswordUseCase = ForgotPassword(repository);
    resetPasswordUseCase = ResetPassword(repository);
  });

  group('Auth Feature Integration Tests', () {
    group('Signup → Login Flow', () {
      test('should complete signup and login flow successfully', () async {
        // Step 1: User signs up
        when(() => remoteDataSource.signup(any()))
            .thenAnswer((_) async => SignupResponse(
                  success: true,
                  message: 'Signup successful',
                  data: null,
                ));

        final signupResult = await signupUseCase(
          email: 'test@example.com',
          password: 'password123',
          fullName: 'Test User',
          username: 'testuser',
        );

        expect(signupResult.isRight(), true);
        verify(() => remoteDataSource.signup(any())).called(1);

        // Step 2: User logs in
        when(() => remoteDataSource.login(any()))
            .thenAnswer((_) async => LoginResponse(
                  success: true,
                  message: 'Login successful',
                  data: LoginData(
                    userId: 123,
                    username: 'testuser',
                    email: 'test@example.com',
                    accessToken: 'token',
                    refreshToken: 'refresh',
                    isEmailVerified: true,
                  ),
                ));

        final loginResult = await loginUseCase(
          username: 'testuser',
          password: 'password123',
        );

        expect(loginResult.isRight(), true);
        verify(() => remoteDataSource.login(any())).called(1);
      });
    });

    group('Password Reset Flow', () {
      test('should complete password reset flow successfully', () async {
        // Step 1: Request password reset
        when(() => remoteDataSource.forgotPassword(any()))
            .thenAnswer((_) async => {});

        final forgotResult = await forgotPasswordUseCase(
          email: 'test@example.com',
        );

        expect(forgotResult.isRight(), true);
        verify(() => remoteDataSource.forgotPassword(any())).called(1);

        // Step 2: Reset password with token
        when(() => remoteDataSource.resetPassword(any()))
            .thenAnswer((_) async => {});

        final resetResult = await resetPasswordUseCase(
          token: 'reset_token',
          newPassword: 'newPassword123',
          confirmPassword: 'newPassword123',
        );

        expect(resetResult.isRight(), true);
        verify(() => remoteDataSource.resetPassword(any())).called(1);
      });
    });

    group('Error Propagation', () {
      test('should propagate signup error from datasource to use case',
          () async {
        // Arrange
        when(() => remoteDataSource.signup(any()))
            .thenThrow(Exception('Email already exists'));

        // Act
        final result = await signupUseCase(
          email: 'existing@example.com',
          password: 'password123',
          fullName: 'Test',
          username: 'test',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should propagate login error from datasource to use case',
          () async {
        // Arrange
        when(() => remoteDataSource.login(any()))
            .thenThrow(Exception('Invalid credentials'));

        // Act
        final result = await loginUseCase(
          username: 'user',
          password: 'wrongpassword',
        );

        // Assert
        expect(result.isLeft(), true);
      });
    });

    group('Edge Cases', () {
      test('should handle invalid reset token', () async {
        // Arrange
        when(() => remoteDataSource.resetPassword(any()))
            .thenThrow(Exception('Invalid token'));

        // Act
        final result = await resetPasswordUseCase(
          token: 'invalid',
          newPassword: 'newpass',
          confirmPassword: 'newpass',
        );

        // Assert
        expect(result.isLeft(), true);
      });

      test('should handle signout successfully', () async {
        // Arrange
        when(() => remoteDataSource.signOut()).thenAnswer((_) async => {});

        // Act
        final result = await signOutUseCase();

        // Assert
        expect(result.isRight(), true);
        verify(() => remoteDataSource.signOut()).called(1);
      });
    });
  });
}
