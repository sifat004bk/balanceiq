import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message_usage.dart';

/// Repository for message usage operations
abstract class MessageUsageRepository {
  /// Get user's message usage statistics
  ///
  /// Returns Either<Failure, MessageUsage>
  /// - messagesUsedToday: Messages sent since 00:00 UTC today
  /// - messagesRemaining: Daily limit - messages used today
  /// - dailyLimit: Maximum messages per day (currently 10)
  /// - limitResetsAt: When the counter resets to 0
  /// - usagePercentage: 0.0 to 100.0 consumption percentage
  /// - lastMessageAt: Timestamp of last message (nullable)
  /// - recentMessages: List of recent message activities
  Future<Either<Failure, MessageUsage>> getMessageUsage();
}
