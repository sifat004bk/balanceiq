import 'package:balance_iq/core/theme/app_theme.dart';
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
            title: 'Expense Ratio',
            value: expenseRatio,
            backgroundColor: colorScheme.error.withOpacity(0.15),
            textColor: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildRatioCard(
            context,
            title: 'Savings Rate',
            value: savingsRate,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            style: textTheme.bodyMedium?.copyWith(
              color:
                  isDark ? AppTheme.textSubtleDark : AppTheme.textSubtleLight,
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
