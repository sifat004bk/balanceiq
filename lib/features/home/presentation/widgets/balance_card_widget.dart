import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double netBalance;
  final double totalIncome;
  final double totalExpense;
  final String period;
  final String monthName;

  const BalanceCard({
    super.key,
    required this.netBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.period,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Header with profile and notification
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile Picture
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.3),
                      AppTheme.primaryColor.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: colorScheme.onSurface,
                  size: 24,
                ),
              ),

              // Hello Name
              Text(
                monthName,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.27,
                ),
              ),

              // Notification Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.surface.withOpacity(0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: colorScheme.surface.withOpacity(0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Icon(
                      Icons.notifications_outlined,
                      color: colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Net Balance Section
        Text(
          'Net Balance',
          style: textTheme.bodyMedium?.copyWith(
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
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 32),

        // Income and Expense Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseCard(
                  context,
                  icon: Icons.south,
                  label: 'Income',
                  amount: totalIncome,
                  iconColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIncomeExpenseCard(
                  context,
                  icon: Icons.north,
                  label: 'Expense',
                  amount: totalExpense,
                  iconColor: colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double amount,
    required Color iconColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(isDark ? 0.15 : 0.2),
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
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.titleMedium?.copyWith(
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
