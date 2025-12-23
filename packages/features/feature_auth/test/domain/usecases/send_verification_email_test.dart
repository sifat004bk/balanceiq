import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/domain/usecases/send_verification_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late SendVerificationEmail sendVerificationEmail;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sendVerificationEmail = SendVerificationEmail(mockAuthRepository);
  });

  group('SendVerificationEmail', () {
    const testToken = 'test_jwt_token';

    test('should return void when sending verification email succeeds',
        () async {
      // Arrange
      when(() => mockAuthRepository.sendVerificationEmail(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await sendVerificationEmail(token: testToken);

      // Assert
      expect(result, const Right(null));
      verify(() => mockAuthRepository.sendVerificationEmail(testToken))
          .called(1);
    });

    test('should return AuthFailure when token is invalid', () async {
      // Arrange
      when(() => mockAuthRepository.sendVerificationEmail(any()))
          .thenAnswer((_) async => const Left(AuthFailure('Invalid token')));

      // Act
      final result = await sendVerificationEmail(token: 'invalid_token');

      // Assert
      expect(result, const Left(AuthFailure('Invalid token')));
    });

    test('should return AuthFailure when user already verified', () async {
      // Arrange
      when(() => mockAuthRepository.sendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(AuthFailure('Email already verified')));

      // Act
      final result = await sendVerificationEmail(token: testToken);

      // Assert
      expect(result, const Left(AuthFailure('Email already verified')));
    });

    test('should return ServerFailure when email service fails', () async {
      // Arrange
      when(() => mockAuthRepository.sendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to send email')));

      // Act
      final result = await sendVerificationEmail(token: testToken);

      // Assert
      expect(result, const Left(ServerFailure('Failed to send email')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.sendVerificationEmail(any())).thenAnswer(
          (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await sendVerificationEmail(token: testToken);

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });

    test('should return ValidationFailure when rate limit exceeded', () async {
      // Arrange
      when(() => mockAuthRepository.sendVerificationEmail(any())).thenAnswer(
          (_) async =>
              const Left(ValidationFailure('Too many requests, try later')));

      // Act
      final result = await sendVerificationEmail(token: testToken);

      // Assert
      expect(
          result, const Left(ValidationFailure('Too many requests, try later')));
    });
  });
}
