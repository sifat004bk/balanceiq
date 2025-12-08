import 'package:dartz/dartz.dart';
import '../../domain/entities/token_usage.dart';
import '../../domain/repositories/token_usage_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/token_usage_datasource.dart';

class TokenUsageRepositoryImpl implements TokenUsageRepository {
  final TokenUsageDataSource remoteDataSource;

  TokenUsageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TokenUsage>> getTokenUsage() async {
    try {
      final model = await remoteDataSource.getTokenUsage();

      // Convert history items from models to entities
      final historyItems = model.history
          .map((item) => TokenUsageHistoryItem(
                amount: item.amount,
                action: item.action,
                timestamp: item.timestamp,
              ))
          .toList();

      final tokenUsage = TokenUsage(
        totalUsage: model.totalUsage,
        todayUsage: model.todayUsage,
        history: historyItems,
      );

      return Right(tokenUsage);
    } catch (e) {
      // Parse error messages to return appropriate failure types
      final errorMessage = e.toString();

      if (errorMessage.contains('Authentication required') ||
          errorMessage.contains('Unauthorized')) {
        return Left(AuthFailure('Please login to view token usage'));
      } else if (errorMessage.contains('No internet') ||
          errorMessage.contains('Connection')) {
        return Left(
            NetworkFailure('No internet connection. Please check your network.'));
      } else if (errorMessage.contains('timeout')) {
        return Left(ServerFailure('Request timed out. Please try again.'));
      } else {
        return Left(ServerFailure('Failed to load token usage: $errorMessage'));
      }
    }
  }
}
