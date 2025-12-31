import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:feature_auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late SignupCubit signupCubit;
  late MockSignup mockSignup;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockSendVerificationEmail mockSendVerificationEmail;
  late MockResendVerificationEmail mockResendVerificationEmail;
  late MockSecureStorageService mockSecureStorage;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockSignup = MockSignup();
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockSendVerificationEmail = MockSendVerificationEmail();
    mockResendVerificationEmail = MockResendVerificationEmail();
    mockSecureStorage = MockSecureStorageService();
    mockAnalyticsService = MockAnalyticsService();

    when(() => mockAnalyticsService.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        )).thenAnswer((_) async {});

    when(() => mockAnalyticsService.setUserId(any())).thenAnswer((_) async {});

    signupCubit = SignupCubit(
      signup: mockSignup,
      signInWithGoogle: mockSignInWithGoogle,
      sendVerificationEmail: mockSendVerificationEmail,
      resendVerificationEmail: mockResendVerificationEmail,
      secureStorage: mockSecureStorage,
      analyticsService: mockAnalyticsService,
    );
  });

  tearDown(() {
    signupCubit.close();
  });

  group('SignupCubit', () {
    const testUsername = 'testuser';
    const testPassword = 'Password123!';
    const testFullName = 'Test User';
    const testEmail = 'test@example.com';

    final testUser = User(
      id: '1',
      email: testEmail,
      name: testFullName,
      photoUrl: null,
      authProvider: 'google',
      createdAt: DateTime.now(),
      isEmailVerified: true,
    );

    final testSignupResponse = SignupResponse(
      success: true,
      message: 'Signup successful',
      timestamp: 1234567890,
    );

    final testFailedSignupResponse = SignupResponse(
      success: false,
      message: 'Email already exists',
      timestamp: 1234567890,
    );

    test('initial state is SignupInitial', () {
      expect(signupCubit.state, isA<SignupInitial>());
    });

    group('signupWithEmail', () {
      blocTest<SignupCubit, SignupState>(
        'emits [SignupLoading, SignupSuccess] when signup succeeds',
        build: () {
          when(() => mockSignup(
                username: any(named: 'username'),
                password: any(named: 'password'),
                fullName: any(named: 'fullName'),
                email: any(named: 'email'),
              )).thenAnswer((_) async => Right(testSignupResponse));
          return signupCubit;
        },
        act: (cubit) => cubit.signupWithEmail(
          username: testUsername,
          password: testPassword,
          fullName: testFullName,
          email: testEmail,
        ),
        expect: () => [
          isA<SignupLoading>(),
          isA<SignupSuccess>().having((s) => s.email, 'email', testEmail),
        ],
        verify: (_) {
          verify(() => mockSignup(
                username: testUsername,
                password: testPassword,
                fullName: testFullName,
                email: testEmail,
              )).called(1);
        },
      );

      blocTest<SignupCubit, SignupState>(
        'emits [SignupLoading, SignupError] when signup fails with failure',
        build: () {
          when(() => mockSignup(
                username: any(named: 'username'),
                password: any(named: 'password'),
                fullName: any(named: 'fullName'),
                email: any(named: 'email'),
              )).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return signupCubit;
        },
        act: (cubit) => cubit.signupWithEmail(
          username: testUsername,
          password: testPassword,
          fullName: testFullName,
          email: testEmail,
        ),
        expect: () => [
          isA<SignupLoading>(),
          isA<SignupError>()
              .having((s) => s.message, 'message', 'Server error'),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'emits [SignupLoading, SignupError] when signup response is unsuccessful',
        build: () {
          when(() => mockSignup(
                username: any(named: 'username'),
                password: any(named: 'password'),
                fullName: any(named: 'fullName'),
                email: any(named: 'email'),
              )).thenAnswer((_) async => Right(testFailedSignupResponse));
          return signupCubit;
        },
        act: (cubit) => cubit.signupWithEmail(
          username: testUsername,
          password: testPassword,
          fullName: testFullName,
          email: testEmail,
        ),
        expect: () => [
          isA<SignupLoading>(),
          isA<SignupError>()
              .having((s) => s.message, 'message', 'Email already exists'),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'emits [SignupLoading, SignupError] on validation failure',
        build: () {
          when(() => mockSignup(
                username: any(named: 'username'),
                password: any(named: 'password'),
                fullName: any(named: 'fullName'),
                email: any(named: 'email'),
              )).thenAnswer(
            (_) async => const Left(ValidationFailure('Invalid email format')),
          );
          return signupCubit;
        },
        act: (cubit) => cubit.signupWithEmail(
          username: testUsername,
          password: testPassword,
          fullName: testFullName,
          email: 'invalid-email',
        ),
        expect: () => [
          isA<SignupLoading>(),
          isA<SignupError>()
              .having((s) => s.message, 'message', 'Invalid email format'),
        ],
      );
    });

    group('signInGoogle', () {
      blocTest<SignupCubit, SignupState>(
        'emits [SignupLoading, SignupAuthenticated] when Google sign in succeeds',
        build: () {
          when(() => mockSignInWithGoogle())
              .thenAnswer((_) async => Right(testUser));
          return signupCubit;
        },
        act: (cubit) => cubit.signInGoogle(),
        expect: () => [
          isA<SignupLoading>(),
          isA<SignupAuthenticated>().having((s) => s.user, 'user', testUser),
        ],
        verify: (_) {
          verify(() => mockSignInWithGoogle()).called(1);
        },
      );

      blocTest<SignupCubit, SignupState>(
        'emits [SignupLoading, SignupError] when Google sign in fails',
        build: () {
          when(() => mockSignInWithGoogle()).thenAnswer(
            (_) async => const Left(AuthFailure('Google sign in cancelled')),
          );
          return signupCubit;
        },
        act: (cubit) => cubit.signInGoogle(),
        expect: () => [
          isA<SignupLoading>(),
          isA<SignupError>()
              .having((s) => s.message, 'message', 'Google sign in cancelled'),
        ],
      );
    });

    group('sendEmailVerification', () {
      blocTest<SignupCubit, SignupState>(
        'emits [VerificationEmailSending, VerificationEmailSent] when succeeds',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => 'valid_token');
          when(() => mockSendVerificationEmail(token: any(named: 'token')))
              .thenAnswer((_) async => const Right(null));
          return signupCubit;
        },
        act: (cubit) => cubit.sendEmailVerification(testUser),
        expect: () => [
          isA<VerificationEmailSending>(),
          isA<VerificationEmailSent>()
              .having((s) => s.email, 'email', testEmail),
        ],
        verify: (_) {
          verify(() => mockSendVerificationEmail(token: 'valid_token'))
              .called(1);
        },
      );

      blocTest<SignupCubit, SignupState>(
        'emits [VerificationEmailSending, VerificationEmailError] when fails',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => 'valid_token');
          when(() => mockSendVerificationEmail(token: any(named: 'token')))
              .thenAnswer(
            (_) async => const Left(ServerFailure('Email service unavailable')),
          );
          return signupCubit;
        },
        act: (cubit) => cubit.sendEmailVerification(testUser),
        expect: () => [
          isA<VerificationEmailSending>(),
          isA<VerificationEmailError>()
              .having((s) => s.message, 'message', 'Email service unavailable'),
        ],
      );

      blocTest<SignupCubit, SignupState>(
        'uses empty token when no token available',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => null);
          when(() => mockSendVerificationEmail(token: any(named: 'token')))
              .thenAnswer((_) async => const Right(null));
          return signupCubit;
        },
        act: (cubit) => cubit.sendEmailVerification(testUser),
        verify: (_) {
          verify(() => mockSendVerificationEmail(token: '')).called(1);
        },
      );
    });

    group('resendEmailVerification', () {
      blocTest<SignupCubit, SignupState>(
        'emits [VerificationEmailSending, VerificationEmailSent] when succeeds',
        build: () {
          when(() => mockResendVerificationEmail(email: any(named: 'email')))
              .thenAnswer((_) async => const Right(null));
          return signupCubit;
        },
        act: (cubit) => cubit.resendEmailVerification(email: testEmail),
        expect: () => [
          isA<VerificationEmailSending>(),
          isA<VerificationEmailSent>()
              .having((s) => s.email, 'email', testEmail),
        ],
        verify: (_) {
          verify(() => mockResendVerificationEmail(email: testEmail)).called(1);
        },
      );

      blocTest<SignupCubit, SignupState>(
        'emits [VerificationEmailSending, VerificationEmailError] when fails',
        build: () {
          when(() => mockResendVerificationEmail(email: any(named: 'email')))
              .thenAnswer(
            (_) async => const Left(ServerFailure('Too many requests')),
          );
          return signupCubit;
        },
        act: (cubit) => cubit.resendEmailVerification(email: testEmail),
        expect: () => [
          isA<VerificationEmailSending>(),
          isA<VerificationEmailError>()
              .having((s) => s.message, 'message', 'Too many requests'),
        ],
      );
    });
  });
}
