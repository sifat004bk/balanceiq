import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_state.dart';
import 'package:balance_iq/features/home/presentation/widgets/transaction_detail_modal.dart';
import 'package:balance_iq/features/home/presentation/widgets/transactions_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balance_iq/features/home/presentation/widgets/date_selector_bottom_sheet.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_state.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  final String? category;

  const TransactionsPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TransactionsCubit>()
            ..loadTransactions(limit: 50, category: category),
        ),
        BlocProvider(
          create: (context) =>
              sl<TransactionFilterCubit>()..updateCategory(category),
        ),
      ],
      child: TransactionsView(initialCategory: category),
    );
  }
}

class TransactionsView extends StatefulWidget {
  final String? initialCategory;

  const TransactionsView({super.key, this.initialCategory});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearCategoryFilter() {
    context.read<TransactionFilterCubit>().updateCategory(null);
  }

  void _selectDateRange() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateSelectorBottomSheet(
        onDateSelected: (start, end) {
          context.read<TransactionFilterCubit>().updateDateRange(start, end);
        },
      ),
    );
  }

  void _showTransactionDetail(Transaction transaction) {
    TransactionDetailModal.show(
      context,
      transaction: transaction,
      onUpdate: (updatedTransaction) {
        context.read<TransactionsCubit>().updateTransaction(updatedTransaction);
      },
      onDelete: (deletedTransaction) {
        context
            .read<TransactionsCubit>()
            .deleteTransaction(deletedTransaction.transactionId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionFilterCubit, TransactionFilterState>(
      listener: (context, state) {
        context.read<TransactionsCubit>().loadTransactions(
              search: state.searchQuery,
              category: state.selectedCategory,
              type: state.selectedType,
              startDate: state.startDate != null
                  ? DateFormat('yyyy-MM-dd').format(state.startDate!)
                  : null,
              endDate: state.endDate != null
                  ? DateFormat('yyyy-MM-dd').format(state.endDate!)
                  : null,
              limit: 50,
            );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.transactions.title),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
          ),
          body: Column(
            children: [
              // Filters
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Search Bar - Fade in and slide down
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: AppStrings.transactions.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onSubmitted: (value) => context
                          .read<TransactionFilterCubit>()
                          .updateSearch(value),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 12),
                    // Filter Chips - Staggered entrance
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Category Filter Chip (if category is selected)
                          if (state.selectedCategory != null) ...[
                            Chip(
                              label: Text(state.selectedCategory!),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: _clearCategoryFilter,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )
                                .animate()
                                .fadeIn(delay: 100.ms, duration: 300.ms)
                                .scaleXY(
                                    begin: 0.8,
                                    end: 1,
                                    delay: 100.ms,
                                    duration: 300.ms),
                            const SizedBox(width: 8),
                          ],
                          FilterChip(
                            label: Text(state.startDate != null &&
                                    state.endDate != null
                                ? '${DateFormat('MMM d').format(state.startDate!)} - ${DateFormat('MMM d').format(state.endDate!)}'
                                : 'Date Range'),
                            selected: state.startDate != null,
                            onSelected: (_) => _selectDateRange(),
                            backgroundColor: Theme.of(context).cardColor,
                          )
                              .animate()
                              .fadeIn(delay: 150.ms, duration: 300.ms)
                              .slideX(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 150.ms,
                                  duration: 300.ms,
                                  curve: Curves.easeOutCubic),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('All'),
                            selected: state.selectedType == null,
                            onSelected: (selected) {
                              if (selected) {
                                context
                                    .read<TransactionFilterCubit>()
                                    .updateType(null);
                              }
                            },
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 300.ms)
                              .slideX(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 200.ms,
                                  duration: 300.ms,
                                  curve: Curves.easeOutCubic),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Income'),
                            selected: state.selectedType == 'INCOME',
                            onSelected: (selected) {
                              context
                                  .read<TransactionFilterCubit>()
                                  .updateType(selected ? 'INCOME' : null);
                            },
                          )
                              .animate()
                              .fadeIn(delay: 250.ms, duration: 300.ms)
                              .slideX(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 250.ms,
                                  duration: 300.ms,
                                  curve: Curves.easeOutCubic),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Expense'),
                            selected: state.selectedType == 'EXPENSE',
                            onSelected: (selected) {
                              context
                                  .read<TransactionFilterCubit>()
                                  .updateType(selected ? 'EXPENSE' : null);
                            },
                          )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 300.ms)
                              .slideX(
                                  begin: 0.2,
                                  end: 0,
                                  delay: 300.ms,
                                  duration: 300.ms,
                                  curve: Curves.easeOutCubic),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Divider(height: 1, color: Theme.of(context).dividerColor),

              // List
              Expanded(
                child: BlocBuilder<TransactionsCubit, TransactionsState>(
                  builder: (context, transactionsState) {
                    if (transactionsState is TransactionsLoading) {
                      return const TransactionsShimmer();
                    }

                    if (transactionsState is TransactionsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                    size: 48, color: Colors.grey)
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .shake(delay: 200.ms, duration: 500.ms),
                            const SizedBox(height: 16),
                            Text('Error: ${transactionsState.message}')
                                .animate()
                                .fadeIn(delay: 100.ms, duration: 400.ms),
                            ElevatedButton(
                              onPressed: () {
                                final filterState = context
                                    .read<TransactionFilterCubit>()
                                    .state;
                                context
                                    .read<TransactionsCubit>()
                                    .loadTransactions(
                                      search: filterState.searchQuery,
                                      category: filterState.selectedCategory,
                                      type: filterState.selectedType,
                                      startDate: filterState.startDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(filterState.startDate!)
                                          : null,
                                      endDate: filterState.endDate != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(filterState.endDate!)
                                          : null,
                                      limit: 50,
                                    );
                              },
                              child: const Text('Retry'),
                            )
                                .animate()
                                .fadeIn(delay: 200.ms, duration: 400.ms)
                                .scaleXY(
                                    begin: 0.9,
                                    end: 1,
                                    delay: 200.ms,
                                    duration: 400.ms),
                          ],
                        ),
                      );
                    }

                    if (transactionsState is TransactionsLoaded) {
                      if (transactionsState.transactions.isEmpty) {
                        return Center(
                          child: const Text(
                                  'No transactions found matching your criteria.')
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.1, end: 0, duration: 400.ms),
                        );
                      }

                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            context
                                .read<TransactionsCubit>()
                                .loadMoreTransactions();
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            final filterState =
                                context.read<TransactionFilterCubit>().state;
                            context.read<TransactionsCubit>().loadTransactions(
                                  search: filterState.searchQuery,
                                  category: filterState.selectedCategory,
                                  type: filterState.selectedType,
                                  startDate: filterState.startDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(filterState.startDate!)
                                      : null,
                                  endDate: filterState.endDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(filterState.endDate!)
                                      : null,
                                  limit: 50,
                                );
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            itemCount: transactionsState.transactions.length +
                                (transactionsState.isMoreLoading ? 1 : 0),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              if (index ==
                                  transactionsState.transactions.length) {
                                return const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator()));
                              }
                              return _buildTransactionItem(context,
                                  transactionsState.transactions[index], index);
                            },
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, Transaction transaction, int index) {
    final isIncome = transaction.isIncome;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate staggered delay - cap at 10 items to avoid long waits
    final staggerDelay = Duration(milliseconds: 50 * (index < 10 ? index : 10));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showTransactionDetail(transaction),
        borderRadius: BorderRadius.circular(16),
        splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        highlightColor: Theme.of(context).primaryColor.withValues(alpha: 0.05),
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
                      ? AppPalette.income.withValues(alpha: 0.1)
                      : AppPalette.expense.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? AppPalette.income : AppPalette.expense,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                      ? AppPalette.income
                                      : AppPalette.expense,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
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
    )
        .animate(delay: staggerDelay)
        .fadeIn(duration: 400.ms, curve: Curves.easeOutQuad)
        .slideY(
            begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
  }
}
