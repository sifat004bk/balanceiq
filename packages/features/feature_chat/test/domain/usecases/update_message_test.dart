import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:feature_chat/domain/usecases/update_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late UpdateMessage updateMessage;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    updateMessage = UpdateMessage(mockChatRepository);
  });

  setUpAll(() {
    registerFallbackValue(Message(
      id: 'fallback',
      userId: 'user',
      botId: 'bot',
      sender: 'user',
      content: 'fallback',
      timestamp: DateTime.now(),
      isSending: false,
      hasError: false,
    ));
  });

  group('UpdateMessage', () {
    final testMessage = Message(
      id: 'msg_123',
      userId: 'user_1',
      botId: 'balance_tracker',
      sender: 'user',
      content: 'Updated message content',
      timestamp: DateTime.now(),
      isSending: false,
      hasError: false,
    );

    test('should return void when saving message succeeds', () async {
      // Arrange
      when(() => mockChatRepository.saveMessage(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await updateMessage(testMessage);

      // Assert
      expect(result, const Right(null));
      verify(() => mockChatRepository.saveMessage(testMessage)).called(1);
    });

    test('should save message with isSending true', () async {
      // Arrange
      final sendingMessage = Message(
        id: 'msg_124',
        userId: 'user_1',
        botId: 'balance_tracker',
        sender: 'user',
        content: 'Sending message',
        timestamp: DateTime.now(),
        isSending: true,
        hasError: false,
      );

      when(() => mockChatRepository.saveMessage(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await updateMessage(sendingMessage);

      // Assert
      expect(result, const Right(null));
      verify(() => mockChatRepository.saveMessage(sendingMessage)).called(1);
    });

    test('should save message with hasError true', () async {
      // Arrange
      final errorMessage = Message(
        id: 'msg_125',
        userId: 'user_1',
        botId: 'balance_tracker',
        sender: 'user',
        content: 'Failed message',
        timestamp: DateTime.now(),
        isSending: false,
        hasError: true,
      );

      when(() => mockChatRepository.saveMessage(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await updateMessage(errorMessage);

      // Assert
      expect(result, const Right(null));
    });

    test('should return CacheFailure when saving fails', () async {
      // Arrange
      when(() => mockChatRepository.saveMessage(any())).thenAnswer(
          (_) async => const Left(CacheFailure('Failed to save message')));

      // Act
      final result = await updateMessage(testMessage);

      // Assert
      expect(result, const Left(CacheFailure('Failed to save message')));
    });

    test('should return CacheFailure when database is full', () async {
      // Arrange
      when(() => mockChatRepository.saveMessage(any())).thenAnswer(
          (_) async => const Left(CacheFailure('Database storage full')));

      // Act
      final result = await updateMessage(testMessage);

      // Assert
      expect(result, const Left(CacheFailure('Database storage full')));
    });

    test('should return ServerFailure when sync fails', () async {
      // Arrange
      when(() => mockChatRepository.saveMessage(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Failed to sync message')));

      // Act
      final result = await updateMessage(testMessage);

      // Assert
      expect(result, const Left(ServerFailure('Failed to sync message')));
    });
  });
}
