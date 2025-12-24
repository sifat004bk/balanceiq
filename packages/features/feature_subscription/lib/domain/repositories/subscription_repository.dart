import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/plan.dart';
import '../entities/subscription.dart';
import '../entities/subscription_status.dart';

/// Repository for subscription operations
abstract class SubscriptionRepository {
  /// Get all available subscription plans
  ///
  /// Endpoint: GET /api/plans
  Future<Either<Failure, List<Plan>>> getAllPlans();

  /// Get current subscription status for authenticated user
  ///
  /// Endpoint: GET /api/subscriptions/status
  Future<Either<Failure, SubscriptionStatus>> getSubscriptionStatus();

  /// Create a new subscription for authenticated user
  ///
  /// Endpoint: POST /api/subscriptions/
  ///
  /// Parameters:
  /// - [planName]: Name of the plan to subscribe to (e.g., "PREMIUM")
  /// - [autoRenew]: Whether to enable auto-renewal
  Future<Either<Failure, Subscription>> createSubscription({
    required String planName,
    required bool autoRenew,
  });

  /// Cancel the current user's subscription
  ///
  /// Endpoint: POST /api/subscriptions/cancel
  ///
  /// Parameters:
  /// - [reason]: Optional reason for cancellation (for analytics)
  Future<Either<Failure, Subscription>> cancelSubscription({String? reason});
}
