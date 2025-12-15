import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// New states for password operations
class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthState {}

class PasswordResetSuccess extends AuthState {}

class SignupSuccess extends AuthState {
  final String email;

  const SignupSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

// Email verification states
class VerificationEmailSending extends AuthState {}

class VerificationEmailSent extends AuthState {
  final String email;

  const VerificationEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class VerificationEmailError extends AuthState {
  final String message;

  const VerificationEmailError(this.message);

  @override
  List<Object?> get props => [message];
}
