import 'package:equatable/equatable.dart';
import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_status.dart';

/// Base class for subscription states
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SubscriptionInitial extends SubscriptionState {}

/// Loading state for plans
class PlansLoading extends SubscriptionState {}

/// Loading state for subscription status
class SubscriptionStatusLoading extends SubscriptionState {}

/// Loading state for creating subscription
class CreatingSubscription extends SubscriptionState {}

/// Loading state for cancelling subscription
class CancellingSubscription extends SubscriptionState {}

/// Plans loaded successfully
class PlansLoaded extends SubscriptionState {
  final List<Plan> plans;
  final SubscriptionStatus? subscriptionStatus;

  const PlansLoaded({
    required this.plans,
    this.subscriptionStatus,
  });

  @override
  List<Object?> get props => [plans, subscriptionStatus];

  PlansLoaded copyWith({
    List<Plan>? plans,
    SubscriptionStatus? subscriptionStatus,
  }) {
    return PlansLoaded(
      plans: plans ?? this.plans,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }
}

/// Subscription status loaded successfully
class SubscriptionStatusLoaded extends SubscriptionState {
  final SubscriptionStatus status;

  const SubscriptionStatusLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

/// Subscription created successfully
class SubscriptionCreated extends SubscriptionState {
  final Subscription subscription;

  const SubscriptionCreated(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

/// Subscription cancelled successfully
class SubscriptionCancelled extends SubscriptionState {
  final Subscription subscription;

  const SubscriptionCancelled(this.subscription);

  @override
  List<Object?> get props => [subscription];
}

/// Error state
class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
