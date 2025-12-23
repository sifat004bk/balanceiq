import 'package:feature_chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Entity', () {
    final testMessage = Message(
      id: 'msg_123',
      userId: 'user_1',
      botId: 'finance_guru',
      sender: 'bot',
      content: 'Your balance is 45,000 BDT',
      timestamp: DateTime(2024, 1, 15, 10, 30),
      isSending: false,
      hasError: false,
    );

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final message1 = Message(
          id: 'msg_1',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Hello',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        final message2 = Message(
          id: 'msg_1',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Hello',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        expect(message1, equals(message2));
        expect(message1.hashCode, equals(message2.hashCode));
      });

      test('should not be equal when id differs', () {
        final message1 = Message(
          id: 'msg_1',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Hello',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        final message2 = Message(
          id: 'msg_2',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Hello',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        expect(message1, isNot(equals(message2)));
      });

      test('should not be equal when content differs', () {
        final message1 = Message(
          id: 'msg_1',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Hello',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        final message2 = Message(
          id: 'msg_1',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Hi there',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        expect(message1, isNot(equals(message2)));
      });
    });

    group('Properties', () {
      test('should have correct properties', () {
        expect(testMessage.id, 'msg_123');
        expect(testMessage.userId, 'user_1');
        expect(testMessage.botId, 'finance_guru');
        expect(testMessage.sender, 'bot');
        expect(testMessage.content, 'Your balance is 45,000 BDT');
        expect(testMessage.isSending, false);
        expect(testMessage.hasError, false);
      });

      test('should handle optional fields', () {
        final messageWithImage = Message(
          id: 'msg_2',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Check this out',
          imageUrl: 'https://example.com/image.jpg',
          timestamp: DateTime(2024, 1, 1),
          isSending: false,
          hasError: false,
        );

        expect(messageWithImage.imageUrl, 'https://example.com/image.jpg');
        expect(messageWithImage.audioUrl, null);
      });

      test('should handle isSending state', () {
        final sendingMessage = Message(
          id: 'msg_temp',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Sending...',
          timestamp: DateTime.now(),
          isSending: true,
          hasError: false,
        );

        expect(sendingMessage.isSending, true);
        expect(sendingMessage.hasError, false);
      });

      test('should handle error state', () {
        final errorMessage = Message(
          id: 'msg_error',
          userId: 'user_1',
          botId: 'bot_1',
          sender: 'user',
          content: 'Failed message',
          timestamp: DateTime.now(),
          isSending: false,
          hasError: true,
        );

        expect(errorMessage.isSending, false);
        expect(errorMessage.hasError, true);
      });
    });
  });
}
