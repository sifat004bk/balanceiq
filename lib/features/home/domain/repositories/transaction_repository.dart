import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/transaction.dart';

/// Repository for transaction search operations
abstract class TransactionRepository {
  /// Search transactions with flexible filters
  ///
  /// Parameters:
  /// - [search]: Text to search in descriptions and categories (fuzzy matching)
  /// - [category]: Filter by category name (partial match)
  /// - [type]: Filter by transaction type (INCOME, EXPENSE, TRANSFER)
  /// - [startDate]: Start date for the transaction range (YYYY-MM-DD)
  /// - [endDate]: End date for the transaction range (YYYY-MM-DD)
  /// - [minAmount]: Minimum transaction amount
  /// - [maxAmount]: Maximum transaction amount
  /// - [limit]: Maximum number of results to return (max 200)
  ///
  /// Returns `Either<Failure, TransactionSearchResult>`
  Future<Either<Failure, TransactionSearchResult>> searchTransactions({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit,
  });

  /// Update an existing transaction
  Future<Either<Failure, Unit>> updateTransaction(Transaction transaction);

  /// Delete a transaction by ID
  Future<Either<Failure, Unit>> deleteTransaction(int id);
}
