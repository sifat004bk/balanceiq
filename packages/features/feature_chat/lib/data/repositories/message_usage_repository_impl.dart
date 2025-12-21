import 'package:dartz/dartz.dart';
import '../../domain/entities/message_usage.dart';
import '../../domain/repositories/message_usage_repository.dart';
import 'package:dolfin_core/error/failures.dart';
import '../datasources/message_usage_datasource.dart';

class MessageUsageRepositoryImpl implements MessageUsageRepository {
  final MessageUsageDataSource remoteDataSource;

  MessageUsageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MessageUsage>> getMessageUsage() async {
    try {
      final model = await remoteDataSource.getMessageUsage();

      // Convert recent message items from models to entities
      final recentItems = model.recentMessages
          .map((item) => RecentMessageItem(
                timestamp: item.timestamp,
                actionType: item.actionType,
              ))
          .toList();

      final messageUsage = MessageUsage(
        messagesUsedToday: model.messagesUsedToday,
        messagesRemaining: model.messagesRemaining,
        dailyLimit: model.dailyLimit,
        limitResetsAt: model.limitResetsAt,
        usagePercentage: model.usagePercentage,
        lastMessageAt: model.lastMessageAt,
        recentMessages: recentItems,
      );

      return Right(messageUsage);
    } catch (e) {
      // Parse error messages to return appropriate failure types
      final errorMessage = e.toString();

      if (errorMessage.contains('Authentication required') ||
          errorMessage.contains('Unauthorized')) {
        return Left(AuthFailure('Please login to view message usage'));
      } else if (errorMessage.contains('No internet') ||
          errorMessage.contains('Connection')) {
        return Left(NetworkFailure(
            'No internet connection. Please check your network.'));
      } else if (errorMessage.contains('timeout')) {
        return Left(ServerFailure('Request timed out. Please try again.'));
      } else {
        return Left(
            ServerFailure('Failed to load message usage: $errorMessage'));
      }
    }
  }
}
