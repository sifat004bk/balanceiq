import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:feature_auth/presentation/cubit/password/password_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late PasswordCubit passwordCubit;
  late MockChangePassword mockChangePassword;
  late MockForgotPassword mockForgotPassword;
  late MockResetPassword mockResetPassword;
  late MockSecureStorageService mockSecureStorage;

  setUp(() {
    mockChangePassword = MockChangePassword();
    mockForgotPassword = MockForgotPassword();
    mockResetPassword = MockResetPassword();
    mockSecureStorage = MockSecureStorageService();

    passwordCubit = PasswordCubit(
      changePassword: mockChangePassword,
      forgotPassword: mockForgotPassword,
      resetPassword: mockResetPassword,
      secureStorage: mockSecureStorage,
    );
  });

  tearDown(() {
    passwordCubit.close();
  });

  group('PasswordCubit', () {
    const testEmail = 'test@example.com';
    const testCurrentPassword = 'OldPassword123!';
    const testNewPassword = 'NewPassword123!';
    const testConfirmPassword = 'NewPassword123!';
    const testToken = 'valid_token';
    const testResetToken = 'reset_token_123';

    test('initial state is PasswordInitial', () {
      expect(passwordCubit.state, isA<PasswordInitial>());
    });

    group('changeUserPassword', () {
      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordChanged] when password change succeeds',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => testToken);
          when(() => mockChangePassword(
                currentPassword: any(named: 'currentPassword'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          return passwordCubit;
        },
        act: (cubit) => cubit.changeUserPassword(
          currentPassword: testCurrentPassword,
          newPassword: testNewPassword,
          confirmPassword: testConfirmPassword,
        ),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordChanged>(),
        ],
        verify: (_) {
          verify(() => mockChangePassword(
                currentPassword: testCurrentPassword,
                newPassword: testNewPassword,
                confirmPassword: testConfirmPassword,
                token: testToken,
              )).called(1);
        },
      );

      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordError] when password change fails',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => testToken);
          when(() => mockChangePassword(
                currentPassword: any(named: 'currentPassword'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
                token: any(named: 'token'),
              )).thenAnswer(
            (_) async => const Left(AuthFailure('Current password is incorrect')),
          );
          return passwordCubit;
        },
        act: (cubit) => cubit.changeUserPassword(
          currentPassword: testCurrentPassword,
          newPassword: testNewPassword,
          confirmPassword: testConfirmPassword,
        ),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordError>()
              .having((s) => s.message, 'message', 'Current password is incorrect'),
        ],
      );

      blocTest<PasswordCubit, PasswordState>(
        'uses empty token when no token available',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => null);
          when(() => mockChangePassword(
                currentPassword: any(named: 'currentPassword'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          return passwordCubit;
        },
        act: (cubit) => cubit.changeUserPassword(
          currentPassword: testCurrentPassword,
          newPassword: testNewPassword,
          confirmPassword: testConfirmPassword,
        ),
        verify: (_) {
          verify(() => mockChangePassword(
                currentPassword: testCurrentPassword,
                newPassword: testNewPassword,
                confirmPassword: testConfirmPassword,
                token: '',
              )).called(1);
        },
      );

      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordError] on validation failure',
        build: () {
          when(() => mockSecureStorage.getToken())
              .thenAnswer((_) async => testToken);
          when(() => mockChangePassword(
                currentPassword: any(named: 'currentPassword'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
                token: any(named: 'token'),
              )).thenAnswer(
            (_) async => const Left(ValidationFailure('Passwords do not match')),
          );
          return passwordCubit;
        },
        act: (cubit) => cubit.changeUserPassword(
          currentPassword: testCurrentPassword,
          newPassword: testNewPassword,
          confirmPassword: 'DifferentPassword123!',
        ),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordError>()
              .having((s) => s.message, 'message', 'Passwords do not match'),
        ],
      );
    });

    group('requestPasswordReset', () {
      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordEmailSent] when password reset request succeeds',
        build: () {
          when(() => mockForgotPassword(email: any(named: 'email')))
              .thenAnswer((_) async => const Right(null));
          return passwordCubit;
        },
        act: (cubit) => cubit.requestPasswordReset(email: testEmail),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordEmailSent>().having((s) => s.email, 'email', testEmail),
        ],
        verify: (_) {
          verify(() => mockForgotPassword(email: testEmail)).called(1);
        },
      );

      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordError] when password reset request fails',
        build: () {
          when(() => mockForgotPassword(email: any(named: 'email'))).thenAnswer(
            (_) async => const Left(ServerFailure('User not found')),
          );
          return passwordCubit;
        },
        act: (cubit) => cubit.requestPasswordReset(email: testEmail),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordError>()
              .having((s) => s.message, 'message', 'User not found'),
        ],
      );

      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordError] on network failure',
        build: () {
          when(() => mockForgotPassword(email: any(named: 'email'))).thenAnswer(
            (_) async => const Left(NetworkFailure('No internet connection')),
          );
          return passwordCubit;
        },
        act: (cubit) => cubit.requestPasswordReset(email: testEmail),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordError>()
              .having((s) => s.message, 'message', 'No internet connection'),
        ],
      );
    });

    group('resetUserPassword', () {
      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordResetSuccess] when password reset succeeds',
        build: () {
          when(() => mockResetPassword(
                token: any(named: 'token'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
              )).thenAnswer((_) async => const Right(null));
          return passwordCubit;
        },
        act: (cubit) => cubit.resetUserPassword(
          token: testResetToken,
          newPassword: testNewPassword,
          confirmPassword: testConfirmPassword,
        ),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordResetSuccess>(),
        ],
        verify: (_) {
          verify(() => mockResetPassword(
                token: testResetToken,
                newPassword: testNewPassword,
                confirmPassword: testConfirmPassword,
              )).called(1);
        },
      );

      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordError] when password reset fails',
        build: () {
          when(() => mockResetPassword(
                token: any(named: 'token'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
              )).thenAnswer(
            (_) async => const Left(AuthFailure('Invalid or expired token')),
          );
          return passwordCubit;
        },
        act: (cubit) => cubit.resetUserPassword(
          token: testResetToken,
          newPassword: testNewPassword,
          confirmPassword: testConfirmPassword,
        ),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordError>()
              .having((s) => s.message, 'message', 'Invalid or expired token'),
        ],
      );

      blocTest<PasswordCubit, PasswordState>(
        'emits [PasswordLoading, PasswordError] on validation failure',
        build: () {
          when(() => mockResetPassword(
                token: any(named: 'token'),
                newPassword: any(named: 'newPassword'),
                confirmPassword: any(named: 'confirmPassword'),
              )).thenAnswer(
            (_) async => const Left(ValidationFailure('Password too weak')),
          );
          return passwordCubit;
        },
        act: (cubit) => cubit.resetUserPassword(
          token: testResetToken,
          newPassword: 'weak',
          confirmPassword: 'weak',
        ),
        expect: () => [
          isA<PasswordLoading>(),
          isA<PasswordError>()
              .having((s) => s.message, 'message', 'Password too weak'),
        ],
      );
    });
  });
}
