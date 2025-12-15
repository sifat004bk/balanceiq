import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_plans.dart';
import '../../domain/usecases/get_subscription_status.dart';
import '../../domain/usecases/create_subscription.dart';
import 'subscription_state.dart';

/// Cubit for managing subscription state
class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetAllPlans getAllPlansUseCase;
  final GetSubscriptionStatus getSubscriptionStatusUseCase;
  final CreateSubscription createSubscriptionUseCase;

  SubscriptionCubit({
    required this.getAllPlansUseCase,
    required this.getSubscriptionStatusUseCase,
    required this.createSubscriptionUseCase,
  }) : super(SubscriptionInitial());

  /// Load all available plans
  Future<void> loadPlans() async {
    emit(PlansLoading());

    final result = await getAllPlansUseCase();

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (plans) => emit(PlansLoaded(plans: plans)),
    );
  }

  /// Load plans and subscription status together
  Future<void> loadPlansAndStatus() async {
    emit(PlansLoading());

    final plansResult = await getAllPlansUseCase();
    
    await plansResult.fold(
      (failure) async => emit(SubscriptionError(failure.message)),
      (plans) async {
        final statusResult = await getSubscriptionStatusUseCase();
        statusResult.fold(
          (failure) => emit(PlansLoaded(plans: plans)),
          (status) => emit(PlansLoaded(plans: plans, subscriptionStatus: status)),
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
    emit(CreatingSubscription());

    final result = await createSubscriptionUseCase(
      planName: planName,
      autoRenew: autoRenew,
    );

    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscription) => emit(SubscriptionCreated(subscription)),
    );
  }

  /// Reset state
  void reset() {
    emit(SubscriptionInitial());
  }
}
