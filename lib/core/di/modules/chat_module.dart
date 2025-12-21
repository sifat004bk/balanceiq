import 'package:get_it/get_it.dart';
import "package:dolfin_core/constants/app_constants.dart";
import "package:dolfin_core/utils/app_logger.dart";

// Features - Chat
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

void registerChatModule(GetIt sl) {
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
      secureStorage: sl(),
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
      sharedPreferences:
          sl(), // KEEPING IT for now as I haven't migrated it yet.
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
      if (sl<AppConstants>().isMockMode) {
        AppLogger.debug('Registering MOCK ChatRemoteDataSource', name: 'DI');
        return ChatMockDataSource(sl());
      } else {
        AppLogger.debug(
            'Registering REAL ChatRemoteDataSource (Finance Guru API)',
            name: 'DI');
        return ChatFinanceGuruDataSource(sl(), sl(), sl());
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
    () => ChatFeedbackDataSourceImpl(sl(), sl()),
  );

  //! Features - Message Usage
  // Use cases
  sl.registerLazySingleton(() => GetMessageUsage(sl()));

  // Repository
  sl.registerLazySingleton<MessageUsageRepository>(
    () => MessageUsageRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  // Conditionally register mock or real message usage data source
  sl.registerLazySingleton<MessageUsageDataSource>(
    () {
      if (sl<AppConstants>().isMockMode) {
        AppLogger.debug('Registering MOCK MessageUsageDataSource', name: 'DI');
        return MessageUsageMockDataSource();
      } else {
        AppLogger.debug(
            'Registering REAL MessageUsageDataSource (Finance Guru API)',
            name: 'DI');
        return MessageUsageDataSourceImpl(sl(), sl());
      }
    },
  );
}
