import 'package:get_it/get_it.dart';

import 'modules/storage_module.dart';
import 'modules/network_module.dart';
import 'modules/core_module.dart';
import 'modules/auth_module.dart';
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
  registerAuthModule(sl);
  registerChatModule(sl);
  registerDashboardModule(sl);
  registerSubscriptionModule(sl);
}
