import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/change_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late ChangePassword changePassword;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    changePassword = ChangePassword(mockAuthRepository);
  });

  group('ChangePassword', () {
    const testCurrentPassword = 'OldPassword123!';
    const testNewPassword = 'NewPassword123!';
    const testConfirmPassword = 'NewPassword123!';
    const testToken = 'valid_token';

    test('should return void when password change is successful', () async {
      // Arrange
      when(() => mockAuthRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
            token: any(named: 'token'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await changePassword(
        currentPassword: testCurrentPassword,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
        token: testToken,
      );

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.changePassword(
            currentPassword: testCurrentPassword,
            newPassword: testNewPassword,
            confirmPassword: testConfirmPassword,
            token: testToken,
          )).called(1);
    });

    test('should return AuthFailure when current password is wrong', () async {
      // Arrange
      when(() => mockAuthRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
            token: any(named: 'token'),
          )).thenAnswer((_) async =>
              const Left(AuthFailure('Current password is incorrect')));

      // Act
      final result = await changePassword(
        currentPassword: 'wrongpassword',
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
        token: testToken,
      );

      // Assert
      expect(result, const Left(AuthFailure('Current password is incorrect')));
    });

    test('should return ValidationFailure when passwords do not match',
        () async {
      // Arrange
      when(() => mockAuthRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
            token: any(named: 'token'),
          )).thenAnswer(
              (_) async => const Left(ValidationFailure('Passwords do not match')));

      // Act
      final result = await changePassword(
        currentPassword: testCurrentPassword,
        newPassword: testNewPassword,
        confirmPassword: 'DifferentPassword123!',
        token: testToken,
      );

      // Assert
      expect(result, const Left(ValidationFailure('Passwords do not match')));
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(() => mockAuthRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
            token: any(named: 'token'),
          )).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await changePassword(
        currentPassword: testCurrentPassword,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
        token: testToken,
      );

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmPassword: any(named: 'confirmPassword'),
            token: any(named: 'token'),
          )).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await changePassword(
        currentPassword: testCurrentPassword,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
        token: testToken,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
