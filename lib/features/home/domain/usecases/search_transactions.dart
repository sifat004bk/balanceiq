import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for searching transactions
class SearchTransactions {
  final TransactionRepository repository;

  SearchTransactions(this.repository);

  /// Call the use case to search transactions
  ///
  /// Parameters:
  /// - [search]: Text to search in descriptions and categories
  /// - [category]: Filter by category name
  /// - [type]: Filter by transaction type (INCOME, EXPENSE, TRANSFER)
  /// - [startDate]: Start date (YYYY-MM-DD)
  /// - [endDate]: End date (YYYY-MM-DD)
  /// - [minAmount]: Minimum amount
  /// - [maxAmount]: Maximum amount
  /// - [limit]: Maximum number of results (default: 50, max: 200)
  ///
  /// Returns Either<Failure, TransactionSearchResult>
  Future<Either<Failure, TransactionSearchResult>> call({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit = 50,
  }) async {
    return await repository.searchTransactions(
      search: search,
      category: category,
      type: type,
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      limit: limit,
    );
  }
}
