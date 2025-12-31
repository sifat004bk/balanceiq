import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/database/database_helper.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

import 'package:dolfin_core/utils/app_logger.dart';

import 'package:feature_chat/presentation/chat_config.dart';
import 'package:feature_chat/data/datasources/chat_local_datasource.dart';
import 'package:feature_chat/data/datasources/chat_remote_datasource.dart';
import 'package:feature_chat/data/datasources/chat_finance_guru_datasource.dart';
import 'package:feature_chat/data/datasources/chat_mock_datasource.dart';
import 'package:feature_chat/data/repositories/chat_repository_impl.dart';
import 'package:feature_chat/domain/repositories/chat_repository.dart';
import 'package:feature_chat/domain/usecases/get_chat_history.dart';
import 'package:feature_chat/domain/usecases/get_messages.dart';
import 'package:feature_chat/domain/usecases/send_message.dart';
import 'package:feature_chat/domain/usecases/update_message.dart';
import 'package:feature_chat/domain/usecases/get_message_usage.dart';
import 'package:feature_chat/domain/usecases/submit_feedback.dart';
import 'package:feature_chat/presentation/cubit/chat_cubit.dart';
import 'package:feature_chat/data/datasources/message_usage_datasource.dart';
import 'package:feature_chat/data/datasources/message_usage_mock_datasource.dart';
import 'package:feature_chat/data/datasources/chat_feedback_datasource.dart';

import 'package:feature_chat/data/repositories/message_usage_repository_impl.dart';
import 'package:feature_chat/data/repositories/chat_feedback_repository_impl.dart';
import 'package:feature_chat/domain/repositories/message_usage_repository.dart';
import 'package:feature_chat/domain/repositories/chat_feedback_repository.dart';

// Re-export common types
export 'package:feature_chat/presentation/chat_config.dart';
export 'package:feature_chat/presentation/pages/chat_page.dart';
export 'package:feature_chat/presentation/cubit/chat_cubit.dart';

/// Configuration for initializing the Chat feature.
///
/// All parameters are required to ensure the feature has everything it needs.
class ChatFeatureConfig {
  /// Configuration for Chat UI (e.g. suggested prompts)
  final ChatConfig chatConfig;

  /// HTTP Client
  final Dio dio;

  /// Secure storage for auth tokens
  final SecureStorageService secureStorage;

  /// Shared preferences for local settings
  final SharedPreferences sharedPreferences;

  /// Local database for caching messages
  final DatabaseHelper databaseHelper;

  /// App constants (API endpoints, bot IDs)
  final AppConstants appConstants;

  /// UUID generator
  final Uuid uuid;

  /// Use mock data instead of real API
  final bool useMockDataSource;

  /// Analytics service for tracking events
  final AnalyticsService analyticsService;

  const ChatFeatureConfig({
    required this.chatConfig,
    required this.dio,
    required this.secureStorage,
    required this.sharedPreferences,
    required this.databaseHelper,
    required this.appConstants,
    this.uuid = const Uuid(),
    this.useMockDataSource = false,
    required this.analyticsService,
  });
}

/// Initialize the Chat feature with explicit configuration.
Future<void> initChatFeature(GetIt sl, ChatFeatureConfig config) async {
  // Ensure AppConstants is registered if it's used internally by some classes via GetIt
  if (!sl.isRegistered<AppConstants>()) {
    sl.registerSingleton<AppConstants>(config.appConstants);
  }

  // Register Config
  sl.registerSingleton<ChatConfig>(config.chatConfig);

  //! Features - Chat
  // Cubit
  sl.registerFactory(
    () => ChatCubit(
      getMessages: sl(),
      getChatHistory: sl(),
      getMessageUsage: sl(),
      sendMessage: sl(),
      updateMessage: sl(),
      submitFeedback: sl(),
      secureStorage: config.secureStorage,
      uuid: config.uuid,
      getCurrentUser: sl(),
      getSubscriptionStatus: sl(),
      analyticsService: config.analyticsService,
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
      secureStorage: config.secureStorage,
      uuid: config.uuid,
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(config.databaseHelper),
  );

  // Conditionally register mock or real API chat datasource
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () {
      if (config.useMockDataSource) {
        AppLogger.debug('Registering MOCK ChatRemoteDataSource', name: 'DI');
        return ChatMockDataSource(config.sharedPreferences);
      } else {
        AppLogger.debug(
            'Registering REAL ChatRemoteDataSource (Finance Guru API)',
            name: 'DI');
        return ChatFinanceGuruDataSource(
            config.dio, config.sharedPreferences, config.secureStorage);
      }
    },
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
    () => ChatFeedbackDataSourceImpl(config.dio, config.secureStorage),
  );

  //! Features - Message Usage
  // Use cases
  sl.registerLazySingleton(() => GetMessageUsage(sl()));

  // Repository
  sl.registerLazySingleton<MessageUsageRepository>(
    () => MessageUsageRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MessageUsageDataSource>(
    () {
      if (config.useMockDataSource) {
        AppLogger.debug('Registering MOCK MessageUsageDataSource', name: 'DI');
        return MessageUsageMockDataSource();
      } else {
        AppLogger.debug(
            'Registering REAL MessageUsageDataSource (Finance Guru API)',
            name: 'DI');
        return MessageUsageDataSourceImpl(config.dio, config.secureStorage);
      }
    },
  );
}
