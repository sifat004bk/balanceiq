import 'package:balance_iq/core/storage/secure_storage_service.dart';
import 'package:balance_iq/features/chat/domain/entities/chat_history_response.dart';
import 'package:balance_iq/features/chat/domain/entities/message.dart';
import 'package:balance_iq/features/chat/domain/entities/message_usage.dart';
import 'package:balance_iq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:balance_iq/features/chat/presentation/cubit/chat_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import '../../../../mocks/mock_usecases.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockUuid extends Mock implements Uuid {}

void main() {
  late ChatCubit chatCubit;
  late MockGetMessages mockGetMessages;
  late MockGetChatHistory mockGetChatHistory;
  late MockGetMessageUsage mockGetMessageUsage;
  late MockSendMessage mockSendMessage;
  late MockUpdateMessage mockUpdateMessage;
  late MockSubmitFeedback mockSubmitFeedback;
  late MockSecureStorageService mockSecureStorage;
  late MockUuid mockUuid;

  setUp(() {
    mockGetMessages = MockGetMessages();
    mockGetChatHistory = MockGetChatHistory();
    mockGetMessageUsage = MockGetMessageUsage();
    mockSendMessage = MockSendMessage();
    mockUpdateMessage = MockUpdateMessage();
    mockSubmitFeedback = MockSubmitFeedback();
    mockSecureStorage = MockSecureStorageService();
    mockUuid = MockUuid();

    chatCubit = ChatCubit(
      getMessages: mockGetMessages,
      getChatHistory: mockGetChatHistory,
      getMessageUsage: mockGetMessageUsage,
      sendMessage: mockSendMessage,
      updateMessage: mockUpdateMessage,
      submitFeedback: mockSubmitFeedback,
      secureStorage: mockSecureStorage,
      uuid: mockUuid,
    );
  });

  group('ChatCubit', () {
    const testBotId = 'balance_tracker';
    const testUserId = 'user123';

    final testMessageUsage = MessageUsage(
      messagesUsedToday: 5,
      messagesRemaining: 15,
      dailyLimit: 20,
      limitResetsAt: DateTime.now().add(const Duration(hours: 1)),
      usagePercentage: 25.0,
      recentMessages: const [],
    );

    final testMessage = Message(
      id: 'msg1',
      userId: testUserId,
      botId: testBotId,
      sender: 'user',
      content: 'Hello',
      timestamp: DateTime.now(),
      isSending: false,
      hasError: false,
    );

    final testConversation = Conversation(
      id: 1,
      userMessage: 'Hello',
      aiResponse: 'Hi',
      createdAt: DateTime.now().toIso8601String(),
    );

    final testChatHistoryResponse = ChatHistoryResponse(
      userId: 1,
      conversations: [testConversation],
      pagination: const Pagination(
        currentPage: 1,
        limit: 10,
        returned: 1,
        hasNext: false,
      ),
    );

    test('initial state is ChatInitial', () {
      expect(chatCubit.state, isA<ChatInitial>());
    });

    blocTest<ChatCubit, ChatState>(
      'emits ChatLoaded when loadChatHistory succeeds',
      build: () {
        when(() => mockGetMessageUsage())
            .thenAnswer((_) async => Right(testMessageUsage));
        when(() => mockSecureStorage.getUserId())
            .thenAnswer((_) async => testUserId);
        // Return existing messages from DB
        when(() => mockGetMessages(any(), any(), limit: any(named: 'limit')))
            .thenAnswer((_) async => Right([testMessage]));

        when(() => mockGetChatHistory(
              userId: any(named: 'userId'),
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              botId: any(named: 'botId'),
            )).thenAnswer((_) async => Right(testChatHistoryResponse));

        return chatCubit;
      },
      act: (cubit) => cubit.loadChatHistory(testBotId),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatLoaded>(),
        isA<ChatLoaded>(),
      ],
    );
  });
}
