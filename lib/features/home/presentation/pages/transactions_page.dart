import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_state.dart';
import 'package:balance_iq/features/home/presentation/widgets/transactions_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  final String? category;

  const TransactionsPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TransactionsCubit>()
        ..loadTransactions(limit: 50, category: category),
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
  String? _selectedType;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  void _onFilterChanged() {
    String? startDateStr;
    String? endDateStr;

    if (_startDate != null) {
      startDateStr = DateFormat('yyyy-MM-dd').format(_startDate!);
    }
    if (_endDate != null) {
      endDateStr = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<TransactionsCubit>().loadTransactions(
          search: _searchController.text,
          category: _selectedCategory,
          type: _selectedType,
          startDate: startDateStr,
          endDate: endDateStr,
          limit: 50,
        );
  }

  void _clearCategoryFilter() {
    setState(() {
      _selectedCategory = null;
    });
    _onFilterChanged();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _onFilterChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
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
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onSubmitted: (_) => _onFilterChanged(),
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
                      if (_selectedCategory != null) ...[
                        Chip(
                          label: Text(_selectedCategory!),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: _clearCategoryFilter,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          side: BorderSide(color: AppTheme.primaryColor),
                          labelStyle: TextStyle(color: AppTheme.primaryColor),
                        )
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 300.ms)
                            .scaleXY(begin: 0.8, end: 1, delay: 100.ms, duration: 300.ms),
                        const SizedBox(width: 8),
                      ],
                      FilterChip(
                        label: Text(_startDate != null && _endDate != null
                            ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                            : 'Date Range'),
                        selected: _startDate != null,
                        onSelected: (_) => _selectDateRange(),
                        backgroundColor: Theme.of(context).cardColor,
                      )
                          .animate()
                          .fadeIn(delay: 150.ms, duration: 300.ms)
                          .slideX(begin: 0.2, end: 0, delay: 150.ms, duration: 300.ms, curve: Curves.easeOutCubic),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedType == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedType = null);
                            _onFilterChanged();
                          }
                        },
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 300.ms)
                          .slideX(begin: 0.2, end: 0, delay: 200.ms, duration: 300.ms, curve: Curves.easeOutCubic),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Income'),
                        selected: _selectedType == 'INCOME',
                        onSelected: (selected) {
                          setState(() => _selectedType = selected ? 'INCOME' : null);
                          _onFilterChanged();
                        },
                      )
                          .animate()
                          .fadeIn(delay: 250.ms, duration: 300.ms)
                          .slideX(begin: 0.2, end: 0, delay: 250.ms, duration: 300.ms, curve: Curves.easeOutCubic),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Expense'),
                        selected: _selectedType == 'EXPENSE',
                        onSelected: (selected) {
                          setState(() => _selectedType = selected ? 'EXPENSE' : null);
                          _onFilterChanged();
                        },
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 300.ms)
                          .slideX(begin: 0.2, end: 0, delay: 300.ms, duration: 300.ms, curve: Curves.easeOutCubic),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                if (state is TransactionsLoading) {
                  return const TransactionsShimmer();
                }

                if (state is TransactionsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.grey)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .shake(delay: 200.ms, duration: 500.ms),
                        const SizedBox(height: 16),
                        Text('Error: ${state.message}')
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 400.ms),
                        ElevatedButton(
                          onPressed: _onFilterChanged,
                          child: const Text('Retry'),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 400.ms)
                            .scaleXY(begin: 0.9, end: 1, delay: 200.ms, duration: 400.ms),
                      ],
                    ),
                  );
                }

                if (state is TransactionsLoaded) {
                  if (state.transactions.isEmpty) {
                    return Center(
                      child: const Text('No transactions found matching your criteria.')
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0, duration: 400.ms),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildTransactionItem(context, state.transactions[index], index);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction, int index) {
    final isIncome = transaction.isIncome;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate staggered delay - cap at 10 items to avoid long waits
    final staggerDelay = Duration(milliseconds: 50 * (index < 10 ? index : 10));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
              color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description.isNotEmpty
                      ? transaction.description
                      : transaction.category,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MMM d').format(transaction.transactionDate)} • ${transaction.category}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'} ${transaction.formattedAmount}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                    ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          delay: staggerDelay,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        )
        .slideX(
          begin: 0.1,
          end: 0,
          delay: staggerDelay,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
