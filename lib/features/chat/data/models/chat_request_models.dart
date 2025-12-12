/// Request and response models for Finance Guru Chat API endpoints
/// Based on Postman API Collection spec

/// Request model for POST /api/finance-guru/chat
/// Spec: {"text": "...", "username": "..."}
class ChatRequest {
  final String text;
  final String username;

  ChatRequest({
    required this.text,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'username': username,
    };
  }

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      text: json['text'] as String,
      username: json['username'] as String,
    );
  }
}

/// Response model for POST /api/finance-guru/chat
/// Actual API response includes token usage and action type
class ChatResponse {
  final bool success;
  final String message;
  final int userId;
  final String timestamp;
  final TokenUsage? tokenUsage;
  final String? actionType;

  ChatResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.timestamp,
    this.tokenUsage,
    this.actionType,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ??
               json['response'] as String? ??
               '',
      userId: json['userId'] as int? ?? 0,
      timestamp: json['timestamp'] as String? ?? '',
      tokenUsage: json['tokenUsage'] != null
          ? TokenUsage.fromJson(json['tokenUsage'] as Map<String, dynamic>)
          : null,
      actionType: json['actionType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'userId': userId,
      'timestamp': timestamp,
      if (tokenUsage != null) 'tokenUsage': tokenUsage!.toJson(),
      if (actionType != null) 'actionType': actionType,
    };
  }
}

/// Token usage statistics from LLM
class TokenUsage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  TokenUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory TokenUsage.fromJson(Map<String, dynamic> json) {
    return TokenUsage(
      promptTokens: json['promptTokens'] as int? ?? 0,
      completionTokens: json['completionTokens'] as int? ?? 0,
      totalTokens: json['totalTokens'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promptTokens': promptTokens,
      'completionTokens': completionTokens,
      'totalTokens': totalTokens,
    };
  }
}

/// Query parameters for GET /api/finance-guru/v1/chat-history
/// Spec: ?page=1&size=20
class ChatHistoryQueryParams {
  final int page;
  final int size;

  ChatHistoryQueryParams({
    this.page = 1,
    this.size = 20,
  });

  Map<String, String> toQueryParams() {
    return {
      'page': page.toString(),
      'size': size.toString(),
    };
  }
}

/// Response model for GET /api/finance-guru/chat-history
/// Actual API response structure
class ChatHistoryResponse {
  final int userId;
  final List<Conversation> conversations;
  final Pagination pagination;

  ChatHistoryResponse({
    required this.userId,
    required this.conversations,
    required this.pagination,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    final conversationsList = json['conversations'] as List<dynamic>? ?? [];

    return ChatHistoryResponse(
      userId: json['userId'] as int? ?? 0,
      conversations: conversationsList
          .map((item) => Conversation.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : Pagination(
              currentPage: 1,
              limit: 10,
              returned: 0,
              hasNext: false,
              nextPage: null,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'conversations': conversations.map((c) => c.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

/// Individual conversation item
class Conversation {
  final String userMessage;
  final String aiResponse;
  final String createdAt;

  Conversation({
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userMessage: json['userMessage'] as String? ?? '',
      aiResponse: json['aiResponse'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'createdAt': createdAt,
    };
  }
}

/// Pagination metadata
class Pagination {
  final int currentPage;
  final int limit;
  final int returned;
  final bool hasNext;
  final int? nextPage;

  Pagination({
    required this.currentPage,
    required this.limit,
    required this.returned,
    required this.hasNext,
    this.nextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      returned: json['returned'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      nextPage: json['nextPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'limit': limit,
      'returned': returned,
      'hasNext': hasNext,
      if (nextPage != null) 'nextPage': nextPage,
    };
  }
}
