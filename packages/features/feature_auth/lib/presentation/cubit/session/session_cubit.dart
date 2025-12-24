import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/get_profile.dart';
import '../../../domain/usecases/sign_out.dart';
import '../../../domain/usecases/update_currency.dart';
import '../../../domain/usecases/save_user.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';

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
  final UpdateCurrency updateCurrencyUseCase;
  final SaveUser saveUser;
  final SecureStorageService secureStorage;
  final CurrencyCubit currencyCubit;

  SessionCubit({
    required this.getCurrentUser,
    required this.signOutUseCase,
    required this.getProfile,
    required this.updateCurrencyUseCase,
    required this.saveUser,
    required this.secureStorage,
    required this.currencyCubit,
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
      (_) async {
        await currencyCubit.reset();
        emit(Unauthenticated());
      },
    );
  }

  /// Refresh user profile from backend
  Future<void> refreshUserProfile() async {
    User? currentUser;
    if (state is Authenticated) {
      currentUser = (state as Authenticated).user;
    } else {
      // If not authenticated, try to use current user if available or just proceed if token exists
      final token = await secureStorage.getToken();
      if (token == null || token.isEmpty) {
        return;
      }

      // We have a token, but state is not Authenticated.
      // This implies we might be in Initial state but valid session exists.
      // We will let getProfile fetch the user data.
    }

    emit(SessionLoading());

    // Fallback: If token not defined, retrieve it again (though we did above, scope is different)
    // Actually, I removed the token line by mistake in previous edit.
    final token = await secureStorage.getToken() ?? '';

    if (token.isEmpty) {
      if (currentUser != null) {
        emit(Authenticated(currentUser));
      } else {
        emit(Unauthenticated());
      }
      return;
    }

    final result = await getProfile(token);

    result.fold(
      (failure) {
        if (currentUser != null) {
          emit(Authenticated(currentUser!));
        } else {
          // If we failed to get profile and don't have current user, emit error
          emit(SessionError(failure.message));
        }
      },
      (userInfo) async {
        final updatedUser = User(
          id: userInfo.id.toString(),
          email: userInfo.email,
          name: userInfo.fullName,
          photoUrl: userInfo.photoUrl,
          currency: userInfo.currency,
          // If authProvider not in userInfo, fallback to current user's provider or 'email'
          authProvider: currentUser?.authProvider ?? 'email',
          // Keep original createdAt or fallback to now if not available (userInfo doesn't have it?)
          createdAt: currentUser?.createdAt ?? DateTime.now(),
          isEmailVerified: userInfo.isEmailVerified,
        );

        // Sync currency to app state
        if (userInfo.currency != null && userInfo.currency!.isNotEmpty) {
          await currencyCubit.setCurrencyByCode(userInfo.currency!);
        }

        // Save updated user to cache
        await saveUser(updatedUser);

        emit(Authenticated(updatedUser));
      },
    );
  }

  void updateUser(User user) {
    emit(Authenticated(user));
  }

  /// Update user currency preference
  Future<void> updateUserCurrency(String currency) async {
    // We don't emit loading here to avoid disrupting the UI
    // The UI (ProfilePage) handles the local state update immediately
    // This is just to sync with backend
    try {
      final result = await updateCurrencyUseCase(currency);
      result.fold(
        (failure) {
          // Optionally emit error or just log
          // emit(SessionError(failure.message));
          // Better to not break session for this background sync
        },
        (_) {
          // Success
        },
      );
    } catch (_) {
      // Ignore
    }
  }
}
