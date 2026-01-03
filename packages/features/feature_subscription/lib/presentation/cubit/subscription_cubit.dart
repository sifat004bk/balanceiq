import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_plans.dart';
import '../../domain/usecases/get_subscription_status.dart';
import '../../domain/usecases/create_subscription.dart';
import '../../domain/usecases/cancel_subscription.dart';
import 'package:dolfin_core/analytics/analytics_service.dart';
import 'subscription_state.dart';

/// Cubit for managing subscription state
class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetAllPlans getAllPlansUseCase;
  final GetSubscriptionStatus getSubscriptionStatusUseCase;
  final CreateSubscription createSubscriptionUseCase;
  final CancelSubscription cancelSubscriptionUseCase;
  final AnalyticsService analyticsService;

  SubscriptionCubit({
    required this.getAllPlansUseCase,
    required this.getSubscriptionStatusUseCase,
    required this.createSubscriptionUseCase,
    required this.cancelSubscriptionUseCase,
    required this.analyticsService,
  }) : super(SubscriptionInitial());

  /// Load all available plans
  Future<void> loadPlans() async {
    emit(PlansLoading());

    final result = await getAllPlansUseCase();

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (plans) {
        // Log view_promotion when plans are shown
        analyticsService.logEvent(
          name: 'view_promotion',
          parameters: {'items_count': plans.length},
        );
        emit(PlansLoaded(plans: plans));
      },
    );
  }

  /// Load plans and subscription status together
  Future<void> loadPlansAndStatus() async {
    emit(PlansLoading());

    final plansResult = await getAllPlansUseCase();

    await plansResult.fold(
      (failure) async => emit(SubscriptionError(failure.message)),
      (plans) async {
        // Log view_promotion when plans are shown
        analyticsService.logEvent(
          name: 'view_promotion',
          parameters: {'items_count': plans.length},
        );

        final statusResult = await getSubscriptionStatusUseCase();
        statusResult.fold(
          (failure) => emit(PlansLoaded(plans: plans)),
          (status) =>
              emit(PlansLoaded(plans: plans, subscriptionStatus: status)),
        );
      },
    );
  }

  /// Load subscription status for authenticated user
  Future<void> loadSubscriptionStatus() async {
    emit(SubscriptionStatusLoading());

    final result = await getSubscriptionStatusUseCase();

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (status) => emit(SubscriptionStatusLoaded(status)),
    );
  }

  /// Create a new subscription
  Future<void> createSubscription({
    required String planName,
    bool autoRenew = true,
  }) async {
    // Log begin_checkout
    await analyticsService.logEvent(
      name: 'begin_checkout',
      parameters: {
        'plan_name': planName,
        'auto_renew': autoRenew.toString(),
      },
    );

    emit(CreatingSubscription());

    final result = await createSubscriptionUseCase(
      planName: planName,
      autoRenew: autoRenew,
    );

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscription) {
        // Log purchase success
        analyticsService.logEvent(
          name: 'purchase',
          parameters: {
            'plan_name': planName,
            'currency': 'USD', // Default assumption, refine if available
          },
        );
        emit(SubscriptionCreated(subscription));
      },
    );
  }

  /// Cancel subscription
  Future<void> cancelSubscription({String? reason}) async {
    emit(CancellingSubscription());

    final result = await cancelSubscriptionUseCase(reason: reason);

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscription) {
        // Log subscription cancel
        analyticsService.logEvent(
          name: 'subscription_cancel',
          parameters: {
            'reason': reason ?? 'unknown',
            'plan_name': subscription.plan?.name ?? 'unknown',
          },
        );
        emit(SubscriptionCancelled(subscription));
      },
    );
  }

  /// Reset state
  void reset() {
    emit(SubscriptionInitial());
  }
}
