import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Displays the transaction amount with colored styling
class AmountSection extends StatelessWidget {
  final double amount;
  final bool isIncome;

  const AmountSection({
    super.key,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isIncome
              ? [
                  Colors.green.withValues(alpha: 0.1),
                  Colors.green.withValues(alpha: 0.05)
                ]
              : [
                  Colors.red.withValues(alpha: 0.1),
                  Colors.red.withValues(alpha: 0.05)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isIncome
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            isIncome
                ? AppStrings.dashboard.income
                : AppStrings.dashboard.expense,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            sl<CurrencyCubit>()
                .formatAmountWithSign(amount, isIncome: isIncome),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .scaleXY(begin: 0.95, end: 1, delay: 200.ms, duration: 400.ms);
  }
}
