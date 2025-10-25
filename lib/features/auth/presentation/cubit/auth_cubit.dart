import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;

  AuthCubit({
    required this.signInWithGoogle,
    required this.signInWithApple,
  }) : super(AuthInitial());

  Future<void> signInGoogle() async {
    emit(AuthLoading());
    final result = await signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signInApple() async {
    emit(AuthLoading());
    final result = await signInWithApple();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  void signOut() {
    emit(AuthUnauthenticated());
  }
}
