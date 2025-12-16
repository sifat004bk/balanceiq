import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/gemini_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/tour/tour.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.subscription.choosePlanTitle,
          style: AppTypography.titleXLargeSemiBold.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${AppStrings.subscription.subscriptionSuccess} ${state.subscription.plan.displayName}!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                    botName: 'BalanceIQ',
                  ),
                ),
              );
            } else {
              Navigator.pop(context, true);
            }
          } else if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
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
            return _buildPlansContent(context, isDark, state.plans,
                state.subscriptionStatus?.subscription?.plan?.name);
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

  Widget _buildPlansContent(BuildContext context, bool isDark, List<Plan> plans,
      String? currentPlanName) {
    // Sort plans by tier
    final sortedPlans = List<Plan>.from(plans)
      ..sort((a, b) => a.tier.compareTo(b.tier));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Monthly/Yearly Toggle
          _buildBillingToggle(isDark),
          const SizedBox(height: 8),
          // Savings Text
          Text(
            AppStrings.subscription.yearlySavings,
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: GeminiColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          // Plan Cards
          ...sortedPlans.map((plan) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildPlanCard(
                  context,
                  isDark: isDark,
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
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.surfaceToggleDark : const Color(0xFFE8ECF0),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              AppStrings.subscription.monthly,
              _isMonthly,
              () => setState(() => _isMonthly = true),
              isDark,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              AppStrings.subscription.yearly,
              !_isMonthly,
              () => setState(() => _isMonthly = false),
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String text,
    bool isActive,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? AppPalette.surfaceContainerDark : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.grey.shade600 : Colors.grey.shade500),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required bool isDark,
    required Plan plan,
    required bool isCurrentPlan,
    required bool isPopular,
  }) {
    // Calculate display price (20% off for yearly)
    final displayPrice = _isMonthly ? plan.price : plan.price * 0.8;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppPalette.surfaceToggleDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPopular
              ? GeminiColors.primary
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular
                ? GeminiColors.primary.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
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
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  plan.description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        AppStrings.subscription.perMonth,
                        style: AppTypography.bodyLarge.copyWith(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
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
                            color: GeminiColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature.name,
                              style: AppTypography.bodyLarge.copyWith(
                                color: isDark ? Colors.white : Colors.black87,
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
                          ? Colors.grey.shade400
                          : isPopular
                              ? GeminiColors.primary
                              : (isDark
                                  ? AppPalette.surfaceContainerDark
                                  : Colors.grey.shade200),
                      foregroundColor: isCurrentPlan
                          ? Colors.white
                          : isPopular
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isCurrentPlan ? AppStrings.subscription.currentPlan : AppStrings.subscription.subscribeButton,
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
                  color: GeminiColors.primary,
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
                  color: AppPalette.successGreen,
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
