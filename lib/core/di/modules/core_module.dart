import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../tour/tour.dart';
import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import "package:dolfin_core/currency/currency_cubit.dart";
import '../../../features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';

void registerCoreModule(GetIt sl) {
  //! Core
  sl.registerLazySingleton(() => const Uuid());

  //! Core - Theme
  sl.registerFactory(() => ThemeCubit(sl()));

  //! Core - Currency
  sl.registerLazySingleton(() => CurrencyCubit());

  //! Core - Product Tour
  sl.registerLazySingleton<ProductTourService>(
    () => ProductTourServiceImpl(
        dashboardDataSource: sl<DashboardRemoteDataSource>()),
  );
  sl.registerFactory(
    () => ProductTourCubit(tourService: sl()),
  );
}
