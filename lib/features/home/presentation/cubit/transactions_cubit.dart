import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_transactions.dart';
import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final SearchTransactions searchTransactions;

  TransactionsCubit({required this.searchTransactions})
      : super(TransactionsInitial());

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

    final result = await searchTransactions(
      search: search,
      category: category,
      type: type,
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      limit: limit,
    );

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (searchResult) => emit(
        TransactionsLoaded(
          transactions: searchResult.transactions,
          hasReachedMax: searchResult.transactions.length < (limit ?? 50),
        ),
      ),
    );
  }
}
