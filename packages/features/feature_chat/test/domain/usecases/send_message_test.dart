import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:feature_chat/domain/usecases/send_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late SendMessage sendMessage;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    sendMessage = SendMessage(mockChatRepository);
  });

  group('SendMessage', () {
    const testBotId = 'balance_tracker';
    const testContent = 'Hello, what is my balance?';

    final testMessage = Message(
      id: 'msg_123',
      userId: 'user_1',
      botId: testBotId,
      sender: 'bot',
      content: 'Your current balance is 45,500 BDT',
      timestamp: DateTime.now(),
      isSending: false,
      hasError: false,
    );

    test('should return Message when sending message succeeds', () async {
      // Arrange
      when(() => mockChatRepository.sendMessage(
            any(),
            any(),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenAnswer((_) async => Right(testMessage));

      // Act
      final result = await sendMessage(
        botId: testBotId,
        content: testContent,
      );

      // Assert
      expect(result, Right(testMessage));
      verify(() => mockChatRepository.sendMessage(
            testBotId,
            testContent,
            imagePath: null,
            audioPath: null,
          )).called(1);
    });

    test('should pass imagePath and audioPath when provided', () async {
      // Arrange
      const testImagePath = '/path/to/image.jpg';
      const testAudioPath = '/path/to/audio.m4a';

      when(() => mockChatRepository.sendMessage(
            any(),
            any(),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenAnswer((_) async => Right(testMessage));

      // Act
      await sendMessage(
        botId: testBotId,
        content: testContent,
        imagePath: testImagePath,
        audioPath: testAudioPath,
      );

      // Assert
      verify(() => mockChatRepository.sendMessage(
            testBotId,
            testContent,
            imagePath: testImagePath,
            audioPath: testAudioPath,
          )).called(1);
    });

    test('should return ChatApiFailure when rate limit exceeded', () async {
      // Arrange
      when(() => mockChatRepository.sendMessage(
            any(),
            any(),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenAnswer((_) async => const Left(
            ChatApiFailure(
              'Rate limit exceeded',
              failureType: ChatFailureType.rateLimitExceeded,
            ),
          ));

      // Act
      final result = await sendMessage(
        botId: testBotId,
        content: testContent,
      );

      // Assert
      expect(
        result,
        const Left(ChatApiFailure(
          'Rate limit exceeded',
          failureType: ChatFailureType.rateLimitExceeded,
        )),
      );
    });

    test('should return ChatApiFailure when subscription required', () async {
      // Arrange
      when(() => mockChatRepository.sendMessage(
            any(),
            any(),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenAnswer((_) async => const Left(
            ChatApiFailure(
              'Subscription required',
              failureType: ChatFailureType.subscriptionRequired,
            ),
          ));

      // Act
      final result = await sendMessage(
        botId: testBotId,
        content: testContent,
      );

      // Assert
      expect(
        result,
        const Left(ChatApiFailure(
          'Subscription required',
          failureType: ChatFailureType.subscriptionRequired,
        )),
      );
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockChatRepository.sendMessage(
            any(),
            any(),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenAnswer(
              (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await sendMessage(
        botId: testBotId,
        content: testContent,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
