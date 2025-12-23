import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/resend_verification_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late ResendVerificationEmail resendVerificationEmail;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    resendVerificationEmail = ResendVerificationEmail(mockAuthRepository);
  });

  group('ResendVerificationEmail', () {
    const testEmail = 'test@example.com';

    test('should return void when resending verification email succeeds',
        () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await resendVerificationEmail(email: testEmail);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.resendVerificationEmail(testEmail))
          .called(1);
    });

    test('should return ValidationFailure when email format is invalid',
        () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(ValidationFailure('Invalid email format')));

      // Act
      final result = await resendVerificationEmail(email: 'invalid-email');

      // Assert
      expect(result, const Left(ValidationFailure('Invalid email format')));
    });

    test('should return NotFoundFailure when email not registered', () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(NotFoundFailure('Email not registered')));

      // Act
      final result = await resendVerificationEmail(email: testEmail);

      // Assert
      expect(result, const Left(NotFoundFailure('Email not registered')));
    });

    test('should return AuthFailure when email already verified', () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(AuthFailure('Email already verified')));

      // Act
      final result = await resendVerificationEmail(email: testEmail);

      // Assert
      expect(result, const Left(AuthFailure('Email already verified')));
    });

    test('should return ServerFailure when email service fails', () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to send email')));

      // Act
      final result = await resendVerificationEmail(email: testEmail);

      // Assert
      expect(result, const Left(ServerFailure('Failed to send email')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await resendVerificationEmail(email: testEmail);

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });

    test('should return ValidationFailure when rate limit exceeded', () async {
      // Arrange
      when(() => mockAuthRepository.resendVerificationEmail(any())).thenAnswer(
          (_) async =>
              const Left(ValidationFailure('Too many requests, try later')));

      // Act
      final result = await resendVerificationEmail(email: testEmail);

      // Assert
      expect(
          result, const Left(ValidationFailure('Too many requests, try later')));
    });
  });
}
