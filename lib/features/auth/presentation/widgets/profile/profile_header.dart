import 'package:flutter/material.dart';

import '../../../../subscription/domain/entities/subscription_status.dart';
import 'profile_avatar.dart';
import 'subscription_badge.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final SubscriptionStatus? subscriptionStatus;

  const ProfileHeader({
    super.key,
    required this.user,
    this.subscriptionStatus,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubscription = subscriptionStatus?.hasActiveSubscription ?? false;
    final planName = subscriptionStatus?.subscription?.plan.displayName ?? '';
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Avatar with glow effect
        ProfileAvatar(user: user),
        const SizedBox(height: 24),
        // User Name with Subscription Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            if (hasSubscription) SubscriptionBadge(planName: planName),
          ],
        ),
        const SizedBox(height: 8),
        // Email
        Text(
          user.email,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}
