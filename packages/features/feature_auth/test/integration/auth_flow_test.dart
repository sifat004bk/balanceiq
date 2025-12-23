import 'package:dartz/dartz.dart';
import 'package:feature_auth/data/datasources/auth_remote_datasource.dart';
import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:feature_auth/domain/usecases/signup.dart';
import 'package:feature_auth/domain/usecases/sign_out.dart';
import 'package:feature_auth/domain/usecases/forgot_password.dart';
import 'package:feature_auth/domain/usecases/reset_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

import '../mocks.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

/// Integration tests for auth feature
/// Tests complete flows from datasource → repository → use case
void main() {
  late AuthRemoteDataSource remoteDataSource;
  late SecureStorageService secureStorage;
  late AuthRepositoryImpl repository;
  late Signup signupUseCase;
  late Login loginUseCase;
  late SignOut signOutUseCase;
  late ForgotPassword forgotPasswordUseCase;
  late ResetPassword resetPasswordUseCase;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    secureStorage = MockSecureStorageService();

    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      secureStorage: secureStorage,
    );

    signupUseCase = Signup(repository);
    loginUseCase = Login(repository);
    signOutUseCase = SignOut(repository);
    forgotPasswordUseCase = ForgotPassword(repository);
    resetPasswordUseCase = ResetPassword(repository);
  });

  group('Auth Feature Integration Tests', () {
    final testUser = User(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      authProvider: 'email',
      createdAt: DateTime(2024, 1, 15),
      isEmailVerified: true,
    );

    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testToken = 'test_jwt_token';

    group('Complete Auth Flow: Signup → Login → Logout', () {
      test('should complete full authentication flow successfully', () async {
        // Step 1: User signs up
        when(() => remoteDataSource.signup(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => {'token': testToken, 'user': {}});

        when(() => secureStorage.saveToken(any())).thenAnswer((_) async => {});
        when(() => secureStorage.saveUserId(any())).thenAnswer((_) async => {});

        final signupResult = await signupUseCase(
          email: testEmail,
          password: testPassword,
          name: 'Test User',
        );

        expect(signupResult.isRight(), true);
        verify(() => remoteDataSource.signup(
              email: testEmail,
              password: testPassword,
              name: 'Test User',
            )).called(1);
        verify(() => secureStorage.saveToken(testToken)).called(1);

        // Step 2: User logs in
        when(() => remoteDataSource.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => {'token': testToken, 'user': {}});

        final loginResult = await loginUseCase(
          email: testEmail,
          password: testPassword,
        );

        expect(loginResult.isRight(), true);
        verify(() => remoteDataSource.login(
              email: testEmail,
              password: testPassword,
            )).called(1);

        // Step 3: User logs out
        when(() => remoteDataSource.signOut()).thenAnswer((_) async => {});
        when(() => secureStorage.deleteToken()).thenAnswer((_) async => {});
        when(() => secureStorage.deleteUserId()).thenAnswer((_) async => {});

        final logoutResult = await signOutUseCase();

        expect(logoutResult.isRight(), true);
        verify(() => remoteDataSource.signOut()).called(1);
        verify(() => secureStorage.deleteToken()).called(1);
        verify(() => secureStorage.deleteUserId()).called(1);
      });
    });

    group('Password Reset Flow', () {
      test('should complete password reset flow successfully', () async {
        // Step 1: Request password reset
        when(() => remoteDataSource.forgotPassword(
              email: any(named: 'email'),
            )).thenAnswer((_) async => {'message': 'Email sent'});

        final forgotResult = await forgotPasswordUseCase(email: testEmail);

        expect(forgotResult.isRight(), true);
        verify(() => remoteDataSource.forgotPassword(email: testEmail))
            .called(1);

        // Step 2: Reset password with token
        const resetToken = 'reset_token_123';
        const newPassword = 'newPassword123';

        when(() => remoteDataSource.resetPassword(
              token: any(named: 'token'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => {'message': 'Password reset'});

        final resetResult = await resetPasswordUseCase(
          token: resetToken,
          password: newPassword,
        );

        expect(resetResult.isRight(), true);
        verify(() => remoteDataSource.resetPassword(
              token: resetToken,
              password: newPassword,
            )).called(1);
      });
    });

    group('Error Propagation Through Layers', () {
      test('should propagate auth error from datasource to use case', () async {
        // Arrange - datasource throws auth error
        when(() => remoteDataSource.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Invalid credentials'));

        // Act
        final result = await loginUseCase(
          email: testEmail,
          password: 'wrongpassword',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Invalid')),
          (user) => fail('Should not succeed'),
        );
      });

      test('should propagate network error from datasource to use case',
          () async {
        // Arrange
        when(() => remoteDataSource.signup(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenThrow(Exception('No internet connection'));

        // Act
        final result = await signupUseCase(
          email: testEmail,
          password: testPassword,
          name: 'Test',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('internet')),
          (user) => fail('Should not succeed'),
        );
      });
    });

    group('Edge Cases Through Complete Flow', () {
      test('should handle already registered email', () async {
        // Arrange
        when(() => remoteDataSource.signup(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenThrow(Exception('Email already exists'));

        // Act
        final result = await signupUseCase(
          email: testEmail,
          password: testPassword,
          name: 'Test',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('exists')),
          (user) => fail('Should not succeed'),
        );
      });

      test('should handle invalid reset token', () async {
        // Arrange
        when(() => remoteDataSource.resetPassword(
              token: any(named: 'token'),
              password: any(named: 'password'),
            )).thenThrow(Exception('Invalid or expired token'));

        // Act
        final result = await resetPasswordUseCase(
          token: 'invalid_token',
          password: 'newpass',
        );

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Invalid')),
          (_) => fail('Should not succeed'),
        );
      });

      test('should handle logout when not logged in', () async {
        // Arrange
        when(() => remoteDataSource.signOut()).thenAnswer((_) async => {});
        when(() => secureStorage.deleteToken()).thenAnswer((_) async => {});
        when(() => secureStorage.deleteUserId()).thenAnswer((_) async => {});

        // Act
        final result = await signOutUseCase();

        // Assert - should still succeed
        expect(result.isRight(), true);
      });
    });
  });
}
