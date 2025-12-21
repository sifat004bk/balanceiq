import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/tour/tour.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../domain/entities/plan.dart';
import '../cubit/subscription_cubit.dart';
import '../cubit/subscription_state.dart';

class SubscriptionPlansPage extends StatelessWidget {
  const SubscriptionPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SubscriptionCubit>()..loadPlansAndStatus(),
      child: const _SubscriptionPlansView(),
    );
  }
}

class _SubscriptionPlansView extends StatefulWidget {
  const _SubscriptionPlansView();

  @override
  State<_SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<_SubscriptionPlansView> {
  bool _isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.subscription.choosePlanTitle,
          style: AppTypography.titleXLargeSemiBold.copyWith(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionCreated) {
            SnackbarUtils.showSuccess(
              context,
              '${AppStrings.subscription.subscriptionSuccess} ${state.subscription.plan.displayName}!',
            );

            // Check if tour is active at subscription step
            final tourCubit = context.read<ProductTourCubit>();
            if (tourCubit.isAtStep(TourStep.profileSubscription)) {
              // Advance tour and navigate to chat
              tourCubit.onSubscriptionCreated();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(
                    botId: "nai kichu",
                    botName: 'Donfin AI',
                  ),
                ),
              );
            } else {
              Navigator.pop(context, true);
            }
          } else if (state is SubscriptionError) {
            SnackbarUtils.showError(context, state.message);
            // Reload plans after error
            context.read<SubscriptionCubit>().loadPlansAndStatus();
          }
        },
        builder: (context, state) {
          if (state is PlansLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CreatingSubscription) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(AppStrings.common.processing),
                ],
              ),
            );
          }

          if (state is PlansLoaded) {
            return _buildPlansContent(context, state.plans,
                state.subscriptionStatus?.subscription?.plan.name);
          }

          if (state is SubscriptionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<SubscriptionCubit>().loadPlansAndStatus(),
                    child: Text(AppStrings.common.retry),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPlansContent(
      BuildContext context, List<Plan> plans, String? currentPlanName) {
    // Sort plans by tier
    final sortedPlans = List<Plan>.from(plans)
      ..sort((a, b) => a.tier.compareTo(b.tier));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Monthly/Yearly Toggle
          _buildBillingToggle(context),
          const SizedBox(height: 8),
          // Savings Text
          Text(
            AppStrings.subscription.yearlySavings,
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          // Plan Cards
          ...sortedPlans.map((plan) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildPlanCard(
                  context,
                  plan: plan,
                  isCurrentPlan: plan.name == currentPlanName,
                  isPopular: plan.tier == 2, // Pro plan is typically tier 2
                ),
              )),
          const SizedBox(height: 12),
          // Footer Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: Show terms of service
                },
                child: Text(
                  AppStrings.subscription.termsOfService,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  // TODO: Show privacy policy
                },
                child: Text(
                  AppStrings.subscription.privacyPolicy,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              context,
              AppStrings.subscription.monthly,
              _isMonthly,
              () => setState(() => _isMonthly = true),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              context,
              AppStrings.subscription.yearly,
              !_isMonthly,
              () => setState(() => _isMonthly = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context,
    String text,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.surfaceContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.buttonMedium.copyWith(
            color: isActive
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required Plan plan,
    required bool isCurrentPlan,
    required bool isPopular,
  }) {
    // Calculate display price (20% off for yearly)
    final displayPrice = _isMonthly ? plan.price : plan.price * 0.8;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPopular
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: isPopular ? 48 : 24,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  plan.displayName,
                  style: AppTypography.headlineMediumBold.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  plan.description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(height: 16),
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${displayPrice.toStringAsFixed(0)}',
                      style: AppTypography.displayLarge.copyWith(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        AppStrings.subscription.perMonth,
                        style: AppTypography.bodyLarge.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Features
                ...plan.features.take(4).map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature.name,
                              style: AppTypography.bodyLarge.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isCurrentPlan
                        ? null
                        : () {
                            context
                                .read<SubscriptionCubit>()
                                .createSubscription(
                                  planName: plan.name,
                                  autoRenew: true,
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentPlan
                          ? Theme.of(context).disabledColor
                          : isPopular
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceContainer,
                      foregroundColor: isCurrentPlan
                          ? Theme.of(context).colorScheme.onSurface
                          : isPopular
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isCurrentPlan
                          ? AppStrings.subscription.currentPlan
                          : AppStrings.subscription.subscribeButton,
                      style: AppTypography.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Popular Badge
          if (isPopular)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Text(
                  AppStrings.subscription.mostPopular,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMediumSemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Current Plan Badge
          if (isCurrentPlan)
            Positioned(
              top: isPopular ? 40 : 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.subscription.active,
                  style: AppTypography.captionSemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
