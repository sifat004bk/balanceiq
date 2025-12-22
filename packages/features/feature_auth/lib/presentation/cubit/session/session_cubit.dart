import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/get_profile.dart';
import '../../../domain/usecases/sign_out.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

// States
abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class Authenticated extends SessionState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends SessionState {}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class SessionCubit extends Cubit<SessionState> {
  final GetCurrentUser getCurrentUser;
  final SignOut signOutUseCase;
  final GetProfile getProfile;
  final SecureStorageService secureStorage;

  SessionCubit({
    required this.getCurrentUser,
    required this.signOutUseCase,
    required this.getProfile,
    required this.secureStorage,
  }) : super(SessionInitial());

  /// Check for existing session on app start
  Future<void> checkAuthStatus() async {
    emit(SessionLoading());
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
          refreshUserProfile();
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  /// Logout the user
  Future<void> logout() async {
    emit(SessionLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(SessionError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  /// Refresh user profile from backend
  Future<void> refreshUserProfile() async {
    User? currentUser;
    if (state is Authenticated) {
      currentUser = (state as Authenticated).user;
    } else {
      return;
    }

    emit(SessionLoading());

    final token = await secureStorage.getToken() ?? '';

    if (token.isEmpty) {
      emit(Authenticated(currentUser));
      return;
    }

    final result = await getProfile(token);

    result.fold(
      (failure) {
        emit(Authenticated(currentUser!));
      },
      (userInfo) {
        final updatedUser = User(
          id: userInfo.id.toString(),
          email: userInfo.email,
          name: userInfo.fullName,
          photoUrl: userInfo.photoUrl,
          authProvider: 'email',
          createdAt: DateTime.now(),
          isEmailVerified: userInfo.isEmailVerified,
        );
        emit(Authenticated(updatedUser));
      },
    );
  }

  void updateUser(User user) {
    emit(Authenticated(user));
  }
}
