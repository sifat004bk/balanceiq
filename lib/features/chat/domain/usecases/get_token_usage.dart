import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/token_usage.dart';
import '../repositories/token_usage_repository.dart';

/// Use case for getting token usage statistics
class GetTokenUsage {
  final TokenUsageRepository repository;

  GetTokenUsage(this.repository);

  /// Call the use case to get token usage
  ///
  /// Returns Either<Failure, TokenUsage> containing:
  /// - totalUsage: Total tokens used over all time
  /// - todayUsage: Tokens used since midnight today
  /// - history: Recent usage events (last 10)
  Future<Either<Failure, TokenUsage>> call() async {
    return await repository.getTokenUsage();
  }
}
