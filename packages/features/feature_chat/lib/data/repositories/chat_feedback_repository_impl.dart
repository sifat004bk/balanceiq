import 'package:dartz/dartz.dart';
import '../../domain/entities/chat_feedback.dart';
import '../../domain/repositories/chat_feedback_repository.dart';
import 'package:dolfin_core/error/failures.dart';
import '../datasources/chat_feedback_datasource.dart';
import '../models/chat_feedback_model.dart' as model;

class ChatFeedbackRepositoryImpl implements ChatFeedbackRepository {
  final ChatFeedbackDataSource remoteDataSource;

  ChatFeedbackRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatFeedback>> submitFeedback({
    required int messageId,
    required FeedbackType feedback,
  }) async {
    try {
      // Convert entity feedback type to model feedback type
      final modelFeedbackType = _convertFeedbackType(feedback);

      final response = await remoteDataSource.submitFeedback(
        messageId: messageId,
        feedback: modelFeedbackType,
      );

      final chatFeedback = ChatFeedback(
        messageId: messageId,
        feedback: feedback,
        success: response.success,
        message: response.message,
      );

      return Right(chatFeedback);
    } catch (e) {
      // Parse error messages to return appropriate failure types
      final errorMessage = e.toString();

      if (errorMessage.contains('Authentication required') ||
          errorMessage.contains('Unauthorized')) {
        return Left(AuthFailure('Please login to submit feedback'));
      } else if (errorMessage.contains('own messages')) {
        return Left(PermissionFailure(
            'You can only provide feedback on your own messages'));
      } else if (errorMessage.contains('not found')) {
        return Left(NotFoundFailure('Chat message not found'));
      } else if (errorMessage.contains('No internet') ||
          errorMessage.contains('Connection')) {
        return Left(NetworkFailure(
            'No internet connection. Please check your network.'));
      } else if (errorMessage.contains('timeout')) {
        return Left(ServerFailure('Request timed out. Please try again.'));
      } else if (errorMessage.contains('Invalid feedback')) {
        return Left(ServerFailure('Invalid feedback value'));
      } else {
        return Left(ServerFailure('Failed to submit feedback: $errorMessage'));
      }
    }
  }

  /// Convert entity FeedbackType to model FeedbackType
  model.FeedbackType _convertFeedbackType(FeedbackType feedback) {
    switch (feedback) {
      case FeedbackType.like:
        return model.FeedbackType.like;
      case FeedbackType.dislike:
        return model.FeedbackType.dislike;
      case FeedbackType.none:
        return model.FeedbackType.none;
    }
  }
}
