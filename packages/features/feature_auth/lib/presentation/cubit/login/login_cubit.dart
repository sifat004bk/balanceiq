import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/sign_in_with_google.dart';
import '../../../domain/usecases/get_profile.dart';
import '../../../domain/usecases/save_user.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

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
  final GetProfile getProfile;
  final SaveUser saveUser;
  final CurrencyCubit currencyCubit;
  final SecureStorageService secureStorage;

  LoginCubit({
    required this.login,
    required this.signInWithGoogle,
    required this.getProfile,
    required this.saveUser,
    required this.currencyCubit,
    required this.secureStorage,
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

    await result.fold(
      (failure) async => emit(LoginError(failure.message)),
      (loginResponse) async {
        if (loginResponse.success && loginResponse.data != null) {
          final token = loginResponse.data!.token;

          // Fetch full profile
          final profileResult = await getProfile(token);

          await profileResult.fold(
            (failure) async {
              debugPrint(
                  '[LoginCubit] Profile fetch failed: ${failure.message}');
              // Fallback to basic user info if profile fetch fails
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
            },
            (userInfo) async {
              debugPrint(
                  '[LoginCubit] Profile fetch success. Currency: ${userInfo.currency}');

              // Sync currency to app state
              if (userInfo.currency != null && userInfo.currency!.isNotEmpty) {
                await currencyCubit.setCurrencyByCode(userInfo.currency!);
              }

              final user = User(
                id: userInfo.id.toString(),
                email: userInfo.email,
                name: userInfo.fullName,
                photoUrl: userInfo.photoUrl,
                currency: userInfo.currency,
                authProvider: 'email',
                createdAt: DateTime.now(),
                isEmailVerified: userInfo.isEmailVerified,
              );

              // Cache the full user profile
              await saveUser(user);

              emit(LoginSuccess(user));
            },
          );
        } else {
          emit(LoginError(loginResponse.message));
        }
      },
    );
  }

  Future<void> signInGoogle() async {
    emit(LoginLoading());
    final result = await signInWithGoogle();

    await result.fold(
      (failure) async => emit(LoginError(failure.message)),
      (googleUser) async {
        // Google sign-in succeeded, now fetch full profile to get currency etc.
        // The token was saved during signInWithGoogle in AuthRemoteDataSource.
        final token = await secureStorage.getToken();

        if (token != null && token.isNotEmpty) {
          // Fetch full profile
          final profileResult = await getProfile(token);

          await profileResult.fold(
            (failure) async {
              debugPrint(
                  '[LoginCubit] Google profile fetch failed: ${failure.message}');
              // Fallback to basic Google user info
              await saveUser(googleUser);
              emit(LoginSuccess(googleUser));
            },
            (userInfo) async {
              debugPrint(
                  '[LoginCubit] Google profile fetch success. Currency: ${userInfo.currency}');

              // Sync currency to app state
              if (userInfo.currency != null && userInfo.currency!.isNotEmpty) {
                await currencyCubit.setCurrencyByCode(userInfo.currency!);
              }

              final user = User(
                id: userInfo.id.toString(),
                email: userInfo.email,
                name: userInfo.fullName,
                photoUrl: userInfo.photoUrl ?? googleUser.photoUrl,
                currency: userInfo.currency,
                authProvider: 'google',
                createdAt: DateTime.now(),
                isEmailVerified: userInfo.isEmailVerified,
              );

              // Cache the full user profile
              await saveUser(user);
              emit(LoginSuccess(user));
            },
          );
        } else {
          // No token available, fallback to basic user
          debugPrint(
              '[LoginCubit] No token after Google sign-in, using basic user');
          await saveUser(googleUser);
          emit(LoginSuccess(googleUser));
        }
      },
    );
  }
}
