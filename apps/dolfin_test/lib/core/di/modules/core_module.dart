import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:get_it/get_it.dart';

import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import '../app_constants_impl.dart';
import '../app_palette_impl.dart';
import 'package:dolfin_core/tour/tour_widget_factory.dart';
import 'package:dolfin_core/tour/product_tour_cubit.dart';
import 'package:dolfin_core/tour/product_tour_service.dart';
import '../test_tour_service.dart';
import '../test_tour_widget_factory.dart';

import "package:dolfin_core/currency/currency_cubit.dart";

void registerCoreModule(GetIt sl) {
  //! Core - Theme
  sl.registerFactory(() => ThemeCubit(sl()));

  //! Core - Currency
  sl.registerLazySingleton(() => CurrencyCubit());

  //! Core - Product Tour (simplified for test app)
  sl.registerLazySingleton<ProductTourService>(
    () => TestProductTourService(),
  );
  sl.registerFactory(
    () => ProductTourCubit(tourService: sl()),
  );
  sl.registerLazySingleton<TourWidgetFactory>(() => TestTourWidgetFactory());

  //! Core - Configuration
  sl.registerLazySingleton<AppConstants>(() => TestAppConstantsImpl());
  sl.registerLazySingleton<AppPalette>(() => TestAppPaletteImpl());

  //! Core - Authentication
  sl.registerLazySingleton<GoogleSignIn>(() {
    final serverClientId = sl<AppConstants>().serverClientId;
    return GoogleSignIn(
      serverClientId: serverClientId.isNotEmpty ? serverClientId : null,
      scopes: ['email', 'profile'],
    );
  });
}
