import 'package:flutter/material.dart';
import 'package:feature_auth/presentation/widgets/profile/profile_avatar.dart';
import 'package:feature_auth/presentation/widgets/profile/subscription_badge.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final dynamic
      subscriptionStatus; // Using dynamic to avoid hard dep if possible, but better to import

  const ProfileHeader({
    super.key,
    required this.user,
    this.subscriptionStatus,
  });

  @override
  Widget build(BuildContext context) {
    // Basic implementation
    return Column(
      children: [
        ProfileAvatar(user: user),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
        if (subscriptionStatus != null &&
            subscriptionStatus?.subscription != null) ...[
          const SizedBox(height: 8),
          SubscriptionBadge(
            planName: subscriptionStatus!.subscription!.plan.displayName,
          ),
        ],
      ],
    );
  }
}
