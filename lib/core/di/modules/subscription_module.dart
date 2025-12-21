import 'package:get_it/get_it.dart';

// Features - Subscription
import 'package:feature_subscription/data/datasources/subscription_datasource.dart';
import 'package:feature_subscription/data/repositories/subscription_repository_impl.dart';
import 'package:feature_subscription/domain/repositories/subscription_repository.dart';
import 'package:feature_subscription/domain/usecases/get_all_plans.dart';
import 'package:feature_subscription/domain/usecases/get_subscription_status.dart';
import 'package:feature_subscription/domain/usecases/create_subscription.dart';
import 'package:feature_subscription/presentation/cubit/subscription_cubit.dart';

void registerSubscriptionModule(GetIt sl) {
  //! Features - Subscription
  // Data sources
  sl.registerLazySingleton<SubscriptionDataSource>(
    () => SubscriptionDataSourceImpl(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllPlans(sl()));
  sl.registerLazySingleton(() => GetSubscriptionStatus(sl()));
  sl.registerLazySingleton(() => CreateSubscription(sl()));

  // Cubit
  sl.registerFactory(
    () => SubscriptionCubit(
      getAllPlansUseCase: sl(),
      getSubscriptionStatusUseCase: sl(),
      createSubscriptionUseCase: sl(),
    ),
  );
}
