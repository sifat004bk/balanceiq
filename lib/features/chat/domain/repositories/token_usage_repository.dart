import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/token_usage.dart';

/// Repository for token usage operations
abstract class TokenUsageRepository {
  /// Get user's token usage statistics
  ///
  /// Returns Either<Failure, TokenUsage>
  /// - totalUsage: Total tokens used by user over all time
  /// - todayUsage: Tokens used since midnight today
  /// - history: List of recent usage events (last 10)
  Future<Either<Failure, TokenUsage>> getTokenUsage();
}
