import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_usage.dart';
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
  final bool hasMore; // Whether more messages are available to load
  final bool isLoadingMore; // Whether currently loading more messages
  final int messagesUsedToday;
  final int dailyMessageLimit;
  final MessageUsage?
      messageUsage; // Full message usage data including recent activity

  const ChatLoaded({
    required this.messages,
    this.isSending = false,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.messagesUsedToday = 0,
    int? dailyMessageLimit,
    this.messageUsage,
  }) : dailyMessageLimit = dailyMessageLimit ?? AppConstants.dailyMessageLimit;

  @override
  List<Object?> get props => [
        messages,
        isSending,
        hasMore,
        isLoadingMore,
        messagesUsedToday,
        dailyMessageLimit,
        messageUsage
      ];

  bool get isMessageLimitReached => messagesUsedToday >= dailyMessageLimit;

  /// Returns remaining messages (min 0)
  int get messagesRemaining =>
      (dailyMessageLimit - messagesUsedToday).clamp(0, dailyMessageLimit);

  /// Returns usage percentage (0.0 to 1.0)
  double get usagePercentage => dailyMessageLimit > 0
      ? (messagesUsedToday / dailyMessageLimit).clamp(0.0, 1.0)
      : 0.0;

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isSending,
    bool? hasMore,
    bool? isLoadingMore,
    int? messagesUsedToday,
    int? dailyMessageLimit,
    MessageUsage? messageUsage,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      messagesUsedToday: messagesUsedToday ?? this.messagesUsedToday,
      dailyMessageLimit: dailyMessageLimit ?? this.dailyMessageLimit,
      messageUsage: messageUsage ?? this.messageUsage,
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
  messageLimitExceeded, // Renamed from tokenLimitExceeded
  rateLimitExceeded,
  general,
}
