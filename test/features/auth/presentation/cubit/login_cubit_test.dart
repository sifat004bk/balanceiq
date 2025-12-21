import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/features/auth/data/models/auth_request_models.dart';
import 'package:balance_iq/features/auth/domain/entities/user.dart';
import 'package:balance_iq/features/auth/domain/usecases/login.dart';
import 'package:balance_iq/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:balance_iq/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogin extends Mock implements Login {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

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

    final testUser = User(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: null,
      authProvider: 'email',
      createdAt: DateTime(2024, 1, 1),
      isEmailVerified: true,
    );

    final testLoginResponse = LoginResponse(
      success: true,
      message: 'Login successful',
      timestamp: 1703001600,
      data: LoginData(
        token: 'test_token',
        refreshToken: 'test_refresh_token',
        userId: 1,
        email: 'test@example.com',
        username: 'testuser',
        role: 'USER',
        isEmailVerified: true,
      ),
    );

    test('initial state is LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] when loginWithEmail succeeds',
      build: () {
        when(() => mockLogin(username: testUsername, password: testPassword))
            .thenAnswer((_) async => Right(testLoginResponse));
        return loginCubit;
      },
      act: (cubit) =>
          cubit.loginWithEmail(username: testUsername, password: testPassword),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() => mockLogin(username: testUsername, password: testPassword))
            .called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginError] when loginWithEmail fails',
      build: () {
        when(() => mockLogin(username: testUsername, password: testPassword))
            .thenAnswer(
                (_) async => const Left(ServerFailure('Invalid credentials')));
        return loginCubit;
      },
      act: (cubit) =>
          cubit.loginWithEmail(username: testUsername, password: testPassword),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginError>(),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] when signInGoogle succeeds',
      build: () {
        when(() => mockSignInWithGoogle())
            .thenAnswer((_) async => Right(testUser));
        return loginCubit;
      },
      act: (cubit) => cubit.signInGoogle(),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() => mockSignInWithGoogle()).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginError] when signInGoogle fails',
      build: () {
        when(() => mockSignInWithGoogle()).thenAnswer(
            (_) async => const Left(ServerFailure('Google sign-in failed')));
        return loginCubit;
      },
      act: (cubit) => cubit.signInGoogle(),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginError>(),
      ],
    );
  });
}
