/// Request and response models for Finance Guru Chat API endpoints

/// Request model for POST /api/finance-guru/chat
class ChatRequest {
  final String text;
  final String username;
  final String? imageBase64;
  final String? audioBase64;

  ChatRequest({
    required this.text,
    required this.username,
    this.imageBase64,
    this.audioBase64,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'text': text,
      'username': username,
    };

    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      data['image_base64'] = imageBase64!;
    }

    if (audioBase64 != null && audioBase64!.isNotEmpty) {
      data['audio_base64'] = audioBase64!;
    }

    return data;
  }

  /// Create request from user data for finance-guru API
  factory ChatRequest.fromUserData({
    required String message,
    required String username,
    String? imageBase64,
    String? audioBase64,
  }) {
    return ChatRequest(
      text: message,
      username: username,
      imageBase64: imageBase64,
      audioBase64: audioBase64,
    );
  }
}

/// Response model for POST /api/finance-guru/chat
class ChatResponse {
  final String message;
  final String? id;
  final String? imageUrl;
  final String? audioUrl;

  ChatResponse({
    required this.message,
    this.id,
    this.imageUrl,
    this.audioUrl,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] as String? ??
               json['response'] as String? ??
               '',
      id: json['id'] as String?,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (id != null) 'id': id,
      if (imageUrl != null) 'image_url': imageUrl,
      if (audioUrl != null) 'audio_url': audioUrl,
    };
  }
}

/// Request model for GET /api/finance-guru/chat-history
class ChatHistoryQueryParams {
  final int page;
  final int limit;

  ChatHistoryQueryParams({
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
    };
  }
}

/// Response model for GET /api/finance-guru/chat-history
class ChatHistoryResponse {
  final List<ChatHistoryItem> messages;
  final int? page;
  final int? limit;
  final int? total;
  final bool? hasMore;

  ChatHistoryResponse({
    required this.messages,
    this.page,
    this.limit,
    this.total,
    this.hasMore,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    final messagesList = json['messages'] as List<dynamic>? ?? [];

    return ChatHistoryResponse(
      messages: messagesList
          .map((item) => ChatHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      hasMore: json['hasMore'] as bool? ?? json['has_more'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (total != null) 'total': total,
      if (hasMore != null) 'hasMore': hasMore,
    };
  }
}

/// Individual chat history item
class ChatHistoryItem {
  final String id;
  final String userId;
  final String message;
  final String? response;
  final String? imageBase64;
  final String? audioBase64;
  final DateTime timestamp;

  ChatHistoryItem({
    required this.id,
    required this.userId,
    required this.message,
    this.response,
    this.imageBase64,
    this.audioBase64,
    required this.timestamp,
  });

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) {
    return ChatHistoryItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      message: json['message'] as String? ?? '',
      response: json['response'] as String?,
      imageBase64: json['image_base64'] as String? ?? json['imageBase64'] as String?,
      audioBase64: json['audio_base64'] as String? ?? json['audioBase64'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      if (response != null) 'response': response,
      if (imageBase64 != null) 'image_base64': imageBase64,
      if (audioBase64 != null) 'audio_base64': audioBase64,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
