import 'package:dolfin_core/constants/app_strings.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:dolfin_ui_kit/widgets/glass_presets.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final currencyCubit = sl<CurrencyCubit>();

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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  blurRadius: 24,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  AppStrings.dashboard.netBalance,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ]).createShader(bounds);
                  },
                  child: Text(
                    currencyCubit.formatCompact(netBalance),
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: -1.0,
                      color: Theme.of(context).colorScheme.onSurface,
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
                  currencyCubit: currencyCubit,
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
                  currencyCubit: currencyCubit,
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
    required CurrencyCubit currencyCubit,
    required IconData icon,
    required String label,
    required double amount,
    required bool isIncome,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final iconColor = isIncome
        ? GetIt.instance<AppPalette>().income
        : GetIt.instance<AppPalette>().expense;

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
                      iconColor.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimary,
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
            currencyCubit.formatCompact(amount),
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
}
