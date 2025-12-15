import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/token_usage.dart';
import '../../../../core/constants/app_constants.dart';

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
  final int currentTokenUsage;
  final int dailyTokenLimit;
  final TokenUsage? tokenUsage; // Full token usage data including history

  const ChatLoaded({
    required this.messages,
    this.isSending = false,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.currentTokenUsage = 0,
    int? dailyTokenLimit,
    this.tokenUsage,
  }) : dailyTokenLimit = dailyTokenLimit ?? AppConstants.tokenLimitPer12Hours;

  @override
  List<Object?> get props => [messages, isSending, hasMore, isLoadingMore, currentTokenUsage, dailyTokenLimit, tokenUsage];

  bool get isTokenLimitReached => currentTokenUsage >= dailyTokenLimit;

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isSending,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentTokenUsage,
    int? dailyTokenLimit,
    TokenUsage? tokenUsage,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentTokenUsage: currentTokenUsage ?? this.currentTokenUsage,
      dailyTokenLimit: dailyTokenLimit ?? this.dailyTokenLimit,
      tokenUsage: tokenUsage ?? this.tokenUsage,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  final List<Message>? messages;
  final ChatErrorType? errorType;

  const ChatError({
    required this.message,
    this.messages,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, messages, errorType];
}

/// Types of chat errors for specific handling
enum ChatErrorType {
  emailNotVerified,
  subscriptionRequired,
  subscriptionExpired,
  tokenLimitExceeded,
  rateLimitExceeded,
  general,
}
