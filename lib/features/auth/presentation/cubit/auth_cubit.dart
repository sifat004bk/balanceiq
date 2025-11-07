import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/entities/user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUser;

  AuthCubit({
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.signOutUseCase,
    required this.getCurrentUser,
  }) : super(AuthInitial());

  // Check for existing session on app start
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

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

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  // Mock sign-in (always succeeds) - For development/testing
  Future<void> signInWithMock({required String email, required String name}) async {
    emit(AuthLoading());

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockUser = User(
      id: const Uuid().v4(),
      email: email,
      name: name,
      photoUrl: null,
      authProvider: 'mock',
      createdAt: DateTime.now(),
    );

    emit(AuthAuthenticated(mockUser));
  }
}
