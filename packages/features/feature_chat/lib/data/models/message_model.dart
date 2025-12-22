import 'dart:convert';
import '../../domain/entities/message.dart';
import '../../domain/entities/chart_data.dart';
import 'chart_data_model.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.userId,
    required super.botId,
    required super.sender,
    required super.content,
    super.imageUrl,
    super.audioUrl,
    required super.timestamp,
    super.isSending,
    super.hasError,
    super.serverCreatedAt,
    super.isSynced,
    super.syncStatus,
    super.apiMessageId,
    super.actionType,
    super.conversationId,
    super.feedback,
    super.hasTable,
    super.tableData,
    super.graphType,
    super.graphData,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    // Parse table data from JSON string
    GenUITableData? parsedTableData;
    if (json['table_data'] != null && json['table_data'] is String) {
      try {
        final tableJson = jsonDecode(json['table_data'] as String);
        parsedTableData =
            GenUITableData.fromJson(tableJson as Map<String, dynamic>);
      } catch (e) {
        // If parsing fails, leave as null
      }
    }

    // Parse graph data from JSON string
    GraphData? parsedGraphData;
    if (json['graph_data'] != null && json['graph_data'] is String) {
      try {
        final graphJson = jsonDecode(json['graph_data'] as String);
        parsedGraphData =
            GraphDataModel.fromJson(graphJson as Map<String, dynamic>);
      } catch (e) {
        // If parsing fails, leave as null
      }
    }

    // Parse graph type from string
    GraphType? parsedGraphType;
    if (json['graph_type'] != null) {
      parsedGraphType = GraphType.fromString(json['graph_type'] as String);
    }

    return MessageModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      botId: json['bot_id'] as String,
      sender: json['sender'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSending: json['is_sending'] == 1,
      hasError: json['has_error'] == 1,
      serverCreatedAt: json['server_created_at'] != null
          ? DateTime.parse(json['server_created_at'] as String)
          : null,
      isSynced: json['is_synced'] == 1,
      syncStatus: json['sync_status'] as String? ?? 'pending',
      apiMessageId: json['api_message_id'] as String?,
      actionType: json['action_type'] as String?,
      conversationId: json['conversation_id'] as int?,
      feedback: json['feedback'] as String?,
      hasTable: json['has_table'] == 1,
      tableData: parsedTableData,
      graphType: parsedGraphType,
      graphData: parsedGraphData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bot_id': botId,
      'sender': sender,
      'content': content,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'timestamp': timestamp.toIso8601String(),
      'is_sending': isSending ? 1 : 0,
      'has_error': hasError ? 1 : 0,
      'server_created_at': serverCreatedAt?.toIso8601String(),
      'is_synced': isSynced ? 1 : 0,
      'sync_status': syncStatus,
      'api_message_id': apiMessageId,
      'action_type': actionType,
      'conversation_id': conversationId,
      'feedback': feedback,
      'has_table': hasTable ? 1 : 0,
      'table_data': tableData != null
          ? jsonEncode(TableDataModel.fromEntity(tableData!).toJson())
          : null,
      'graph_type': graphType?.value,
      'graph_data': graphData != null
          ? jsonEncode(GraphDataModel.fromEntity(graphData!).toJson())
          : null,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      userId: message.userId,
      botId: message.botId,
      sender: message.sender,
      content: message.content,
      imageUrl: message.imageUrl,
      audioUrl: message.audioUrl,
      timestamp: message.timestamp,
      isSending: message.isSending,
      hasError: message.hasError,
      serverCreatedAt: message.serverCreatedAt,
      isSynced: message.isSynced,
      syncStatus: message.syncStatus,
      apiMessageId: message.apiMessageId,
      actionType: message.actionType,
      conversationId: message.conversationId,
      feedback: message.feedback,
      hasTable: message.hasTable,
      tableData: message.tableData,
      graphType: message.graphType,
      graphData: message.graphData,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      userId: userId,
      botId: botId,
      sender: sender,
      content: content,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      timestamp: timestamp,
      isSending: isSending,
      hasError: hasError,
      serverCreatedAt: serverCreatedAt,
      isSynced: isSynced,
      syncStatus: syncStatus,
      apiMessageId: apiMessageId,
      actionType: actionType,
      conversationId: conversationId,
      feedback: feedback,
      hasTable: hasTable,
      tableData: tableData,
      graphType: graphType,
      graphData: graphData,
    );
  }
}
