import 'dart:ui';
import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/widgets/glass_presets.dart';
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
          // Net Balance Section with subtle glow
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppPalette.trustBlue : AppPalette.trustBlue)
                      .withOpacity(0.1),
                  blurRadius: 24,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  AppStrings.dashboard.walletBalance,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppPalette.textSubtle,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return (isDark
                            ? AppPalette.primaryGradient
                            : AppPalette.primaryGradient)
                        .createShader(bounds);
                  },
                  child: Text(
                    '\$${_formatCurrency(netBalance)}',
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: -1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Income and Expense Cards with glassmorphism
          Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseCard(
                  context,
                  icon: Icons.arrow_downward_rounded,
                  label: AppStrings.dashboard.totalIncome,
                  amount: totalIncome,
                  isIncome: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildIncomeExpenseCard(
                  context,
                  icon: Icons.arrow_upward_rounded,
                  label: AppStrings.dashboard.totalExpense,
                  amount: totalExpense,
                  isIncome: false,
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
    required bool isIncome,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isIncome
        ? (isDark ? AppPalette.incomeGreen : AppPalette.incomeGreen)
        : (isDark ? AppPalette.expenseRed : AppPalette.expenseRed);

    return ThemedGlass.container(
      context: context,
      preset: GlassPreset.card,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor,
                      iconColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${_formatCurrency(amount)}',
            style: textTheme.titleLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
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
