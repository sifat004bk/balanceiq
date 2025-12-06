import '../../domain/entities/message.dart';

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
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
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
    );
  }
}
