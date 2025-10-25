import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.botId,
    required super.sender,
    required super.content,
    super.imageUrl,
    super.audioUrl,
    required super.timestamp,
    super.isSending,
    super.hasError,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      botId: json['bot_id'] as String,
      sender: json['sender'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSending: json['is_sending'] == 1,
      hasError: json['has_error'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bot_id': botId,
      'sender': sender,
      'content': content,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'timestamp': timestamp.toIso8601String(),
      'is_sending': isSending ? 1 : 0,
      'has_error': hasError ? 1 : 0,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      botId: message.botId,
      sender: message.sender,
      content: message.content,
      imageUrl: message.imageUrl,
      audioUrl: message.audioUrl,
      timestamp: message.timestamp,
      isSending: message.isSending,
      hasError: message.hasError,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      botId: botId,
      sender: sender,
      content: content,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
      timestamp: timestamp,
      isSending: isSending,
      hasError: hasError,
    );
  }
}
