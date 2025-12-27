import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/icons/app_icons.dart';
import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:get_it/get_it.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final int index;
  final Function(Transaction) onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate staggered delay - cap at 6 items (was 10) to avoid long waits
    final staggerDelay = Duration(milliseconds: 20 * (index < 6 ? index : 6));

    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(transaction),
          borderRadius: BorderRadius.circular(16),
          splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          highlightColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surface.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isIncome
                        ? GetIt.instance<AppPalette>()
                            .income
                            .withValues(alpha: 0.1)
                        : GetIt.instance<AppPalette>()
                            .expense
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: isIncome
                      ? GetIt.I<AppIcons>().dashboard.income(
                            size: 24,
                            color: GetIt.instance<AppPalette>().income,
                          )
                      : GetIt.I<AppIcons>().dashboard.expense(
                            size: 24,
                            color: GetIt.instance<AppPalette>().expense,
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.category,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${DateFormat('MMM d').format(transaction.transactionDate)} • ${transaction.description}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          sl<CurrencyCubit>().formatAmountWithSign(
                              transaction.amount,
                              isIncome: isIncome),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isIncome
                                        ? GetIt.instance<AppPalette>().income
                                        : GetIt.instance<AppPalette>().expense,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GetIt.I<AppIcons>().navigation.chevronRight(
                          size: 20,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withValues(alpha: 0.3),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: staggerDelay)
        .fadeIn(duration: 300.ms, curve: Curves.easeOutQuad)
        .slideY(
            begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOutQuad);
  }
}
