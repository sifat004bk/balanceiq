import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../constants/app_constants.dart';

// Features - Auth
import '../../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/auth/domain/usecases/change_password.dart';
import '../../../features/auth/domain/usecases/forgot_password.dart';
import '../../../features/auth/domain/usecases/get_current_user.dart';
import '../../../features/auth/domain/usecases/get_profile.dart';
import '../../../features/auth/domain/usecases/login.dart';
import '../../../features/auth/domain/usecases/reset_password.dart';
import '../../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../../features/auth/domain/usecases/sign_out.dart';
import '../../../features/auth/domain/usecases/signup.dart';
import '../../../features/auth/domain/usecases/send_verification_email.dart';
import '../../../features/auth/domain/usecases/resend_verification_email.dart';

// Cubits
import '../../../features/auth/presentation/cubit/session/session_cubit.dart';
import '../../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../../features/auth/presentation/cubit/signup/signup_cubit.dart';
import '../../../features/auth/presentation/cubit/password/password_cubit.dart';

void registerAuthModule(GetIt sl) {
  sl.registerLazySingleton(
    () => GoogleSignIn(
      serverClientId:
          '1072498309198-dmvm3egt9ihkv1jseubu0b63v4ffdis2.apps.googleusercontent.com',
      scopes: [
        'email',
        'profile',
      ],
    ),
  );

  //! Features - Auth
  // Cubits

  // SessionCubit (Global)
  sl.registerLazySingleton(
    () => SessionCubit(
      getCurrentUser: sl(),
      signOutUseCase: sl(),
      getProfile: sl(),
      secureStorage: sl(),
    ),
  );

  // LoginCubit
  sl.registerFactory(
    () => LoginCubit(
      login: sl(),
      signInWithGoogle: sl(),
    ),
  );

  // SignupCubit
  sl.registerFactory(
    () => SignupCubit(
      signup: sl(),
      signInWithGoogle: sl(),
      sendVerificationEmail: sl(),
      resendVerificationEmail: sl(),
      secureStorage: sl(),
    ),
  );

  // PasswordCubit
  sl.registerFactory(
    () => PasswordCubit(
      changePassword: sl(),
      forgotPassword: sl(),
      resetPassword: sl(),
      secureStorage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => SendVerificationEmail(sl()));
  sl.registerLazySingleton(() => ResendVerificationEmail(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  // Conditionally register mock or real auth datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () {
      if (AppConstants.isMockMode) {
        print('🎭 [DI] Registering MOCK AuthRemoteDataSource');
        return AuthMockDataSource(
          sharedPreferences: sl(),
          uuid: sl(),
        );
      } else {
        print('🌐 [DI] Registering REAL AuthRemoteDataSource');
        return AuthRemoteDataSourceImpl(
          googleSignIn: sl(),
          dio: sl(),
          secureStorage: sl(),
        );
      }
    },
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl(), sl()),
  );
}
