import 'package:feature_subscription/data/datasources/subscription_datasource.dart';
import 'package:feature_subscription/domain/repositories/subscription_repository.dart';
import 'package:feature_subscription/domain/usecases/cancel_subscription.dart';
import 'package:feature_subscription/domain/usecases/create_subscription.dart';
import 'package:feature_subscription/domain/usecases/get_all_plans.dart';
import 'package:feature_subscription/domain/usecases/get_subscription_status.dart';
import 'package:feature_subscription/presentation/cubit/subscription_cubit.dart';
import 'package:dolfin_core/analytics/analytics_service.dart';
import 'package:mocktail/mocktail.dart';

// Data Sources
class MockSubscriptionDataSource extends Mock
    implements SubscriptionDataSource {}

// Repositories
class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

// Use Cases
class MockGetAllPlans extends Mock implements GetAllPlans {}

class MockGetSubscriptionStatus extends Mock implements GetSubscriptionStatus {}

class MockCreateSubscription extends Mock implements CreateSubscription {}

class MockCancelSubscription extends Mock implements CancelSubscription {}

// Cubits
class MockSubscriptionCubit extends Mock implements SubscriptionCubit {}

class MockAnalyticsService extends Mock implements AnalyticsService {}
