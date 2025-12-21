import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

/// Use case for creating a new subscription
class CreateSubscription {
  final SubscriptionRepository repository;

  CreateSubscription(this.repository);

  /// Create a new subscription for the authenticated user
  ///
  /// Parameters:
  /// - [planName]: Name of the plan to subscribe to (e.g., "PREMIUM")
  /// - [autoRenew]: Whether to enable auto-renewal (default: true)
  Future<Either<Failure, Subscription>> call({
    required String planName,
    bool autoRenew = true,
  }) async {
    return await repository.createSubscription(
      planName: planName,
      autoRenew: autoRenew,
    );
  }
}
