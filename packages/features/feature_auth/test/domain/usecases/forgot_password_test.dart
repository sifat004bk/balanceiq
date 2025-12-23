import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late ForgotPassword forgotPassword;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    forgotPassword = ForgotPassword(mockAuthRepository);
  });

  group('ForgotPassword', () {
    const testEmail = 'test@example.com';

    test('should return void when password reset email is sent', () async {
      // Arrange
      when(() => mockAuthRepository.forgotPassword(email: any(named: 'email')))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await forgotPassword(email: testEmail);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.forgotPassword(email: testEmail)).called(1);
    });

    test('should return NotFoundFailure when user not found', () async {
      // Arrange
      when(() => mockAuthRepository.forgotPassword(email: any(named: 'email')))
          .thenAnswer((_) async => const Left(NotFoundFailure('User not found')));

      // Act
      final result = await forgotPassword(email: 'unknown@example.com');

      // Assert
      expect(result, const Left(NotFoundFailure('User not found')));
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(() => mockAuthRepository.forgotPassword(email: any(named: 'email')))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await forgotPassword(email: testEmail);

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.forgotPassword(email: any(named: 'email')))
          .thenAnswer(
              (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await forgotPassword(email: testEmail);

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
