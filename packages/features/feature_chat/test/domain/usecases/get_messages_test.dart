import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:feature_chat/domain/usecases/get_messages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late GetMessages getMessages;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    getMessages = GetMessages(mockChatRepository);
  });

  group('GetMessages', () {
    const testUserId = 'user_123';
    const testBotId = 'balance_tracker';
    const testLimit = 20;

    final testMessages = [
      Message(
        id: 'msg_1',
        userId: testUserId,
        botId: testBotId,
        sender: 'user',
        content: 'Hello',
        timestamp: DateTime.now(),
        isSending: false,
        hasError: false,
      ),
      Message(
        id: 'msg_2',
        userId: testUserId,
        botId: testBotId,
        sender: 'bot',
        content: 'Hi there!',
        timestamp: DateTime.now(),
        isSending: false,
        hasError: false,
      ),
    ];

    test('should return list of messages when successful', () async {
      // Arrange
      when(() => mockChatRepository.getMessages(any(), any(), limit: any(named: 'limit')))
          .thenAnswer((_) async => Right(testMessages));

      // Act
      final result = await getMessages(testUserId, testBotId, limit: testLimit);

      // Assert
      expect(result, Right(testMessages));
      verify(() => mockChatRepository.getMessages(testUserId, testBotId, limit: testLimit))
          .called(1);
    });

    test('should return empty list when no messages', () async {
      // Arrange
      when(() => mockChatRepository.getMessages(any(), any(), limit: any(named: 'limit')))
          .thenAnswer((_) async => const Right(<Message>[]));

      // Act
      final result = await getMessages(testUserId, testBotId, limit: testLimit);

      // Assert
      expect(result, const Right(<Message>[]));
    });

    test('should return CacheFailure when local storage fails', () async {
      // Arrange
      when(() => mockChatRepository.getMessages(any(), any(), limit: any(named: 'limit')))
          .thenAnswer((_) async => const Left(CacheFailure('Failed to read messages')));

      // Act
      final result = await getMessages(testUserId, testBotId, limit: testLimit);

      // Assert
      expect(result, const Left(CacheFailure('Failed to read messages')));
    });
  });
}
