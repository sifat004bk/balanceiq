import 'package:dolfin_core/constants/app_strings.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_state.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_cubit.dart';
import 'package:balance_iq/features/home/presentation/widgets/transaction_detail_widgets/transaction_detail_modal.dart';
import 'package:balance_iq/features/home/presentation/widgets/transactions_page_widgets/transactions_filter_section.dart';
import 'package:balance_iq/features/home/presentation/widgets/transactions_page_widgets/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatelessWidget {
  final String? category;

  const TransactionsPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionsCubit>(
          create: (context) => sl<TransactionsCubit>()
            ..loadTransactions(limit: 50, category: category),
        ),
        BlocProvider<TransactionFilterCubit>(
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
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
  }

  void _showTransactionDetail(Transaction transaction) {
    TransactionDetailModal.show(
      context,
      transaction: transaction,
      onUpdate: (updatedTransaction) async {
        await context
            .read<TransactionsCubit>()
            .updateTransaction(updatedTransaction);
        if (context.mounted) {
          setState(() {
            _hasChanges = true;
          });
          context.read<DashboardCubit>().refreshDashboard();
        }
      },
      onDelete: (deletedTransaction) async {
        await context
            .read<TransactionsCubit>()
            .deleteTransaction(deletedTransaction.transactionId);
        if (context.mounted) {
          setState(() {
            _hasChanges = true;
          });
          context.read<DashboardCubit>().refreshDashboard();
        }
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
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.pop(context, _hasChanges);
          },
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Text(AppStrings.transactions.title),
                    centerTitle: true,
                    floating: true,
                    snap: true,
                    elevation: 0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor:
                        Theme.of(context).textTheme.titleLarge?.color,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(120),
                      child: Column(
                        children: [
                          const TransactionsFilterSection(),
                          Divider(
                              height: 1, color: Theme.of(context).dividerColor),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TransactionsList(
                onTransactionTap: _showTransactionDetail,
              ),
            ),
          ),
        );
      },
    );
  }
}
