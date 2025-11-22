import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_in_with_apple.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/entities/user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // OAuth dependencies
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUser;

  // Backend API dependencies
  final Signup signup;
  final Login login;
  final GetProfile getProfile;
  final ChangePassword changePassword;
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;

  AuthCubit({
    // OAuth dependencies
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.signOutUseCase,
    required this.getCurrentUser,
    // Backend API dependencies
    required this.signup,
    required this.login,
    required this.getProfile,
    required this.changePassword,
    required this.forgotPassword,
    required this.resetPassword,
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

  /// Login with email/username and password using backend API
  Future<void> loginWithEmail({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await login(
      username: username,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        if (authResponse.success && authResponse.user != null) {
          // Convert UserInfo to User entity
          final user = User(
            id: authResponse.user!.id,
            email: authResponse.user!.email,
            name: authResponse.user!.fullName,
            photoUrl: authResponse.user!.photoUrl,
            authProvider: 'email',
            createdAt: DateTime.now(),
          );

          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError(authResponse.message ?? 'Login failed'));
        }
      },
    );
  }

  /// Sign up with email and password using backend API
  Future<void> signupWithEmail({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    emit(AuthLoading());

    final result = await signup(
      username: username,
      password: password,
      fullName: fullName,
      email: email,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResponse) {
        if (authResponse.success) {
          // Auto-login after signup if user data is returned
          if (authResponse.user != null) {
            final user = User(
              id: authResponse.user!.id,
              email: authResponse.user!.email,
              name: authResponse.user!.fullName,
              photoUrl: authResponse.user!.photoUrl,
              authProvider: 'email',
              createdAt: DateTime.now(),
            );
            emit(AuthAuthenticated(user));
          } else {
            // Show success, may require email verification
            emit(SignupSuccess(email));
          }
        } else {
          emit(AuthError(authResponse.message ?? 'Signup failed'));
        }
      },
    );
  }

  /// Get current user profile from backend
  Future<void> getUserProfile() async {
    emit(AuthLoading());

    // TODO: Implement token storage and retrieval
    final result = await getProfile('');

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (userInfo) {
        final user = User(
          id: userInfo.id,
          email: userInfo.email,
          name: userInfo.fullName,
          photoUrl: userInfo.photoUrl,
          authProvider: 'email',
          createdAt: DateTime.now(),
        );
        emit(AuthAuthenticated(user));
      },
    );
  }

  /// Change password for currently authenticated user
  Future<void> changeUserPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    // TODO: Implement token storage and retrieval
    final result = await changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      token: '',
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(PasswordChanged()),
    );
  }

  /// Request password reset email
  Future<void> requestPasswordReset({required String email}) async {
    emit(AuthLoading());

    final result = await forgotPassword(email: email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(PasswordResetEmailSent(email)),
    );
  }

  /// Reset password with token from email
  Future<void> resetUserPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    final result = await resetPassword(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(PasswordResetSuccess()),
    );
  }
}
