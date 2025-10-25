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

  const ChatLoaded({
    required this.messages,
    this.isSending = false,
  });

  @override
  List<Object?> get props => [messages, isSending];

  ChatLoaded copyWith({
    List<Message>? messages,
    bool? isSending,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
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
