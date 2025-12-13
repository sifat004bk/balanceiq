import 'package:equatable/equatable.dart';
import 'chart_data.dart';

class Message extends Equatable {
  final String id;
  final String userId;  // User isolation - each user sees only their messages
  final String botId;
  final String sender; // 'user' or 'bot'
  final String content;
  final String? imageUrl;
  final String? audioUrl;
  final DateTime timestamp;
  final bool isSending;
  final bool hasError;

  // Sync fields for chat history API integration
  final DateTime? serverCreatedAt;  // Source of truth for ordering
  final bool isSynced;               // Whether synced with backend
  final String syncStatus;           // 'pending', 'sent', 'failed'
  final String? apiMessageId;        // Backend message ID
  final String? actionType;          // Action type (e.g., balance_query, income_log)
  final int? conversationId;         // Links to API conversation ID (for feedback)
  final String? feedback;            // User feedback: 'LIKE', 'DISLIKE', or null

  // Rendering metadata (from API response)
  final bool hasTable;               // Whether response includes table data
  final GenUITableData? tableData;        // Table data for rendering
  final GraphType? graphType;        // Type of graph (line, bar, or null)
  final GraphData? graphData;        // Graph data for rendering charts

  const Message({
    required this.id,
    required this.userId,
    required this.botId,
    required this.sender,
    required this.content,
    this.imageUrl,
    this.audioUrl,
    required this.timestamp,
    this.isSending = false,
    this.hasError = false,
    this.serverCreatedAt,
    this.isSynced = false,
    this.syncStatus = 'pending',
    this.apiMessageId,
    this.actionType,
    this.conversationId,
    this.feedback,
    this.hasTable = false,
    this.tableData,
    this.graphType,
    this.graphData,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        botId,
        sender,
        content,
        imageUrl,
        audioUrl,
        timestamp,
        isSending,
        hasError,
        serverCreatedAt,
        isSynced,
        syncStatus,
        apiMessageId,
        actionType,
        conversationId,
        feedback,
        hasTable,
        tableData,
        graphType,
        graphData,
      ];

  Message copyWith({
    String? id,
    String? userId,
    String? botId,
    String? sender,
    String? content,
    String? imageUrl,
    String? audioUrl,
    DateTime? timestamp,
    bool? isSending,
    bool? hasError,
    DateTime? serverCreatedAt,
    bool? isSynced,
    String? syncStatus,
    String? apiMessageId,
    String? actionType,
    int? conversationId,
    String? feedback,
    bool? hasTable,
    GenUITableData? tableData,
    GraphType? graphType,
    GraphData? graphData,
  }) {
    return Message(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      botId: botId ?? this.botId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      timestamp: timestamp ?? this.timestamp,
      isSending: isSending ?? this.isSending,
      hasError: hasError ?? this.hasError,
      serverCreatedAt: serverCreatedAt ?? this.serverCreatedAt,
      isSynced: isSynced ?? this.isSynced,
      syncStatus: syncStatus ?? this.syncStatus,
      apiMessageId: apiMessageId ?? this.apiMessageId,
      actionType: actionType ?? this.actionType,
      conversationId: conversationId ?? this.conversationId,
      feedback: feedback ?? this.feedback,
      hasTable: hasTable ?? this.hasTable,
      tableData: tableData ?? this.tableData,
      graphType: graphType ?? this.graphType,
      graphData: graphData ?? this.graphData,
    );
  }
}
