import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:dolfin_core/storage/secure_storage_service.dart';

import 'package:feature_subscription/data/datasources/subscription_datasource.dart';
import 'package:feature_subscription/data/repositories/subscription_repository_impl.dart';
import 'package:feature_subscription/domain/repositories/subscription_repository.dart';
import 'package:feature_subscription/domain/usecases/get_all_plans.dart';
import 'package:feature_subscription/domain/usecases/get_subscription_status.dart';
import 'package:feature_subscription/domain/usecases/create_subscription.dart';
import 'package:feature_subscription/presentation/cubit/subscription_cubit.dart';

// Re-export common types
export 'package:feature_subscription/presentation/pages/manage_subscription_page.dart';
export 'package:feature_subscription/presentation/pages/subscription_plans_page.dart';
export 'package:feature_subscription/presentation/cubit/subscription_cubit.dart';

/// Configuration for initializing the Subscription feature.
///
/// All parameters are required.
class SubscriptionFeatureConfig {
  /// HTTP Client
  final Dio dio;

  /// Secure storage for auth tokens
  final SecureStorageService secureStorage;

  const SubscriptionFeatureConfig({
    required this.dio,
    required this.secureStorage,
  });
}

/// Initialize the Subscription feature with explicit configuration.
Future<void> initSubscriptionFeature(
    GetIt sl, SubscriptionFeatureConfig config) async {
  //! Features - Subscription
  // Data sources
  // Only real data source available currently
  sl.registerLazySingleton<SubscriptionDataSource>(
    () => SubscriptionDataSourceImpl(config.dio, config.secureStorage),
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
