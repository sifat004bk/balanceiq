/// Chat feedback type enum
enum FeedbackType {
  like('LIKE'),
  dislike('DISLIKE'),
  none('NONE');

  final String value;
  const FeedbackType(this.value);

  static FeedbackType fromString(String value) {
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
}

/// Chat feedback request model
class ChatFeedbackRequest {
  final FeedbackType feedback;

  const ChatFeedbackRequest({required this.feedback});

  Map<String, dynamic> toJson() {
    return {
      'feedback': feedback.value,
    };
  }

  @override
  String toString() {
    return 'ChatFeedbackRequest(feedback: ${feedback.value})';
  }
}

/// Chat feedback response model
class ChatFeedbackResponse {
  final bool success;
  final String message;

  const ChatFeedbackResponse({
    required this.success,
    required this.message,
  });

  factory ChatFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return ChatFeedbackResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ChatFeedbackResponse(success: $success, message: $message)';
  }
}
