import 'package:feature_auth/feature_auth.dart';
import 'package:balance_iq/core/config/app_auth_config.dart';
import 'package:balance_iq/core/config/app_chat_config.dart';
import 'package:feature_chat/presentation/chat_config.dart';
import 'package:get_it/get_it.dart';

import 'modules/storage_module.dart';
import 'modules/network_module.dart';
import 'modules/core_module.dart';
import 'modules/chat_module.dart';
import 'modules/dashboard_module.dart';
import 'modules/subscription_module.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External & Storage (Must be first)
  await registerStorageModule(sl);

  //! Network (Depends on Storage)
  registerNetworkModule(sl);

  //! Core (Theme, Currency, etc.)
  registerCoreModule(sl);

  //! Features
  await initAuthFeature(sl, AppAuthConfig());

  sl.registerLazySingleton<ChatConfig>(() => AppChatConfig());
  registerChatModule(sl);
  registerDashboardModule(sl);
  registerSubscriptionModule(sl);
}
