import '../../domain/entities/chat_history_response.dart';
import '../../domain/entities/chart_data.dart';
import 'message_model.dart';

/// Response model for chat history API
/// Maps to: GET /api/finance-guru/chat-history
class ChatHistoryResponseModel {
  final int userId;
  final List<ConversationModel> conversations;
  final PaginationModel pagination;

  ChatHistoryResponseModel({
    required this.userId,
    required this.conversations,
    required this.pagination,
  });

  factory ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponseModel(
      userId: json['userId'] as int,
      conversations: (json['conversations'] as List<dynamic>)
          .map((item) => ConversationModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'conversations': conversations.map((c) => c.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  /// Convert to domain entity
  ChatHistoryResponse toEntity() {
    return ChatHistoryResponse(
      userId: userId,
      conversations: conversations.map((c) => c.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }

  /// Convert conversations to MessageModels for local storage
  List<MessageModel> toMessageModels(String botId) {
    final messages = <MessageModel>[];

    for (var conversation in conversations) {
      // User message - use conversation ID
      messages.add(MessageModel(
        id: '${userId}_${conversation.id}_user',
        userId: userId.toString(),
        botId: botId,
        sender: 'user',
        content: conversation.userMessage,
        timestamp: DateTime.parse(conversation.createdAt),
        serverCreatedAt: DateTime.parse(conversation.createdAt),
        isSynced: true,
        syncStatus: 'sent',
        conversationId: conversation.id,
      ));

      // AI response - use conversation ID
      messages.add(MessageModel(
        id: '${userId}_${conversation.id}_bot',
        userId: userId.toString(),
        botId: botId,
        sender: 'bot',
        content: conversation.aiResponse,
        timestamp: DateTime.parse(conversation.createdAt).add(const Duration(milliseconds: 1)),
        serverCreatedAt: DateTime.parse(conversation.createdAt).add(const Duration(milliseconds: 1)),
        isSynced: true,
        syncStatus: 'sent',
        conversationId: conversation.id,
        feedback: conversation.feedback,
        hasTable: conversation.hasTable,
        tableData: conversation.tableData,
        graphType: conversation.graphType,
        graphData: conversation.graphData,
      ));
    }

    return messages;
  }
}

/// Represents a single conversation (user message + AI response)
class ConversationModel {
  final int id;
  final String userMessage;
  final String aiResponse;
  final String createdAt;
  final String? feedback;

  // GenUI Data
  final bool hasTable;
  final GenUITableData? tableData;
  final GraphType? graphType;
  final GraphData? graphData;

  ConversationModel({
    required this.id,
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
    this.feedback,
    this.hasTable = false,
    this.tableData,
    this.graphType,
    this.graphData,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,
      userMessage: json['userMessage'] as String,
      aiResponse: json['aiResponse'] as String,
      createdAt: json['createdAt'] as String,
      feedback: json['feedback'] as String?,
      hasTable: json['hasTable'] as bool? ?? false,
      tableData: json['tableData'] != null
          ? GenUITableData.fromJson(json['tableData'] as Map<String, dynamic>)
          : null,
      graphType: GraphType.fromString(json['graphType'] as String?),
      graphData: json['graphData'] != null
          ? GraphData.fromJson(json['graphData'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'createdAt': createdAt,
      'feedback': feedback,
      'hasTable': hasTable,
      'tableData': tableData?.toJson(),
      'graphType': graphType?.value,
      'graphData': graphData?.toJson(),
    };
  }

  Conversation toEntity() {
    return Conversation(
      id: id,
      userMessage: userMessage,
      aiResponse: aiResponse,
      createdAt: createdAt,
      feedback: feedback,
      hasTable: hasTable,
      tableData: tableData,
      graphType: graphType,
      graphData: graphData,
    );
  }
}

/// Pagination metadata
class PaginationModel {
  final int currentPage;
  final int limit;
  final int returned;
  final bool hasNext;
  final int? nextPage;

  PaginationModel({
    required this.currentPage,
    required this.limit,
    required this.returned,
    required this.hasNext,
    this.nextPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['currentPage'] as int,
      limit: json['limit'] as int,
      returned: json['returned'] as int,
      hasNext: json['hasNext'] as bool,
      nextPage: json['nextPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'limit': limit,
      'returned': returned,
      'hasNext': hasNext,
      'nextPage': nextPage,
    };
  }

  Pagination toEntity() {
    return Pagination(
      currentPage: currentPage,
      limit: limit,
      returned: returned,
      hasNext: hasNext,
      nextPage: nextPage,
    );
  }
}
