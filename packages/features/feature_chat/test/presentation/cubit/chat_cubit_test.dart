import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dolfin_core/constants/app_constants.dart';

import 'package:dolfin_core/analytics/analytics_service.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:feature_auth/domain/usecases/get_current_user.dart';
import 'package:feature_chat/domain/entities/chat_history_response.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:feature_chat/domain/entities/message_usage.dart';
import 'package:feature_chat/presentation/cubit/chat_cubit.dart';
import 'package:feature_chat/presentation/cubit/chat_state.dart';
import 'package:feature_subscription/domain/entities/subscription_status.dart';
import 'package:feature_subscription/domain/usecases/get_subscription_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

import '../../mocks.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockUuid extends Mock implements Uuid {}

class MockAppConstants extends Mock implements AppConstants {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockGetSubscriptionStatus extends Mock implements GetSubscriptionStatus {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

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
  late MockGetCurrentUser mockGetCurrentUser;
  late MockGetSubscriptionStatus mockGetSubscriptionStatus;
  late MockAnalyticsService mockAnalyticsService;

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
    mockGetCurrentUser = MockGetCurrentUser();
    mockGetSubscriptionStatus = MockGetSubscriptionStatus();
    mockAnalyticsService = MockAnalyticsService();

    // Stub generic logEvent to avoid null errors during tests
    when(() => mockAnalyticsService.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        )).thenAnswer((_) async {});

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
      getCurrentUser: mockGetCurrentUser,
      getSubscriptionStatus: mockGetSubscriptionStatus,
      analyticsService: mockAnalyticsService,
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('ChatCubit', () {
    const testBotId = 'balance_tracker';
    const testUserId = 'user123';

    // Correct User object instantiation
    final testUserVerified = User(
      id: "1",
      email: 'test@example.com',
      name: 'testuser',
      isEmailVerified: true,
      currency: 'USD',
      authProvider: 'email',
      createdAt: DateTime.now(),
    );

    final testUserUnverified = User(
      id: "1",
      email: 'test@example.com',
      name: 'testuser',
      isEmailVerified: false,
      currency: 'USD',
      authProvider: 'email',
      createdAt: DateTime.now(),
    );

    final testUserNoCurrency = User(
      id: "1",
      email: 'test@example.com',
      name: 'testuser',
      isEmailVerified: true,
      currency: null,
      authProvider: 'email',
      createdAt: DateTime.now(),
    );

    // Correct SubscriptionStatus instantiation
    final testSubscriptionActive = SubscriptionStatus(
      hasActiveSubscription: true,
      // subscription: ... // Optional
    );

    final testSubscriptionInactive = SubscriptionStatus(
      hasActiveSubscription: false,
    );

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
      'emits ChatError(emailNotVerified) if user email is not verified',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Right(testUserUnverified));
        return chatCubit;
      },
      act: (cubit) => cubit.loadChatHistory(testBotId),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatError>().having(
            (s) => s.errorType, 'errorType', ChatErrorType.emailNotVerified),
      ],
      verify: (_) {
        verifyNever(() => mockGetSubscriptionStatus());
        verifyNever(() => mockGetChatHistory(
              userId: any(named: 'userId'),
              page: any(named: 'page'),
              limit: any(named: 'limit'),
              botId: any(named: 'botId'),
            ));
      },
    );

    blocTest<ChatCubit, ChatState>(
      'emits ChatError(subscriptionRequired) if user verified but no subscription',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Right(testUserVerified));
        when(() => mockGetSubscriptionStatus())
            .thenAnswer((_) async => Right(testSubscriptionInactive));
        return chatCubit;
      },
      act: (cubit) => cubit.loadChatHistory(testBotId),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatError>().having((s) => s.errorType, 'errorType',
            ChatErrorType.subscriptionRequired),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'emits ChatError(currencyRequired) if user verified, sub active, but no currency',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Right(testUserNoCurrency));
        when(() => mockGetSubscriptionStatus())
            .thenAnswer((_) async => Right(testSubscriptionActive));
        return chatCubit;
      },
      act: (cubit) => cubit.loadChatHistory(testBotId),
      expect: () => [
        isA<ChatLoading>(),
        isA<ChatError>().having(
            (s) => s.errorType, 'errorType', ChatErrorType.currencyRequired),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'emits ChatLoaded when checks pass and loadChatHistory succeeds',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => Right(testUserVerified));
        when(() => mockGetSubscriptionStatus())
            .thenAnswer((_) async => Right(testSubscriptionActive));

        when(() => mockGetMessageUsage())
            .thenAnswer((_) async => Right(testMessageUsage));
        when(() => mockSecureStorage.getUserId())
            .thenAnswer((_) async => testUserId);
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
