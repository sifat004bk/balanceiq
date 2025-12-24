import 'package:feature_auth/feature_auth.dart';
import 'package:feature_chat/feature_chat.dart';
import 'package:feature_subscription/feature_subscription.dart';

import 'package:balance_iq/core/config/app_auth_config.dart';
import 'package:balance_iq/core/config/app_chat_config.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';

import 'package:dolfin_core/constants/core_strings.dart';
import 'package:feature_auth/constants/auth_strings.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:feature_subscription/constants/subscription_strings.dart';

import '../strings/core_strings_impl.dart';
import '../strings/auth_strings_impl.dart';
import '../strings/chat_strings_impl.dart';
import '../strings/subscription_strings_impl.dart';
import '../strings/dashboard_strings_impl.dart';
import 'package:balance_iq/core/strings/dashboard_strings.dart';
import 'package:balance_iq/core/icons/app_icons.dart';
import 'package:balance_iq/core/icons/app_icons_impl.dart';

import 'modules/storage_module.dart';
import 'modules/network_module.dart';
import 'modules/core_module.dart';
import 'modules/dashboard_module.dart';
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

  //! Strings
  sl.registerLazySingleton<CoreStrings>(() => const CoreStringsImpl());
  sl.registerLazySingleton<AuthStrings>(() => const AuthStringsImpl());
  sl.registerLazySingleton<ChatStrings>(() => const ChatStringsImpl());
  sl.registerLazySingleton<SubscriptionStrings>(
      () => const SubscriptionStringsImpl());
  sl.registerLazySingleton<DashboardStrings>(
      () => const DashboardStringsImpl());

  //! Icons
  sl.registerLazySingleton<AppIcons>(() => const AppIconsImpl());

  // Common deps
  final appConstants = sl<AppConstants>();

  //! Features
  await initAuthFeature(
    sl,
    AuthFeatureConfig(
      authConfig: AppAuthConfig(),
      secureStorage: sl(),
      sharedPreferences: sl(),
      dio: sl(),
      googleSignIn: sl(),
      uuid: sl(),
      useMockDataSource: appConstants.isMockMode,
    ),
  );

  await initSubscriptionFeature(
      sl,
      SubscriptionFeatureConfig(
        dio: sl(),
        secureStorage: sl(),
      ));

  await initChatFeature(
    sl,
    ChatFeatureConfig(
      chatConfig: AppChatConfig(),
      dio: sl(),
      secureStorage: sl(),
      sharedPreferences: sl(),
      databaseHelper: sl(), // From storage module
      appConstants: appConstants,
      uuid: sl(),
      useMockDataSource: appConstants.isMockMode,
    ),
  );

  registerDashboardModule(sl);
}
