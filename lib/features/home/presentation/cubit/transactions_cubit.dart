import 'package:balance_iq/features/home/domain/entities/transaction.dart';
import 'package:balance_iq/features/home/domain/usecases/delete_transaction.dart';
import 'package:balance_iq/features/home/domain/usecases/update_transaction.dart';
import 'package:balance_iq/features/home/presentation/cubit/transaction_search_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_transactions.dart';
import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final SearchTransactions searchTransactions;
  final UpdateTransaction updateTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;

  TransactionSearchParams _currentParams = TransactionSearchParams(limit: 50);

  TransactionsCubit({
    required this.searchTransactions,
    required this.updateTransactionUseCase,
    required this.deleteTransactionUseCase,
  }) : super(TransactionsInitial());

  Future<void> loadTransactions({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit,
  }) async {
    emit(TransactionsLoading());

    // Update current params
    _currentParams = TransactionSearchParams(
      search: search,
      category: category,
      type: type,
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      limit: limit ?? 50,
    );

    final result = await searchTransactions(
      search: _currentParams.search,
      category: _currentParams.category,
      type: _currentParams.type,
      startDate: _currentParams.startDate,
      endDate: _currentParams.endDate,
      minAmount: _currentParams.minAmount,
      maxAmount: _currentParams.maxAmount,
      limit: _currentParams.limit,
    );

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (searchResult) => emit(
        TransactionsLoaded(
          transactions: searchResult.transactions,
          hasReachedMax: searchResult.transactions.length < (_currentParams.limit ?? 50),
        ),
      ),
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    emit(TransactionsLoading());

    final result = await updateTransactionUseCase(transaction);

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (_) => _reloadTransactions(),
    );
  }

  Future<void> deleteTransaction(int id) async {
    emit(TransactionsLoading());

    final result = await deleteTransactionUseCase(id);

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (_) => _reloadTransactions(),
    );
  }

  Future<void> _reloadTransactions() async {
    final result = await searchTransactions(
      search: _currentParams.search,
      category: _currentParams.category,
      type: _currentParams.type,
      startDate: _currentParams.startDate,
      endDate: _currentParams.endDate,
      minAmount: _currentParams.minAmount,
      maxAmount: _currentParams.maxAmount,
      limit: _currentParams.limit,
    );

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (searchResult) => emit(
        TransactionsLoaded(
          transactions: searchResult.transactions,
          hasReachedMax: searchResult.transactions.length < (_currentParams.limit ?? 50),
        ),
      ),
    );
  }
}
