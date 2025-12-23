import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/reset_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late ResetPassword resetPassword;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    resetPassword = ResetPassword(mockAuthRepository);
  });

  group('ResetPassword', () {
    const testToken = 'reset_token_123';
    const testNewPassword = 'NewPassword123!';
    const testConfirmPassword = 'NewPassword123!';

    test('should return void when password reset is successful', () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(
            token: any(named: 'token'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await resetPassword(
        token: testToken,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.resetPassword(
            token: testToken,
            newPassword: testNewPassword,
            confirmPassword: testConfirmPassword,
          )).called(1);
    });

    test('should return AuthFailure when token is invalid', () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(
            token: any(named: 'token'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          )).thenAnswer(
              (_) async => const Left(AuthFailure('Invalid or expired token')));

      // Act
      final result = await resetPassword(
        token: 'invalid_token',
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(result, const Left(AuthFailure('Invalid or expired token')));
    });

    test('should return ValidationFailure when passwords do not match',
        () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(
            token: any(named: 'token'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          )).thenAnswer(
              (_) async => const Left(ValidationFailure('Passwords do not match')));

      // Act
      final result = await resetPassword(
        token: testToken,
        newPassword: testNewPassword,
        confirmPassword: 'DifferentPassword123!',
      );

      // Assert
      expect(result, const Left(ValidationFailure('Passwords do not match')));
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(
            token: any(named: 'token'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          )).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await resetPassword(
        token: testToken,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.resetPassword(
            token: any(named: 'token'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
          )).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await resetPassword(
        token: testToken,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
