import 'package:equatable/equatable.dart';

/// Feedback type enum
enum FeedbackType {
  like,
  dislike,
  none;

  /// Convert to API value
  String toApiValue() {
    switch (this) {
      case FeedbackType.like:
        return 'LIKE';
      case FeedbackType.dislike:
        return 'DISLIKE';
      case FeedbackType.none:
        return 'NONE';
    }
  }

  /// Create from API value
  static FeedbackType fromApiValue(String value) {
    switch (value.toUpperCase()) {
      case 'LIKE':
        return FeedbackType.like;
      case 'DISLIKE':
        return FeedbackType.dislike;
      case 'NONE':
        return FeedbackType.none;
      default:
        throw ArgumentError('Invalid feedback type: $value');
    }
  }

  /// Display text for UI
  String get displayText {
    switch (this) {
      case FeedbackType.like:
        return 'Like';
      case FeedbackType.dislike:
        return 'Dislike';
      case FeedbackType.none:
        return 'None';
    }
  }
}

/// Chat feedback entity
class ChatFeedback extends Equatable {
  final int messageId;
  final FeedbackType feedback;
  final bool success;
  final String? message;

  const ChatFeedback({
    required this.messageId,
    required this.feedback,
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [messageId, feedback, success, message];

  /// Check if feedback was successfully submitted
  bool get isSuccessful => success;

  /// Check if user liked the message
  bool get isLiked => feedback == FeedbackType.like;

  /// Check if user disliked the message
  bool get isDisliked => feedback == FeedbackType.dislike;

  /// Check if no feedback
  bool get hasNoFeedback => feedback == FeedbackType.none;

  @override
  String toString() {
    return 'ChatFeedback(messageId: $messageId, feedback: ${feedback.displayText}, success: $success)';
  }
}
