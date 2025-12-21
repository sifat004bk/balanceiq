import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/core/storage/secure_storage_service.dart';
import 'package:balance_iq/features/auth/domain/usecases/change_password.dart';
import 'package:balance_iq/features/auth/domain/usecases/forgot_password.dart';
import 'package:balance_iq/features/auth/domain/usecases/reset_password.dart';
import 'package:balance_iq/features/auth/presentation/cubit/password/password_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChangePassword extends Mock implements ChangePassword {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockResetPassword extends Mock implements ResetPassword {}

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
    const testToken = 'reset_token_123';
    const testCurrentPassword = 'oldPassword';
    const testNewPassword = 'newPassword123';
    const testConfirmPassword = 'newPassword123';

    test('initial state is PasswordInitial', () {
      expect(passwordCubit.state, isA<PasswordInitial>());
    });

    blocTest<PasswordCubit, PasswordState>(
      'emits [PasswordLoading, PasswordChanged] when changeUserPassword succeeds',
      build: () {
        when(() => mockSecureStorage.getToken())
            .thenAnswer((_) async => 'auth_token');
        when(() => mockChangePassword(
              currentPassword: testCurrentPassword,
              newPassword: testNewPassword,
              confirmPassword: testConfirmPassword,
              token: 'auth_token',
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
    );

    blocTest<PasswordCubit, PasswordState>(
      'emits [PasswordLoading, PasswordError] when changeUserPassword fails',
      build: () {
        when(() => mockSecureStorage.getToken())
            .thenAnswer((_) async => 'auth_token');
        when(() => mockChangePassword(
                  currentPassword: testCurrentPassword,
                  newPassword: testNewPassword,
                  confirmPassword: testConfirmPassword,
                  token: 'auth_token',
                ))
            .thenAnswer(
                (_) async => const Left(ServerFailure('Incorrect password')));
        return passwordCubit;
      },
      act: (cubit) => cubit.changeUserPassword(
        currentPassword: testCurrentPassword,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      ),
      expect: () => [
        isA<PasswordLoading>(),
        isA<PasswordError>(),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'emits [PasswordLoading, PasswordEmailSent] when requestPasswordReset succeeds',
      build: () {
        when(() => mockForgotPassword(email: testEmail))
            .thenAnswer((_) async => const Right(null));
        return passwordCubit;
      },
      act: (cubit) => cubit.requestPasswordReset(email: testEmail),
      expect: () => [
        isA<PasswordLoading>(),
        isA<PasswordEmailSent>(),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'emits [PasswordLoading, PasswordError] when requestPasswordReset fails',
      build: () {
        when(() => mockForgotPassword(email: testEmail)).thenAnswer(
            (_) async => const Left(ServerFailure('User not found')));
        return passwordCubit;
      },
      act: (cubit) => cubit.requestPasswordReset(email: testEmail),
      expect: () => [
        isA<PasswordLoading>(),
        isA<PasswordError>(),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'emits [PasswordLoading, PasswordResetSuccess] when resetUserPassword succeeds',
      build: () {
        when(() => mockResetPassword(
              token: testToken,
              newPassword: testNewPassword,
              confirmPassword: testConfirmPassword,
            )).thenAnswer((_) async => const Right(null));
        return passwordCubit;
      },
      act: (cubit) => cubit.resetUserPassword(
        token: testToken,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      ),
      expect: () => [
        isA<PasswordLoading>(),
        isA<PasswordResetSuccess>(),
      ],
    );

    blocTest<PasswordCubit, PasswordState>(
      'emits [PasswordLoading, PasswordError] when resetUserPassword fails',
      build: () {
        when(() => mockResetPassword(
                  token: testToken,
                  newPassword: testNewPassword,
                  confirmPassword: testConfirmPassword,
                ))
            .thenAnswer(
                (_) async => const Left(ServerFailure('Invalid token')));
        return passwordCubit;
      },
      act: (cubit) => cubit.resetUserPassword(
        token: testToken,
        newPassword: testNewPassword,
        confirmPassword: testConfirmPassword,
      ),
      expect: () => [
        isA<PasswordLoading>(),
        isA<PasswordError>(),
      ],
    );
  });
}
