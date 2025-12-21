import 'package:dartz/dartz.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasource/remote_datasource/transaction_search_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionSearchDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TransactionSearchResult>> searchTransactions({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit,
  }) async {
    try {
      final response = await remoteDataSource.searchTransactions(
        search: search,
        category: category,
        type: type,
        startDate: startDate,
        endDate: endDate,
        minAmount: minAmount,
        maxAmount: maxAmount,
        limit: limit,
      );

      // Convert models to entities
      final transactions = response.transactions
          .map((model) => Transaction(
                transactionId: model.transactionId,
                type: model.type,
                amount: model.amount,
                category: model.category,
                description: model.description,
                transactionDate: model.transactionDate,
                createdAt: model.createdAt,
                relevanceScore: model.relevanceScore,
                totalMatches: model.totalMatches,
              ))
          .toList();

      final result = TransactionSearchResult(
        success: response.success,
        count: response.count,
        transactions: transactions,
      );

      return Right(result);
    } catch (e) {
      // Parse error messages to return appropriate failure types
      final errorMessage = e.toString();

      if (errorMessage.contains('Authentication required') ||
          errorMessage.contains('Unauthorized')) {
        return Left(AuthFailure('Please login to search transactions'));
      } else if (errorMessage.contains('No internet') ||
          errorMessage.contains('Connection')) {
        return Left(NetworkFailure(
            'No internet connection. Please check your network.'));
      } else if (errorMessage.contains('timeout')) {
        return Left(ServerFailure('Request timed out. Please try again.'));
      } else if (errorMessage.contains('Bad request')) {
        return Left(ServerFailure('Invalid search parameters. $errorMessage'));
      } else {
        return Left(
            ServerFailure('Failed to search transactions: $errorMessage'));
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTransaction(
      Transaction transaction) async {
    try {
      await remoteDataSource.updateTransaction(
        id: transaction.transactionId,
        category: transaction.category,
        type: transaction.type,
        amount: transaction.amount,
        description: transaction.description,
        transactionDate: transaction.transactionDate,
      );
      return Right(unit);
    } catch (e) {
      if (e.toString().contains('Authentication required')) {
        return Left(AuthFailure('Please login to update transaction'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(int id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
      return Right(unit);
    } catch (e) {
      if (e.toString().contains('Authentication required')) {
        return Left(AuthFailure('Please login to delete transaction'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
