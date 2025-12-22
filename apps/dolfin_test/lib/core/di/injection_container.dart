import 'package:get_it/get_it.dart';

import 'package:feature_auth/feature_auth.dart';
import 'package:feature_chat/feature_chat.dart';
import 'package:feature_subscription/feature_subscription.dart';

import 'package:dolfin_core/constants/core_strings.dart';
import 'package:feature_auth/constants/auth_strings.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:feature_subscription/constants/subscription_strings.dart';

import '../strings/core_strings_impl.dart';
import '../strings/auth_strings_impl.dart';
import '../strings/chat_strings_impl.dart';
import '../strings/subscription_strings_impl.dart';

import 'app_auth_config.dart';
import 'app_chat_config.dart';
import 'modules/storage_module.dart';
import 'modules/network_module.dart';
import 'modules/core_module.dart';

// Old modules are now obsolete
// import 'modules/auth_module.dart';
// import 'modules/chat_module.dart';
// import 'modules/subscription_module.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External & Storage (Must be first)
  await registerStorageModule(sl);

  //! Network (Depends on Storage)
  registerNetworkModule(sl);

  //! Core (Theme, Currency, etc.)
  registerCoreModule(sl);

  //! Strings (Must be registered before features)
  sl.registerLazySingleton<CoreStrings>(() => const CoreStringsImpl());
  sl.registerLazySingleton<AuthStrings>(() => const AuthStringsImpl());
  sl.registerLazySingleton<ChatStrings>(() => const ChatStringsImpl());
  sl.registerLazySingleton<SubscriptionStrings>(
      () => const SubscriptionStringsImpl());

  //! Features - Auth
  await initAuthFeature(
    sl,
    AuthFeatureConfig(
      authConfig: TestAuthConfig(),
      secureStorage: sl(),
      sharedPreferences: sl(),
      dio: sl(),
      googleSignIn: sl(),
      uuid: sl(),
      useMockDataSource: true, // Test app uses mock
    ),
  );

  //! Features - Subscription
  await initSubscriptionFeature(
      sl,
      SubscriptionFeatureConfig(
        dio: sl(),
        secureStorage: sl(),
      ));

  //! Features - Chat
  await initChatFeature(
    sl,
    ChatFeatureConfig(
      chatConfig: TestChatConfig(),
      dio: sl(),
      secureStorage: sl(),
      sharedPreferences: sl(),
      databaseHelper: sl(),
      appConstants: sl(),
      uuid: sl(),
      useMockDataSource: true, // Test app uses mock
    ),
  );
}
