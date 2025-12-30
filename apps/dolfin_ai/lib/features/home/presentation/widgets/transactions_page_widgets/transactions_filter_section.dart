import 'package:dolfin_core/constants/app_strings.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_state.dart';
import 'package:balance_iq/features/home/presentation/widgets/calendar_widgets/date_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:balance_iq/features/home/presentation/widgets/calendar_widgets/custom_calendar_date_range_picker.dart';

class TransactionsFilterSection extends StatefulWidget {
  const TransactionsFilterSection({super.key});

  @override
  State<TransactionsFilterSection> createState() =>
      _TransactionsFilterSectionState();
}

class _TransactionsFilterSectionState extends State<TransactionsFilterSection> {
  final TextEditingController _searchController = TextEditingController();

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
      builder: (bottomSheetContext) => DateSelectorBottomSheet(
        currentLabel:
            null, // Logic for this screen needs separate handling if needed, passing null for now
        onDateSelected: (start, end, label) {
          Navigator.pop(bottomSheetContext);
          context.read<TransactionFilterCubit>().updateDateRange(start, end);
        },
        onCustomRangePressed: () async {
          Navigator.pop(bottomSheetContext);

          final now = DateTime.now();
          await showDialog(
            context: context,
            builder: (context) => CustomCalendarDateRangePicker(
              minDate: DateTime(2020),
              maxDate: now.add(const Duration(days: 365)),
              onDateRangeSelected: (startDate, endDate) {
                context
                    .read<TransactionFilterCubit>()
                    .updateDateRange(startDate, endDate);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFilterCubit, TransactionFilterState>(
      builder: (context, state) {
        return Padding(
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
                onSubmitted: (value) =>
                    context.read<TransactionFilterCubit>().updateSearch(value),
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
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
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
                    ).animate().fadeIn(delay: 150.ms, duration: 300.ms).slideX(
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
                    ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideX(
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
                    ).animate().fadeIn(delay: 250.ms, duration: 300.ms).slideX(
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
                    ).animate().fadeIn(delay: 300.ms, duration: 300.ms).slideX(
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
        );
      },
    );
  }
}
