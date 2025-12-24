import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/subscription.dart';
import '../repositories/subscription_repository.dart';

/// Use case for cancelling an existing subscription
class CancelSubscription {
  final SubscriptionRepository repository;

  CancelSubscription(this.repository);

  /// Cancel the current user's subscription
  ///
  /// Parameters:
  /// - [reason]: Optional reason for cancellation (for analytics)
  Future<Either<Failure, Subscription>> call({String? reason}) async {
    return await repository.cancelSubscription(reason: reason);
  }
}
