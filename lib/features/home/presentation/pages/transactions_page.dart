import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_cubit.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_filter_state.dart';
import 'package:balance_iq/features/home/presentation/cubit/transactions_cubit.dart';
import 'package:balance_iq/features/home/presentation/widgets/transaction_detail_modal.dart';
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
  @override
  void initState() {
    super.initState();
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
              const TransactionsFilterSection(),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: TransactionsList(
                  onTransactionTap: _showTransactionDetail,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
