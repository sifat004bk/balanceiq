import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late Login login;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    login = Login(mockAuthRepository);
  });

  group('Login', () {
    const testUsername = 'testuser';
    const testPassword = 'Password123!';

    final testLoginData = LoginData(
      token: 'jwt_token',
      refreshToken: 'refresh_token',
      userId: 1,
      username: testUsername,
      email: 'test@example.com',
      role: 'USER',
      isEmailVerified: true,
    );

    final testLoginResponse = LoginResponse(
      success: true,
      message: 'Login successful',
      data: testLoginData,
      error: null,
      timestamp: 1704067200,
    );

    test('should return LoginResponse when login is successful', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Right(testLoginResponse));

      // Act
      final result = await login(
        username: testUsername,
        password: testPassword,
      );

      // Assert
      expect(result, Right(testLoginResponse));
      verify(() => mockAuthRepository.login(
            username: testUsername,
            password: testPassword,
          )).called(1);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await login(
        username: testUsername,
        password: testPassword,
      );

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return AuthFailure for invalid credentials', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer(
              (_) async => const Left(AuthFailure('Invalid credentials')));

      // Act
      final result = await login(
        username: testUsername,
        password: 'wrongpassword',
      );

      // Assert
      expect(result, const Left(AuthFailure('Invalid credentials')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockAuthRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await login(
        username: testUsername,
        password: testPassword,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
