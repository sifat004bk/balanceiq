import 'package:feature_chat/presentation/chat_config.dart';
import 'package:get_it/get_it.dart';

import 'app_auth_config.dart';
import 'app_chat_config.dart';
import 'modules/storage_module.dart';
import 'modules/network_module.dart';
import 'modules/core_module.dart';
import 'modules/chat_module.dart';
import 'modules/auth_module.dart';
import 'modules/subscription_module.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External & Storage (Must be first)
  await registerStorageModule(sl);

  //! Network (Depends on Storage)
  registerNetworkModule(sl);

  //! Core (Theme, Currency, etc.)
  registerCoreModule(sl);

  //! Features - Auth with MOCK data source
  await initAuthFeatureWithMock(sl, TestAuthConfig());

  //! Features - Subscription
  registerSubscriptionModule(sl);

  //! Features - Chat
  sl.registerLazySingleton<ChatConfig>(() => TestChatConfig());
  registerChatModule(sl);
}
