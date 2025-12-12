import 'package:equatable/equatable.dart';

/// Domain entity for chat history API response
class ChatHistoryResponse extends Equatable {
  final int userId;
  final List<Conversation> conversations;
  final Pagination pagination;

  const ChatHistoryResponse({
    required this.userId,
    required this.conversations,
    required this.pagination,
  });

  @override
  List<Object?> get props => [userId, conversations, pagination];
}

/// Represents a single conversation (user message + AI response)
class Conversation extends Equatable {
  final int id;
  final String userMessage;
  final String aiResponse;
  final String createdAt;
  final String? feedback;

  const Conversation({
    required this.id,
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
    this.feedback,
  });

  @override
  List<Object?> get props => [id, userMessage, aiResponse, createdAt, feedback];

  /// Helper to check if conversation has feedback
  bool get hasFeedback => feedback != null && feedback!.isNotEmpty;

  /// Helper to check if user liked the conversation
  bool get isLiked => feedback == 'LIKE';

  /// Helper to check if user disliked the conversation
  bool get isDisliked => feedback == 'DISLIKE';
}

/// Pagination metadata
class Pagination extends Equatable {
  final int currentPage;
  final int limit;
  final int returned;
  final bool hasNext;
  final int? nextPage;

  const Pagination({
    required this.currentPage,
    required this.limit,
    required this.returned,
    required this.hasNext,
    this.nextPage,
  });

  @override
  List<Object?> get props => [currentPage, limit, returned, hasNext, nextPage];
}
