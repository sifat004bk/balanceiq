import 'package:dolfin_core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class FinancialRatiosWidget extends StatelessWidget {
  final double expenseRatio;
  final double savingsRate;

  const FinancialRatiosWidget({
    super.key,
    required this.expenseRatio,
    required this.savingsRate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildRatioCard(
            context,
            title: AppStrings.dashboard.expenseRatio,
            value: expenseRatio,
            backgroundColor: colorScheme.error.withValues(alpha: 0.15),
            textColor: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildRatioCard(
            context,
            title: AppStrings.dashboard.savingsRate,
            value: savingsRate,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            textColor: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildRatioCard(
    BuildContext context, {
    required String title,
    required double value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
