import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/domain/entities/chat_history_response.dart';
import 'package:feature_chat/domain/usecases/get_chat_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late GetChatHistory getChatHistory;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    getChatHistory = GetChatHistory(mockChatRepository);
  });

  group('GetChatHistory', () {
    const testUserId = 'user_123';
    const testPage = 1;
    const testLimit = 20;
    const testBotId = 'balance_tracker';

    const testConversation = Conversation(
      id: 1,
      userMessage: 'What is my balance?',
      aiResponse: 'Your current balance is 45,500 BDT',
      createdAt: '2024-01-15T10:30:00Z',
      feedback: 'LIKE',
      actionType: 'BALANCE_CHECK',
    );

    const testPagination = Pagination(
      currentPage: 1,
      limit: 20,
      returned: 1,
      hasNext: false,
      nextPage: null,
    );

    const testChatHistoryResponse = ChatHistoryResponse(
      userId: 123,
      conversations: [testConversation],
      pagination: testPagination,
    );

    test('should return ChatHistoryResponse when successful', () async {
      // Arrange
      when(() => mockChatRepository.getChatHistory(
            userId: any(named: 'userId'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            botId: any(named: 'botId'),
          )).thenAnswer((_) async => const Right(testChatHistoryResponse));

      // Act
      final result = await getChatHistory(
        userId: testUserId,
        page: testPage,
        limit: testLimit,
        botId: testBotId,
      );

      // Assert
      expect(result, const Right(testChatHistoryResponse));
      verify(() => mockChatRepository.getChatHistory(
            userId: testUserId,
            page: testPage,
            limit: testLimit,
            botId: testBotId,
          )).called(1);
    });

    test('should return ChatHistoryResponse without optional params', () async {
      // Arrange
      when(() => mockChatRepository.getChatHistory(
            userId: any(named: 'userId'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            botId: any(named: 'botId'),
          )).thenAnswer((_) async => const Right(testChatHistoryResponse));

      // Act
      final result = await getChatHistory(
        userId: testUserId,
        page: testPage,
      );

      // Assert
      expect(result, const Right(testChatHistoryResponse));
      verify(() => mockChatRepository.getChatHistory(
            userId: testUserId,
            page: testPage,
            limit: null,
            botId: null,
          )).called(1);
    });

    test('should return empty conversations when no history', () async {
      // Arrange
      const emptyResponse = ChatHistoryResponse(
        userId: 123,
        conversations: [],
        pagination: Pagination(
          currentPage: 1,
          limit: 20,
          returned: 0,
          hasNext: false,
          nextPage: null,
        ),
      );

      when(() => mockChatRepository.getChatHistory(
            userId: any(named: 'userId'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            botId: any(named: 'botId'),
          )).thenAnswer((_) async => const Right(emptyResponse));

      // Act
      final result = await getChatHistory(
        userId: testUserId,
        page: testPage,
      );

      // Assert
      expect(result, const Right(emptyResponse));
    });

    test('should return AuthFailure when not authenticated', () async {
      // Arrange
      when(() => mockChatRepository.getChatHistory(
            userId: any(named: 'userId'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            botId: any(named: 'botId'),
          )).thenAnswer((_) async => const Left(AuthFailure('Unauthorized')));

      // Act
      final result = await getChatHistory(
        userId: testUserId,
        page: testPage,
      );

      // Assert
      expect(result, const Left(AuthFailure('Unauthorized')));
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(() => mockChatRepository.getChatHistory(
            userId: any(named: 'userId'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            botId: any(named: 'botId'),
          )).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await getChatHistory(
        userId: testUserId,
        page: testPage,
      );

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockChatRepository.getChatHistory(
            userId: any(named: 'userId'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            botId: any(named: 'botId'),
          )).thenAnswer(
          (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await getChatHistory(
        userId: testUserId,
        page: testPage,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
