import 'package:flutter/material.dart';

import 'package:dolfin_core/constants/app_strings.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';

class LimitWarningBanner extends StatelessWidget {
  final bool isLimitReached;
  final bool isNearLimit;
  final int remainingMessages;

  const LimitWarningBanner({
    super.key,
    required this.isLimitReached,
    required this.isNearLimit,
    required this.remainingMessages,
  });

  @override
  Widget build(BuildContext context) {
    if (isLimitReached) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.error),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onError,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.chat.messageLimitReached,
              style: AppTypography.captionError.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ],
        ),
      );
    }

    if (isNearLimit) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.chat.nearMessageLimit(remainingMessages),
              style: AppTypography.captionWarning.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
