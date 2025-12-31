import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../tour/tour.dart';
import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:balance_iq/core/config/app_constants_impl.dart';
import 'package:balance_iq/core/config/app_palette_impl.dart';
import 'package:dolfin_core/tour/tour_widget_factory.dart';
import '../../tour/tour_widget_factory_impl.dart';

import "package:dolfin_core/currency/currency_cubit.dart";
import '../../../features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import 'package:dolfin_core/analytics/analytics_service.dart';
import '../../services/firebase_analytics_service.dart';

void registerCoreModule(GetIt sl) {
  //! Core
  sl.registerLazySingleton(() => const Uuid());

  //! Core - Theme
  sl.registerFactory(() => ThemeCubit(sl()));

  //! Core - Currency
  sl.registerLazySingleton<CurrencyCubit>(
    () => CurrencyCubit(analyticsService: sl<AnalyticsService>()),
  );

  //! Core - Product Tour
  sl.registerLazySingleton<ProductTourService>(
    () => ProductTourServiceImpl(
        dashboardDataSource: sl<DashboardRemoteDataSource>()),
  );
  sl.registerFactory(
    () => ProductTourCubit(
      tourService: sl(),
      analyticsService: sl<AnalyticsService>(),
    ),
  );
  sl.registerLazySingleton<TourWidgetFactory>(() => TourWidgetFactoryImpl());

  //! Core - Configuration
  sl.registerLazySingleton<AppConstants>(() => AppConstantsImpl());
  sl.registerLazySingleton<AppPalette>(() => AppPaletteImpl());

  //! Core - Authentication
  sl.registerLazySingleton<GoogleSignIn>(() {
    final serverClientId = sl<AppConstants>().serverClientId;
    return GoogleSignIn(
      serverClientId: serverClientId.isNotEmpty ? serverClientId : null,
      scopes: ['email', 'profile'],
    );
  });

  //! Core - Analytics
  sl.registerLazySingleton<AnalyticsService>(() => FirebaseAnalyticsService());
}
