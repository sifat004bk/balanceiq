import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BiggestIncomeWidget extends StatelessWidget {
  final double amount;
  final String description;

  const BiggestIncomeWidget({
    super.key,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // If no biggest income, don't show anything (or show placeholder if desired, but typically we hide)
    if (amount <= 0) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_downward,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biggest Income',
                  style: textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppTheme.textSubtleDark
                        : AppTheme.textSubtleLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description.isEmpty ? 'Income' : description,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '+\$${amount.toStringAsFixed(0)}',
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
