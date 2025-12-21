import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/resend_verification_email.dart';
import '../../../domain/usecases/send_verification_email.dart';
import '../../../domain/usecases/signup.dart';
import '../../../domain/usecases/sign_in_with_google.dart';
import '../../../../../core/storage/secure_storage_service.dart';

// States
abstract class SignupState extends Equatable {
  const SignupState();
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final String email;
  const SignupSuccess(this.email);
  @override
  List<Object?> get props => [email];
}

class SignupAuthenticated extends SignupState {
  final User user;
  const SignupAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class SignupError extends SignupState {
  final String message;
  const SignupError(this.message);
  @override
  List<Object?> get props => [message];
}

class VerificationEmailSending extends SignupState {}

class VerificationEmailSent extends SignupState {
  final String email;
  const VerificationEmailSent(this.email);
  @override
  List<Object?> get props => [email];
}

class VerificationEmailError extends SignupState {
  final String message;
  const VerificationEmailError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class SignupCubit extends Cubit<SignupState> {
  final Signup signup;
  final SignInWithGoogle signInWithGoogle;
  final SendVerificationEmail sendVerificationEmail;
  final ResendVerificationEmail resendVerificationEmail;
  final SecureStorageService secureStorage;

  SignupCubit({
    required this.signup,
    required this.signInWithGoogle,
    required this.sendVerificationEmail,
    required this.resendVerificationEmail,
    required this.secureStorage,
  }) : super(SignupInitial());

  Future<void> signupWithEmail({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    emit(SignupLoading());

    final result = await signup(
      username: username,
      password: password,
      fullName: fullName,
      email: email,
    );

    result.fold(
      (failure) => emit(SignupError(failure.message)),
      (signupResponse) {
        if (signupResponse.success) {
          emit(SignupSuccess(email));
        } else {
          emit(SignupError(signupResponse.message));
        }
      },
    );
  }

  Future<void> signInGoogle() async {
    emit(SignupLoading());
    final result = await signInWithGoogle();

    result.fold(
      (failure) => emit(SignupError(failure.message)),
      (user) => emit(SignupAuthenticated(user)),
    );
  }

  Future<void> sendEmailVerification(User user) async {
    emit(VerificationEmailSending());

    final token = await secureStorage.getToken() ?? '';
    final result = await sendVerificationEmail(token: token);

    result.fold(
      (failure) => emit(VerificationEmailError(failure.message)),
      (_) => emit(VerificationEmailSent(user.email)),
    );
  }

  Future<void> resendEmailVerification({required String email}) async {
    emit(VerificationEmailSending());

    final result = await resendVerificationEmail(email: email);

    result.fold(
      (failure) => emit(VerificationEmailError(failure.message)),
      (_) => emit(VerificationEmailSent(email)),
    );
  }
}
