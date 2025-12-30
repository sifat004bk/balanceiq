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
      limit: _currentParams.limit ?? 50,
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(TransactionsError(failure.message));
      },
      (searchResult) {
        if (!isClosed) {
          emit(
            TransactionsLoaded(
              transactions: searchResult.transactions,
              hasReachedMax: searchResult.transactions.length <
                  (_currentParams.limit ?? 50),
            ),
          );
        }
      },
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    if (isClosed) return;
    emit(TransactionsLoading());

    final result = await updateTransactionUseCase(transaction);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(TransactionsError(failure.message));
      },
      (_) => _reloadTransactions(),
    );
  }

  Future<void> deleteTransaction(int id) async {
    if (isClosed) return;
    emit(TransactionsLoading());

    final result = await deleteTransactionUseCase(id);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(TransactionsError(failure.message));
      },
      (_) => _reloadTransactions(),
    );
  }

  Future<void> _reloadTransactions() async {
    if (isClosed) return;

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

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(TransactionsError(failure.message));
      },
      (searchResult) {
        if (!isClosed) {
          emit(
            TransactionsLoaded(
              transactions: searchResult.transactions,
              hasReachedMax: searchResult.transactions.length <
                  (_currentParams.limit ?? 50),
            ),
          );
        }
      },
    );
  }

  Future<void> loadMoreTransactions() async {
    if (isClosed) return;
    if (state is! TransactionsLoaded) return;
    final currentState = state as TransactionsLoaded;
    if (currentState.hasReachedMax || currentState.isMoreLoading) return;

    emit(currentState.copyWith(isMoreLoading: true));

    final newLimit = (_currentParams.limit ?? 50) + 50;
    _currentParams = _currentParams.copyWith(limit: newLimit);

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

    if (isClosed) return;

    result.fold(
      (failure) {
        // In case of error loading more, we revert isMoreLoading but keep old data
        // For now, simpler to just show error or emit loaded without loading
        if (!isClosed) emit(currentState.copyWith(isMoreLoading: false));
      },
      (searchResult) {
        if (!isClosed) {
          emit(
            TransactionsLoaded(
              transactions: searchResult.transactions,
              hasReachedMax: searchResult.transactions.length <
                  (_currentParams.limit ?? 50),
              isMoreLoading: false,
            ),
          );
        }
      },
    );
  }
}
