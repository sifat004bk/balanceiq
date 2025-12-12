import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isSending;
  final bool hasMore;          // Whether more messages are available to load
  final bool isLoadingMore;    // Whether currently loading more messages

  const ChatLoaded({
    required this.messages,
    this.isSending = false,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.currentTokenUsage = 0,
    this.dailyTokenLimit = 5000,
  });

  @override
  List<Object?> get props => [messages, isSending, hasMore, isLoadingMore, currentTokenUsage, dailyTokenLimit];

  final int currentTokenUsage;
  final int dailyTokenLimit;

  bool get isTokenLimitReached => currentTokenUsage >= dailyTokenLimit;

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isSending,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentTokenUsage,
    int? dailyTokenLimit,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentTokenUsage: currentTokenUsage ?? this.currentTokenUsage,
      dailyTokenLimit: dailyTokenLimit ?? this.dailyTokenLimit,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  final List<Message>? messages;

  const ChatError({
    required this.message,
    this.messages,
  });

  @override
  List<Object?> get props => [message, messages];
}
