import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double netBalance;
  final double totalIncome;
  final double totalExpense;
  final String period;

  const BalanceCard({
    super.key,
    required this.netBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Net Balance Section
          Text(
            'Net Balance',
            style: textTheme.bodySmall?.copyWith(
              color: isDark ? AppTheme.textSubtleDark : AppTheme.textSubtleLight,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${_formatCurrency(netBalance)}',
            style: textTheme.displayLarge?.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 1.2,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 24),

          // Income and Expense Cards
          Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseCard(
                  context,
                  icon: Icons.arrow_downward,
                  label: 'Income',
                  amount: totalIncome,
                  iconColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIncomeExpenseCard(
                  context,
                  icon: Icons.arrow_upward,
                  label: 'Expense',
                  amount: totalExpense,
                  iconColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double amount,
    required Color iconColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 10,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatCurrency(amount)}',
            style: textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)}K';
    }
    return amount.toStringAsFixed(2);
  }
}
