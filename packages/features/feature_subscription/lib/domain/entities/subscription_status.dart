import 'package:equatable/equatable.dart';
import 'subscription.dart';

/// Subscription status entity for checking if user has an active subscription
class SubscriptionStatus extends Equatable {
  final bool hasActiveSubscription;
  final Subscription? subscription;

  const SubscriptionStatus({
    required this.hasActiveSubscription,
    this.subscription,
  });

  @override
  List<Object?> get props => [hasActiveSubscription, subscription];
}
