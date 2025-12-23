import 'package:dolfin_core/error/failures.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:feature_chat/domain/entities/chat_history_response.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:feature_chat/domain/entities/message_usage.dart';
import 'package:feature_chat/presentation/cubit/chat_cubit.dart';
import 'package:feature_chat/presentation/cubit/chat_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import '../../mocks.dart';

import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockUuid extends Mock implements Uuid {}

class MockAppConstants extends Mock implements AppConstants {}

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
  late MockAppConstants mockAppConstants;

  setUp(() {
    mockGetMessages = MockGetMessages();
    mockGetChatHistory = MockGetChatHistory();
    mockGetMessageUsage = MockGetMessageUsage();
    mockSendMessage = MockSendMessage();
    mockUpdateMessage = MockUpdateMessage();
    mockSubmitFeedback = MockSubmitFeedback();
    mockSecureStorage = MockSecureStorageService();
    mockUuid = MockUuid();
    mockAppConstants = MockAppConstants();

    GetIt.instance.registerSingleton<AppConstants>(mockAppConstants);
    when(() => mockAppConstants.senderBot).thenReturn('bot');
    when(() => mockAppConstants.senderUser).thenReturn('user');
    when(() => mockAppConstants.dailyMessageLimit).thenReturn(20);

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

  tearDown(() {
    GetIt.instance.reset();
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

    blocTest<ChatCubit, ChatState>(
      'emits ChatError with currencyRequired when sendMessage fails with currencyRequired',
      seed: () => ChatLoaded(
        messages: [],
        isSending: false,
      ),
      build: () {
        when(() => mockSecureStorage.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockUuid.v4()).thenReturn('temp_msg_id');
        when(() => mockGetMessageUsage())
            .thenAnswer((_) async => Right(testMessageUsage));

        when(() => mockSendMessage(
              botId: any(named: 'botId'),
              content: any(named: 'content'),
              imagePath: any(named: 'imagePath'),
              audioPath: any(named: 'audioPath'),
            )).thenAnswer((_) async => const Left(ChatApiFailure(
              'Currency required',
              failureType: ChatFailureType.currencyRequired,
            )));

        return chatCubit;
      },
      act: (cubit) => cubit.sendNewMessage(
        botId: testBotId,
        content: 'Hello',
      ),
      expect: () => [
        isA<ChatLoaded>().having((s) => s.isSending, 'isSending', true),
        isA<ChatError>().having(
            (s) => s.errorType, 'errorType', ChatErrorType.currencyRequired),
      ],
    );
  });
}
