import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_state.dart';
import '../../../../core/constants/app_constants.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final Uuid uuid;
  String? currentBotId;

  ChatCubit({
    required this.getMessages,
    required this.sendMessage,
    required this.uuid,
  }) : super(ChatInitial());

  Future<void> loadMessages(String botId) async {
    currentBotId = botId;
    if (!isClosed) emit(ChatLoading());
    final result = await getMessages(botId);
    if (!isClosed) {
      result.fold(
        (failure) => emit(ChatError(message: failure.message)),
        (messages) => emit(ChatLoaded(messages: messages)),
      );
    }
  }

  Future<void> sendNewMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      // Create temporary user message for immediate display
      final tempUserMessage = Message(
        id: uuid.v4(),
        botId: botId,
        sender: AppConstants.senderUser,
        content: content,
        imageUrl: imagePath,
        audioUrl: audioPath,
        timestamp: DateTime.now(),
        isSending: false,
        hasError: false,
      );

      // Immediately show user message in UI
      final updatedMessages = [...currentState.messages, tempUserMessage];
      emit(ChatLoaded(messages: updatedMessages, isSending: true));

      // Send message in background (repository will save with different ID)
      final result = await sendMessage(
        botId: botId,
        content: content,
        imagePath: imagePath,
        audioPath: audioPath,
      );

      // After API completes, reload from DB to get actual messages
      if (!isClosed) {
        loadMessages(botId);
      }
    }
  }

  void clearChat() {
    if (currentBotId != null) {
      emit(const ChatLoaded(messages: []));
    }
  }
}
