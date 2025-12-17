import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message_usage.dart';
import '../repositories/message_usage_repository.dart';

/// Use case for getting message usage statistics
class GetMessageUsage {
  final MessageUsageRepository repository;

  GetMessageUsage(this.repository);

  /// Call the use case to get message usage
  ///
  /// Returns Either<Failure, MessageUsage> containing:
  /// - messagesUsedToday: Count of messages sent since 00:00 UTC today
  /// - messagesRemaining: dailyLimit - messagesUsedToday (min 0)
  /// - dailyLimit: Hard limit (currently 10)
  /// - limitResetsAt: Timestamp when counter resets to 0
  /// - usagePercentage: 0.0 to 100.0 consumption percentage
  /// - lastMessageAt: Timestamp of last message (nullable)
  /// - recentMessages: List of up to 10 most recent message activities
  Future<Either<Failure, MessageUsage>> call() async {
    return await repository.getMessageUsage();
  }
}
