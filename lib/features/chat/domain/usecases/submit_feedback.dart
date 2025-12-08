import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_feedback.dart';
import '../repositories/chat_feedback_repository.dart';

/// Use case for submitting feedback on chat messages
class SubmitFeedback {
  final ChatFeedbackRepository repository;

  SubmitFeedback(this.repository);

  /// Call the use case to submit feedback
  ///
  /// Parameters:
  /// - [messageId]: The ID of the chat message (from chat history)
  /// - [feedback]: Feedback type (like, dislike, none)
  ///
  /// Returns Either<Failure, ChatFeedback>
  ///
  /// Possible failures:
  /// - AuthFailure: User not authenticated
  /// - PermissionFailure: User doesn't own the message
  /// - NotFoundFailure: Message not found
  /// - ServerFailure: Server error or network issue
  Future<Either<Failure, ChatFeedback>> call({
    required int messageId,
    required FeedbackType feedback,
  }) async {
    return await repository.submitFeedback(
      messageId: messageId,
      feedback: feedback,
    );
  }
}
