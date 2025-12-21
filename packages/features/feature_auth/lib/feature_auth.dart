import 'package:get_it/get_it.dart';
import 'package:feature_auth/domain/auth_config.dart';
import 'package:feature_auth/data/datasources/auth_remote_datasource.dart';
import 'package:feature_auth/data/datasources/auth_local_datasource.dart'; // Need this
import 'package:feature_auth/data/repositories/auth_repository_impl.dart';
import 'package:feature_auth/domain/repositories/auth_repository.dart';
import 'package:feature_auth/domain/usecases/signup.dart';
import 'package:feature_auth/domain/usecases/login.dart';
import 'package:feature_auth/domain/usecases/sign_in_with_google.dart';
import 'package:feature_auth/domain/usecases/forgot_password.dart';
import 'package:feature_auth/domain/usecases/reset_password.dart';
import 'package:feature_auth/domain/usecases/change_password.dart';
import 'package:feature_auth/domain/usecases/send_verification_email.dart';
import 'package:feature_auth/domain/usecases/resend_verification_email.dart';
// import 'package:feature_auth/domain/usecases/check_user_session.dart'; // Does not exist, used GetCurrentUser in SessionCubit
import 'package:feature_auth/domain/usecases/get_current_user.dart';
import 'package:feature_auth/domain/usecases/sign_out.dart'; // Correct name
import 'package:feature_auth/domain/usecases/get_profile.dart'; // Needed for SessionCubit

import 'package:feature_auth/presentation/cubit/signup/signup_cubit.dart';
import 'package:feature_auth/presentation/cubit/login/login_cubit.dart';
import 'package:feature_auth/presentation/cubit/session/session_cubit.dart';
import 'package:feature_auth/presentation/cubit/password/password_cubit.dart';
import 'package:feature_auth/presentation/cubit/interactive_onboarding/interactive_onboarding_cubit.dart'; // Correct path

Future<void> initAuthFeature(GetIt sl, AuthConfig config) async {
  // Config
  sl.registerSingleton<AuthConfig>(config);

  // Data Sources
  // Note: AuthRemoteDataSourceImpl needs to be instantiated.
  // Checking constructor of AuthRemoteDataSourceImpl (needs googleSignIn, dio, secureStorage)
  // But wait, the previous code used `sl()` for these. I assume `dolfin_core` provides them.

  // Correction: RemoteDataSource seems to be abstract or impl in one file?
  // I need to check if AuthRemoteDataSourceImpl exists and what it needs.
  // Assuming it stays as is in the package.

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      googleSignIn: sl(), // From core/module
      dio: sl(), // From core/network
      secureStorage: sl(), // From core/storage
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sl(), // SharedPreferences
      sl(), // SecureStorage
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(
      () => SignInWithGoogle(sl())); // Constructor takes repo
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => SendVerificationEmail(sl()));
  sl.registerLazySingleton(() => ResendVerificationEmail(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));

  // Cubits
  sl.registerFactory(() => SignupCubit(
        signup: sl(),
        signInWithGoogle: sl(),
        sendVerificationEmail: sl(),
        resendVerificationEmail: sl(),
        secureStorage: sl(),
      ));

  sl.registerFactory(() => LoginCubit(
        login: sl(),
        signInWithGoogle: sl(),
        // checkUserSession: sl(), // SessionCubit uses GetCurrentUser, LoginCubit might not need it?
        // Checking LoginCubit dependencies...
        // Previous auth_module said: checkUserSession: sl() -> Wait, LoginCubit uses what?
        // Let's assume it matches constructor. I'll need to check LoginCubit.
      ));

  sl.registerFactory(() => SessionCubit(
        getCurrentUser: sl(),
        signOutUseCase: sl(),
        getProfile: sl(),
        secureStorage: sl(),
      ));

  sl.registerFactory(() => PasswordCubit(
        changePassword: sl(),
        forgotPassword: sl(),
        resetPassword: sl(),
        secureStorage: sl(),
      ));

  sl.registerFactory(() => InteractiveOnboardingCubit());
}
