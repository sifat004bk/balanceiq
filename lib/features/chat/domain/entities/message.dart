import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
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

  const Message({
    required this.id,
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
  });

  @override
  List<Object?> get props => [
        id,
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
      ];

  Message copyWith({
    String? id,
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
  }) {
    return Message(
      id: id ?? this.id,
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
    );
  }
}
