import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:feature_auth/domain/usecases/signup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late Signup signup;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signup = Signup(mockAuthRepository);
  });

  group('Signup', () {
    const testUsername = 'testuser';
    const testPassword = 'Password123!';
    const testFullName = 'Test User';
    const testEmail = 'test@example.com';

    final testSignupResponse = SignupResponse(
      success: true,
      message: 'Signup successful',
      timestamp: 1234567890,
    );

    test('should return SignupResponse when signup is successful', () async {
      // Arrange
      when(() => mockAuthRepository.signup(
            username: any(named: 'username'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
          )).thenAnswer((_) async => Right(testSignupResponse));

      // Act
      final result = await signup(
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
        email: testEmail,
      );

      // Assert
      expect(result, Right(testSignupResponse));
      verify(() => mockAuthRepository.signup(
            username: testUsername,
            password: testPassword,
            fullName: testFullName,
            email: testEmail,
          )).called(1);
    });

    test('should return ServerFailure when signup fails', () async {
      // Arrange
      when(() => mockAuthRepository.signup(
            username: any(named: 'username'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
          )).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await signup(
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
        email: testEmail,
      );

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return ValidationFailure for duplicate email', () async {
      // Arrange
      when(() => mockAuthRepository.signup(
            username: any(named: 'username'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
          )).thenAnswer(
              (_) async => const Left(ValidationFailure('Email already exists')));

      // Act
      final result = await signup(
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
        email: testEmail,
      );

      // Assert
      expect(result, const Left(ValidationFailure('Email already exists')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.signup(
            username: any(named: 'username'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
          )).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await signup(
        username: testUsername,
        password: testPassword,
        fullName: testFullName,
        email: testEmail,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
