import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/features/chat/data/datasources/chat_finance_guru_datasource.dart';
import 'package:balance_iq/features/chat/data/datasources/chat_mock_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_finance_guru_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_mock_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import 'package:balance_iq/features/home/data/repository/dashboard_repository_impl.dart';
import 'package:balance_iq/features/home/domain/repository/dashboard_repository.dart';
import 'package:balance_iq/features/home/domain/usecase/get_user_dashbaord.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// Features - Auth
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_mock_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/change_password.dart';
import '../../features/auth/domain/usecases/forgot_password.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/get_profile.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/reset_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_apple.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/signup.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
// Features - Chat
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_chat_history.dart';
import '../../features/chat/domain/usecases/get_messages.dart';
import '../../features/chat/domain/usecases/send_message.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
// Core
import '../database/database_helper.dart';
import '../network/logging_interceptor.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External - Must be registered first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Configure Dio with logging interceptor (only logs in debug mode)
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // Add logging interceptor - only logs in debug mode, no logs in release
    dio.interceptors.add(LoggingInterceptor());

    return dio;
  });

  sl.registerLazySingleton(
    () => GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
    ),
  );

  //! Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  sl.registerLazySingleton(() => const Uuid());

  //! Core - Theme
  sl.registerFactory(() => ThemeCubit(sl()));

  //! Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      // OAuth dependencies
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      signOutUseCase: sl(),
      getCurrentUser: sl(),
      // Backend API dependencies
      signup: sl(),
      login: sl(),
      getProfile: sl(),
      changePassword: sl(),
      forgotPassword: sl(),
      resetPassword: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithApple(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));

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
          sharedPreferences: sl(),
        );
      }
    },
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  //! Features - Chat
  // Cubit
  sl.registerFactory(
    () => ChatCubit(
      getMessages: sl(),
      sendMessage: sl(),
      uuid: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => GetChatHistory(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      uuid: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sl()),
  );

  // Conditionally register mock, finance-guru, or n8n chat datasource
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () {
      if (AppConstants.isMockMode) {
        print('🎭 [DI] Registering MOCK ChatRemoteDataSource');
        return ChatMockDataSource();
      } else if (AppConstants.useFinanceGuruAPI) {
        print('🏦 [DI] Registering Finance Guru ChatRemoteDataSource');
        return ChatFinanceGuruDataSource(sl(), sl());
      } else {
        print('🌊 [DI] Registering n8n ChatRemoteDataSource');
        return ChatRemoteDataSourceImpl(sl(), sl());
      }
    },
  );

  //! Features - Dashboard
  // Cubit
  sl.registerFactory(() => DashboardCubit(getDashboardSummary: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetDashboardSummary(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
      authLocalDataSource: sl(), // Use existing AuthLocalDataSource
    ),
  );

  // Data sources
  // Conditionally register mock, finance-guru, or n8n dashboard datasource
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () {
      if (AppConstants.isMockMode) {
        print('🎭 [DI] Registering MOCK DashboardRemoteDataSource');
        return DashboardMockDataSource();
      } else if (AppConstants.useFinanceGuruAPI) {
        print('🏦 [DI] Registering Finance Guru DashboardRemoteDataSource');
        return DashboardFinanceGuruDataSource(sl(), sl());
      } else {
        print('🌊 [DI] Registering n8n DashboardRemoteDataSource');
        return DashboardRemoteDataSourceImpl(sl());
      }
    },
  );
}
