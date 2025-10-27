import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// Core
import '../database/database_helper.dart';
import '../theme/theme_cubit.dart';

// Features - Auth
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_in_with_apple.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Features - Chat
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_messages.dart';
import '../../features/chat/domain/usecases/send_message.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core - Theme
  sl.registerFactory(() => ThemeCubit(sl()));

  //! Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      signOutUseCase: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithApple(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
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
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

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

  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl(), sl()),
  );

  //! Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  sl.registerLazySingleton(() => const Uuid());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(
    () => GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
    ),
  );
}
