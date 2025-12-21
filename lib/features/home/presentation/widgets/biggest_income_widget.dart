import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
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
            child: Icon(
              Icons.arrow_downward,
              color: AppPalette.income,
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
                  AppStrings.dashboard.biggestIncome,
                  style: textTheme.bodyMedium,
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
            sl<CurrencyCubit>().formatAmountWithSign(amount, isIncome: true),
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.income.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
