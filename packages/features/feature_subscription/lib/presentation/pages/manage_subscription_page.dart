import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_subscription/constants/subscription_strings.dart';
import 'package:dolfin_core/constants/core_strings.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:get_it/get_it.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';
import 'package:feature_subscription/domain/entities/subscription.dart';
import 'package:feature_subscription/presentation/cubit/subscription_cubit.dart';
import 'package:feature_subscription/presentation/cubit/subscription_state.dart';
import '../widgets/cancellation_reason_dialog.dart';
import 'package:feature_auth/presentation/widgets/profile/profile_shimmer.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionCubit>(
      create: (_) =>
          GetIt.instance<SubscriptionCubit>()..loadSubscriptionStatus(),
      child: const _ManageSubscriptionView(),
    );
  }
}

class _ManageSubscriptionView extends StatelessWidget {
  const _ManageSubscriptionView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionCancelled) {
          SnackbarUtils.showSuccess(
            context,
            GetIt.I<SubscriptionStrings>().cancellationSuccess,
          );
          // Navigate back to profile page
          Navigator.popUntil(context,
              (route) => route.settings.name == '/profile' || route.isFirst);
        } else if (state is SubscriptionError) {
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, state) {
          final showAppBar = state is! CancellingSubscription;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: showAppBar
                ? AppBar(
                    leading: IconButton(
                      icon: Icon(
                        LucideIcons.arrowLeft,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      GetIt.I<SubscriptionStrings>().manageSubscriptionTitle,
                      style: AppTypography.titleXLargeSemiBold.copyWith(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  )
                : null,
            body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
              builder: (context, state) {
                if (state is SubscriptionStatusLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CancellingSubscription) {
                  return const ProfileShimmer();
                }

                if (state is SubscriptionStatusLoaded) {
                  if (!state.status.hasActiveSubscription) {
                    return _buildNoSubscriptionView(context);
                  }
                  return _buildSubscriptionContent(
                      context, state.status.subscription!);
                }

                if (state is SubscriptionError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.circleX,
                            size: 64, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context
                              .read<SubscriptionCubit>()
                              .loadSubscriptionStatus(),
                          child: Text(GetIt.I<CoreStrings>().common.retry),
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoSubscriptionView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.creditCard,
              size: 80,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 24),
            Text(
              GetIt.I<SubscriptionStrings>().noActiveSubscription,
              style: AppTypography.headlineMediumBold.copyWith(
                color: Theme.of(context).textTheme.headlineMedium?.color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              GetIt.I<SubscriptionStrings>().subscribeMessage,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/subscription-plans');
                if (result == true) {
                  if (context.mounted) {
                    context.read<SubscriptionCubit>().loadSubscriptionStatus();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                GetIt.I<SubscriptionStrings>().viewPlans,
                style: AppTypography.buttonMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionContent(
      BuildContext context, Subscription subscription) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Plan Card
          _buildCurrentPlanCard(context, subscription),
          const SizedBox(height: 32),

          // Billing Info
          _buildSectionTitle(
              context, GetIt.I<SubscriptionStrings>().subscriptionDetails),
          const SizedBox(height: 16),
          _buildSubscriptionDetailsCard(context, subscription),
          const SizedBox(height: 32),

          // Cancel Subscription Section
          const SizedBox(height: 16),
          _buildCancelSubscriptionButton(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) async {
    final reason = await CancellationReasonDialog.show(context);

    if (reason != null && context.mounted) {
      context.read<SubscriptionCubit>().cancelSubscription(reason: reason);
    }
  }

  Widget _buildCancelSubscriptionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showCancelConfirmationDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          GetIt.I<SubscriptionStrings>().cancelSubscription,
          style: AppTypography.buttonMedium.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPlanCard(
      BuildContext context, Subscription subscription) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: subscription.isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      subscription.isActive
                          ? LucideIcons.star
                          : LucideIcons.circlePause,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subscription.isActive
                          ? GetIt.I<SubscriptionStrings>().activePlan
                          : GetIt.I<SubscriptionStrings>().inactive,
                      style: AppTypography.captionSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            subscription.plan?.displayName ?? '',
            style: AppTypography.displayMedium.copyWith(
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                subscription.plan?.formattedPrice ?? '',
                style: AppTypography.displayLarge.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '/ ${subscription.plan?.billingCycle.toLowerCase() ?? ""}',
                  style: AppTypography.bodyLarge.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            GetIt.I<SubscriptionStrings>()
                .nextBillingDate(subscription.formattedEndDate),
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          if (subscription.isExpiringSoon)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.triangleAlert,
                      size: 16, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 4),
                  Text(
                    GetIt.I<SubscriptionStrings>()
                        .expiresIn(subscription.daysRemaining),
                    style: AppTypography.captionSemiBold.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/subscription-plans');
                if (result == true) {
                  if (context.mounted) {
                    context.read<SubscriptionCubit>().loadSubscriptionStatus();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                GetIt.I<SubscriptionStrings>().changePlan,
                style: AppTypography.buttonMedium.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: AppTypography.titleLargeBold.copyWith(
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildSubscriptionDetailsCard(
      BuildContext context, Subscription subscription) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildDetailRow(GetIt.I<SubscriptionStrings>().startDate,
              _formatDate(subscription.startDate), context),
          Divider(color: Theme.of(context).dividerColor),
          _buildDetailRow(GetIt.I<SubscriptionStrings>().endDate,
              _formatDate(subscription.endDate), context),
          Divider(color: Theme.of(context).dividerColor),
          _buildDetailRow(GetIt.I<SubscriptionStrings>().daysRemaining,
              '${subscription.daysRemaining} days', context),
          Divider(color: Theme.of(context).dividerColor),
          _buildDetailRow(
              GetIt.I<SubscriptionStrings>().status,
              subscription.isActive
                  ? GetIt.I<SubscriptionStrings>().active
                  : GetIt.I<SubscriptionStrings>().inactive,
              context,
              valueColor: subscription.isActive
                  ? Colors.green
                  : Theme.of(context).colorScheme.error),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color:
                  valueColor ?? Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
