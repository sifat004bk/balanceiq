import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/features/chat/data/datasources/chat_finance_guru_datasource.dart';
import 'package:balance_iq/features/chat/data/datasources/chat_mock_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_finance_guru_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_mock_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import 'package:balance_iq/features/home/data/repository/dashboard_repository_impl.dart';
import 'package:balance_iq/features/home/domain/repository/dashboard_repository.dart';
import 'package:balance_iq/features/home/domain/usecase/get_user_dashbaord.dart';
import 'package:balance_iq/features/home/domain/usecases/delete_transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_cubit.dart';
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
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/signup.dart';
import '../../features/auth/domain/usecases/send_verification_email.dart';
import '../../features/auth/domain/usecases/resend_verification_email.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
// Features - Chat
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_chat_history.dart';
import '../../features/chat/domain/usecases/get_messages.dart';
import '../../features/chat/domain/usecases/send_message.dart';
import '../../features/chat/domain/usecases/update_message.dart';
import '../../features/chat/domain/usecases/get_token_usage.dart';
import '../../features/chat/domain/usecases/submit_feedback.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/chat/data/datasources/token_usage_datasource.dart';
import '../../features/chat/data/datasources/token_usage_mock_datasource.dart';
import '../../features/chat/data/datasources/chat_feedback_datasource.dart';
import '../../features/chat/data/repositories/token_usage_repository_impl.dart';
import '../../features/chat/data/repositories/chat_feedback_repository_impl.dart';
import '../../features/chat/domain/repositories/token_usage_repository.dart';
import '../../features/chat/domain/repositories/chat_feedback_repository.dart';
// Features - Home (Transaction Search)
import '../../features/home/data/datasource/remote_datasource/transaction_search_datasource.dart';
import '../../features/home/data/repositories/transaction_repository_impl.dart';
import '../../features/home/domain/repositories/transaction_repository.dart';
import '../../features/home/domain/usecases/search_transactions.dart';
// Core
import '../../features/home/domain/usecases/update_transaction.dart';
import '../database/database_helper.dart';
// Features - Subscription
import '../../features/subscription/data/datasources/subscription_datasource.dart';
import '../../features/subscription/data/repositories/subscription_repository_impl.dart';
import '../../features/subscription/domain/repositories/subscription_repository.dart';
import '../../features/subscription/domain/usecases/get_all_plans.dart';
import '../../features/subscription/domain/usecases/get_subscription_status.dart';
import '../../features/subscription/domain/usecases/create_subscription.dart';
import '../../features/subscription/presentation/cubit/subscription_cubit.dart';
import '../network/logging_interceptor.dart';
import '../network/auth_interceptor.dart';
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
    
    // Add AuthInterceptor - Instantiate directly to pass the dio instance and avoid circular dependency
    dio.interceptors.add(AuthInterceptor(
      sharedPreferences: sl(),
      dio: dio,
    ));

    return dio;
  });

  sl.registerLazySingleton(
    () => GoogleSignIn(
      clientId:
          '1072498309198-vvl8ij402i0da40e9fhl06102b6n45u2.apps.googleusercontent.com',
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
      signOutUseCase: sl(),
      getCurrentUser: sl(),
      // Backend API dependencies
      signup: sl(),
      login: sl(),
      getProfile: sl(),
      changePassword: sl(),
      forgotPassword: sl(),
      resetPassword: sl(),
      // Email verification
      sendVerificationEmail: sl(),
      resendVerificationEmail: sl(),
      sharedPreferences: sl(),
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
      getChatHistory: sl(),
      getTokenUsage: sl(),
      sendMessage: sl(),
      updateMessage: sl(),
      submitFeedback: sl(),
      sharedPreferences: sl(),
      uuid: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => UpdateMessage(sl()));
  sl.registerLazySingleton(() => GetChatHistory(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      sharedPreferences: sl(),
      uuid: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sl()),
  );

  // Conditionally register mock or real API chat datasource
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () {
      if (AppConstants.isMockMode) {
        print('🎭 [DI] Registering MOCK ChatRemoteDataSource');
        return ChatMockDataSource(sl());
      } else {
        print(
            '🌐 [DI] Registering REAL ChatRemoteDataSource (Finance Guru API)');
        return ChatFinanceGuruDataSource(sl(), sl());
      }
    },
  );

  //! Features - Dashboard
  // Cubit
  sl.registerFactory(() => DashboardCubit(getDashboardSummary: sl()));
  sl.registerFactory(
    () => TransactionsCubit(
      searchTransactions: sl(),
      updateTransactionUseCase: sl(),
      deleteTransactionUseCase: sl(),
    ),
  );

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
  // Conditionally register mock or real API dashboard datasource
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () {
      if (AppConstants.isMockMode) {
        print('🎭 [DI] Registering MOCK DashboardRemoteDataSource');
        return DashboardMockDataSource();
      } else {
        print(
            '🌐 [DI] Registering REAL DashboardRemoteDataSource (Finance Guru API)');
        return DashboardFinanceGuruDataSource(sl(), sl());
      }
    },
  );

  //! Features - Transaction Search
  // Use cases
  sl.registerLazySingleton(() => SearchTransactions(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TransactionSearchDataSource>(
    () => TransactionSearchDataSourceImpl(sl(), sl()),
  );

  //! Features - Chat Feedback
  // Use cases
  sl.registerLazySingleton(() => SubmitFeedback(sl()));

  // Repository
  sl.registerLazySingleton<ChatFeedbackRepository>(
    () => ChatFeedbackRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ChatFeedbackDataSource>(
    () => ChatFeedbackDataSourceImpl(sl(), sl()),
  );

  //! Features - Token Usage
  // Use cases
  sl.registerLazySingleton(() => GetTokenUsage(sl()));

  // Repository
  sl.registerLazySingleton<TokenUsageRepository>(
    () => TokenUsageRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  // Conditionally register mock or real token usage data source
  sl.registerLazySingleton<TokenUsageDataSource>(
    () {
      if (AppConstants.isMockMode) {
        print('🎭 [DI] Registering MOCK TokenUsageDataSource');
        return TokenUsageMockDataSource();
      } else {
        print(
            '🌐 [DI] Registering REAL TokenUsageDataSource (Finance Guru API)');
        return TokenUsageDataSourceImpl(sl(), sl());
      }
    },
  );

  //! Features - Subscription
  // Data sources
  sl.registerLazySingleton<SubscriptionDataSource>(
    () => SubscriptionDataSourceImpl(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllPlans(sl()));
  sl.registerLazySingleton(() => GetSubscriptionStatus(sl()));
  sl.registerLazySingleton(() => CreateSubscription(sl()));

  // Cubit
  sl.registerFactory(
    () => SubscriptionCubit(
      getAllPlansUseCase: sl(),
      getSubscriptionStatusUseCase: sl(),
      createSubscriptionUseCase: sl(),
    ),
  );
}

