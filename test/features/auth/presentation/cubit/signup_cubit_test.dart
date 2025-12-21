import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/core/storage/secure_storage_service.dart';
import 'package:balance_iq/features/auth/data/models/auth_request_models.dart';
import 'package:balance_iq/features/auth/domain/entities/user.dart';
import 'package:balance_iq/features/auth/domain/usecases/resend_verification_email.dart';
import 'package:balance_iq/features/auth/domain/usecases/send_verification_email.dart';
import 'package:balance_iq/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:balance_iq/features/auth/domain/usecases/signup.dart';
import 'package:balance_iq/features/auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignup extends Mock implements Signup {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSendVerificationEmail extends Mock implements SendVerificationEmail {}

class MockResendVerificationEmail extends Mock
    implements ResendVerificationEmail {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late SignupCubit signupCubit;
  late MockSignup mockSignup;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockSendVerificationEmail mockSendVerificationEmail;
  late MockResendVerificationEmail mockResendVerificationEmail;
  late MockSecureStorageService mockSecureStorage;

  setUp(() {
    mockSignup = MockSignup();
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockSendVerificationEmail = MockSendVerificationEmail();
    mockResendVerificationEmail = MockResendVerificationEmail();
    mockSecureStorage = MockSecureStorageService();

    signupCubit = SignupCubit(
      signup: mockSignup,
      signInWithGoogle: mockSignInWithGoogle,
      sendVerificationEmail: mockSendVerificationEmail,
      resendVerificationEmail: mockResendVerificationEmail,
      secureStorage: mockSecureStorage,
    );
  });

  tearDown(() {
    signupCubit.close();
  });

  group('SignupCubit', () {
    const testEmail = 'test@example.com';
    const testUsername = 'testuser';
    const testPassword = 'password123';
    const testFullName = 'Test User';

    final testUser = User(
      id: '1',
      email: testEmail,
      name: testFullName,
      photoUrl: null,
      authProvider: 'email',
      createdAt: DateTime(2024, 1, 1),
      isEmailVerified: false,
    );

    final testSignupResponse = SignupResponse(
      success: true,
      message: 'Signup successful',
      timestamp: 1703001600,
    );

    test('initial state is SignupInitial', () {
      expect(signupCubit.state, isA<SignupInitial>());
    });

    blocTest<SignupCubit, SignupState>(
      'emits [SignupLoading, SignupSuccess] when signupWithEmail succeeds',
      build: () {
        when(() => mockSignup(
              username: testUsername,
              password: testPassword,
              fullName: testFullName,
              email: testEmail,
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
        isA<SignupSuccess>(),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits [SignupLoading, SignupError] when signupWithEmail fails',
      build: () {
        when(() => mockSignup(
                  username: testUsername,
                  password: testPassword,
                  fullName: testFullName,
                  email: testEmail,
                ))
            .thenAnswer(
                (_) async => const Left(ServerFailure('Email already exists')));
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
        isA<SignupError>(),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits [SignupLoading, SignupAuthenticated] when signInGoogle succeeds',
      build: () {
        when(() => mockSignInWithGoogle())
            .thenAnswer((_) async => Right(testUser));
        return signupCubit;
      },
      act: (cubit) => cubit.signInGoogle(),
      expect: () => [
        isA<SignupLoading>(),
        isA<SignupAuthenticated>(),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits [VerificationEmailSending, VerificationEmailSent] when sendEmailVerification succeeds',
      build: () {
        when(() => mockSecureStorage.getToken())
            .thenAnswer((_) async => 'test_token');
        when(() => mockSendVerificationEmail(token: 'test_token'))
            .thenAnswer((_) async => const Right(null));
        return signupCubit;
      },
      act: (cubit) => cubit.sendEmailVerification(testUser),
      expect: () => [
        isA<VerificationEmailSending>(),
        isA<VerificationEmailSent>(),
      ],
    );

    blocTest<SignupCubit, SignupState>(
      'emits [VerificationEmailSending, VerificationEmailSent] when resendEmailVerification succeeds',
      build: () {
        when(() => mockResendVerificationEmail(email: testEmail))
            .thenAnswer((_) async => const Right(null));
        return signupCubit;
      },
      act: (cubit) => cubit.resendEmailVerification(email: testEmail),
      expect: () => [
        isA<VerificationEmailSending>(),
        isA<VerificationEmailSent>(),
      ],
    );
  });
}
