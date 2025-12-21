import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/change_password.dart';
import '../../../domain/usecases/forgot_password.dart';
import '../../../domain/usecases/reset_password.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

// States
abstract class PasswordState extends Equatable {
  const PasswordState();
  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordEmailSent extends PasswordState {
  final String email;
  const PasswordEmailSent(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordResetSuccess extends PasswordState {}

class PasswordChanged extends PasswordState {}

class PasswordError extends PasswordState {
  final String message;
  const PasswordError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class PasswordCubit extends Cubit<PasswordState> {
  final ChangePassword changePassword;
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;
  final SecureStorageService secureStorage;

  PasswordCubit({
    required this.changePassword,
    required this.forgotPassword,
    required this.resetPassword,
    required this.secureStorage,
  }) : super(PasswordInitial());

  /// Change password for currently authenticated user
  Future<void> changeUserPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(PasswordLoading());

    final token = await secureStorage.getToken() ?? '';
    final result = await changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      token: token,
    );

    result.fold(
      (failure) => emit(PasswordError(failure.message)),
      (_) => emit(PasswordChanged()),
    );
  }

  /// Request password reset email
  Future<void> requestPasswordReset({required String email}) async {
    emit(PasswordLoading());

    final result = await forgotPassword(email: email);

    result.fold(
      (failure) => emit(PasswordError(failure.message)),
      (_) => emit(PasswordEmailSent(email)),
    );
  }

  /// Reset password with token from email
  Future<void> resetUserPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(PasswordLoading());

    final result = await resetPassword(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(PasswordError(failure.message)),
      (_) => emit(PasswordResetSuccess()),
    );
  }
}
