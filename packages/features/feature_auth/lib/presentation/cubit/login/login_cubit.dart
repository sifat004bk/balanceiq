import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/sign_in_with_google.dart';

// States
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  const LoginSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
  @override
  List<Object?> get props => [message];
}

// Cubit
class LoginCubit extends Cubit<LoginState> {
  final Login login;
  final SignInWithGoogle signInWithGoogle;

  LoginCubit({
    required this.login,
    required this.signInWithGoogle,
  }) : super(LoginInitial());

  Future<void> loginWithEmail({
    required String username,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await login(
      username: username,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (loginResponse) {
        if (loginResponse.success && loginResponse.data != null) {
          final user = User(
            id: loginResponse.data!.userId.toString(),
            email: loginResponse.data!.email,
            name: loginResponse.data!.username,
            photoUrl: null,
            authProvider: 'email',
            createdAt: DateTime.now(),
            isEmailVerified: loginResponse.data!.isEmailVerified,
          );
          emit(LoginSuccess(user));
        } else {
          emit(LoginError(loginResponse.message));
        }
      },
    );
  }

  Future<void> signInGoogle() async {
    emit(LoginLoading());
    final result = await signInWithGoogle();

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
