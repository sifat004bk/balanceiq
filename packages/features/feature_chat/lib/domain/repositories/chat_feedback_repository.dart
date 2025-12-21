import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/chat_feedback.dart';

/// Repository for chat feedback operations
abstract class ChatFeedbackRepository {
  /// Submit feedback for a chat message
  ///
  /// Parameters:
  /// - [messageId]: The ID of the chat message (from chat history)
  /// - [feedback]: Feedback type (LIKE, DISLIKE, NONE)
  ///
  /// Returns `Either<Failure, ChatFeedback>`
  ///
  /// Errors:
  /// - AuthFailure: User not authenticated
  /// - PermissionFailure: User doesn't own the message
  /// - NotFoundFailure: Message not found
  /// - ServerFailure: Server error or invalid feedback value
  Future<Either<Failure, ChatFeedback>> submitFeedback({
    required int messageId,
    required FeedbackType feedback,
  });
}
