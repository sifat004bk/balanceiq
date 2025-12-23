import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:feature_auth/presentation/cubit/login/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late LoginCubit loginCubit;
  late MockLogin mockLogin;
  late MockSignInWithGoogle mockSignInWithGoogle;

  setUp(() {
    mockLogin = MockLogin();
    mockSignInWithGoogle = MockSignInWithGoogle();
    loginCubit = LoginCubit(
      login: mockLogin,
      signInWithGoogle: mockSignInWithGoogle,
    );
  });

  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit', () {
    const testUsername = 'testuser';
    const testPassword = 'password123';
    const testEmail = 'test@example.com';

    final testUser = User(
      id: '1',
      email: testEmail,
      name: testUsername,
      photoUrl: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
      isEmailVerified: true,
    );

    final testLoginData = LoginData(
      token: 'test_token',
      refreshToken: 'test_refresh_token',
      userId: 1,
      username: testUsername,
      email: testEmail,
      role: 'USER',
      isEmailVerified: true,
    );

    final testLoginResponse = LoginResponse(
      success: true,
      message: 'Login successful',
      data: testLoginData,
      timestamp: 1234567890,
    );

    final testFailedLoginResponse = LoginResponse(
      success: false,
      message: 'Invalid credentials',
      data: null,
      timestamp: 1234567890,
    );

    test('initial state is LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    group('loginWithEmail', () {
      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginSuccess] when login succeeds',
        build: () {
          when(() => mockLogin(
                username: any(named: 'username'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => Right(testLoginResponse));
          return loginCubit;
        },
        act: (cubit) => cubit.loginWithEmail(
          username: testUsername,
          password: testPassword,
        ),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>()
              .having((s) => s.user.email, 'email', testEmail)
              .having((s) => s.user.name, 'name', testUsername),
        ],
        verify: (_) {
          verify(() => mockLogin(
                username: testUsername,
                password: testPassword,
              )).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] when login fails with failure',
        build: () {
          when(() => mockLogin(
                username: any(named: 'username'),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return loginCubit;
        },
        act: (cubit) => cubit.loginWithEmail(
          username: testUsername,
          password: testPassword,
        ),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>().having((s) => s.message, 'message', 'Server error'),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] when login response is unsuccessful',
        build: () {
          when(() => mockLogin(
                username: any(named: 'username'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => Right(testFailedLoginResponse));
          return loginCubit;
        },
        act: (cubit) => cubit.loginWithEmail(
          username: testUsername,
          password: testPassword,
        ),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>()
              .having((s) => s.message, 'message', 'Invalid credentials'),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] when network fails',
        build: () {
          when(() => mockLogin(
                username: any(named: 'username'),
                password: any(named: 'password'),
              )).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return loginCubit;
        },
        act: (cubit) => cubit.loginWithEmail(
          username: testUsername,
          password: testPassword,
        ),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>()
              .having((s) => s.message, 'message', 'No internet connection'),
        ],
      );
    });

    group('signInGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginSuccess] when Google sign in succeeds',
        build: () {
          when(() => mockSignInWithGoogle())
              .thenAnswer((_) async => Right(testUser));
          return loginCubit;
        },
        act: (cubit) => cubit.signInGoogle(),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>().having((s) => s.user, 'user', testUser),
        ],
        verify: (_) {
          verify(() => mockSignInWithGoogle()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] when Google sign in fails',
        build: () {
          when(() => mockSignInWithGoogle()).thenAnswer(
            (_) async => const Left(AuthFailure('Google sign in cancelled')),
          );
          return loginCubit;
        },
        act: (cubit) => cubit.signInGoogle(),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>()
              .having((s) => s.message, 'message', 'Google sign in cancelled'),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] on network error during Google sign in',
        build: () {
          when(() => mockSignInWithGoogle()).thenAnswer(
            (_) async => const Left(NetworkFailure('Network unavailable')),
          );
          return loginCubit;
        },
        act: (cubit) => cubit.signInGoogle(),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginError>()
              .having((s) => s.message, 'message', 'Network unavailable'),
        ],
      );
    });
  });
}
