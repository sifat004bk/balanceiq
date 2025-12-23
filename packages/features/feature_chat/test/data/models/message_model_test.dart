import 'package:feature_chat/data/models/message_model.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageModel', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);

    final testMessageModel = MessageModel(
      id: 'msg_123',
      userId: 'user_1',
      botId: 'balance_tracker',
      sender: 'user',
      content: 'What is my balance?',
      timestamp: testDateTime,
      isSending: false,
      hasError: false,
    );

    group('fromJson', () {
      test('should create MessageModel from valid JSON', () {
        // Arrange
        final json = {
          'id': 'msg_123',
          'user_id': 'user_1',
          'bot_id': 'balance_tracker',
          'sender': 'user',
          'content': 'What is my balance?',
          'timestamp': '2024-01-15T10:30:00.000',
          'is_sending': 0,
          'has_error': 0,
          'is_synced': 0,
          'sync_status': 'pending',
        };

        // Act
        final result = MessageModel.fromJson(json);

        // Assert
        expect(result.id, 'msg_123');
        expect(result.userId, 'user_1');
        expect(result.botId, 'balance_tracker');
        expect(result.sender, 'user');
        expect(result.content, 'What is my balance?');
        expect(result.isSending, false);
        expect(result.hasError, false);
      });

      test('should parse is_sending as 1 to true', () {
        // Arrange
        final json = {
          'id': 'msg_124',
          'user_id': 'user_1',
          'bot_id': 'balance_tracker',
          'sender': 'user',
          'content': 'Sending message',
          'timestamp': '2024-01-15T10:30:00.000',
          'is_sending': 1,
          'has_error': 0,
        };

        // Act
        final result = MessageModel.fromJson(json);

        // Assert
        expect(result.isSending, true);
      });

      test('should parse has_error as 1 to true', () {
        // Arrange
        final json = {
          'id': 'msg_125',
          'user_id': 'user_1',
          'bot_id': 'balance_tracker',
          'sender': 'user',
          'content': 'Failed message',
          'timestamp': '2024-01-15T10:30:00.000',
          'is_sending': 0,
          'has_error': 1,
        };

        // Act
        final result = MessageModel.fromJson(json);

        // Assert
        expect(result.hasError, true);
      });

      test('should handle optional fields', () {
        // Arrange
        final json = {
          'id': 'msg_126',
          'user_id': 'user_1',
          'bot_id': 'balance_tracker',
          'sender': 'bot',
          'content': 'Your balance is 45,500 BDT',
          'image_url': 'https://example.com/image.jpg',
          'audio_url': 'https://example.com/audio.m4a',
          'timestamp': '2024-01-15T10:30:00.000',
          'is_sending': 0,
          'has_error': 0,
          'api_message_id': 'api_msg_123',
          'action_type': 'BALANCE_CHECK',
          'conversation_id': 456,
          'feedback': 'LIKE',
        };

        // Act
        final result = MessageModel.fromJson(json);

        // Assert
        expect(result.imageUrl, 'https://example.com/image.jpg');
        expect(result.audioUrl, 'https://example.com/audio.m4a');
        expect(result.apiMessageId, 'api_msg_123');
        expect(result.actionType, 'BALANCE_CHECK');
        expect(result.conversationId, 456);
        expect(result.feedback, 'LIKE');
      });

      test('should handle server_created_at', () {
        // Arrange
        final json = {
          'id': 'msg_127',
          'user_id': 'user_1',
          'bot_id': 'balance_tracker',
          'sender': 'user',
          'content': 'Test message',
          'timestamp': '2024-01-15T10:30:00.000',
          'server_created_at': '2024-01-15T10:30:05.000',
          'is_sending': 0,
          'has_error': 0,
        };

        // Act
        final result = MessageModel.fromJson(json);

        // Assert
        expect(result.serverCreatedAt, isNotNull);
      });
    });

    group('toJson', () {
      test('should convert MessageModel to valid JSON', () {
        // Act
        final result = testMessageModel.toJson();

        // Assert
        expect(result['id'], 'msg_123');
        expect(result['user_id'], 'user_1');
        expect(result['bot_id'], 'balance_tracker');
        expect(result['sender'], 'user');
        expect(result['content'], 'What is my balance?');
        expect(result['is_sending'], 0);
        expect(result['has_error'], 0);
      });

      test('should convert boolean fields to integers', () {
        // Arrange
        final sendingMessage = MessageModel(
          id: 'msg_128',
          userId: 'user_1',
          botId: 'balance_tracker',
          sender: 'user',
          content: 'Sending message',
          timestamp: testDateTime,
          isSending: true,
          hasError: true,
        );

        // Act
        final result = sendingMessage.toJson();

        // Assert
        expect(result['is_sending'], 1);
        expect(result['has_error'], 1);
      });

      test('should include null for optional fields when not set', () {
        // Act
        final result = testMessageModel.toJson();

        // Assert
        expect(result['image_url'], isNull);
        expect(result['audio_url'], isNull);
        expect(result['api_message_id'], isNull);
      });
    });

    group('fromEntity', () {
      test('should create MessageModel from Message entity', () {
        // Arrange
        final message = Message(
          id: 'msg_129',
          userId: 'user_2',
          botId: 'expense_tracker',
          sender: 'bot',
          content: 'Your expenses this month are 15,000 BDT',
          timestamp: testDateTime,
          isSending: false,
          hasError: false,
        );

        // Act
        final result = MessageModel.fromEntity(message);

        // Assert
        expect(result.id, message.id);
        expect(result.userId, message.userId);
        expect(result.botId, message.botId);
        expect(result.sender, message.sender);
        expect(result.content, message.content);
        expect(result.timestamp, message.timestamp);
      });
    });

    group('toEntity', () {
      test('should convert MessageModel to Message entity', () {
        // Act
        final result = testMessageModel.toEntity();

        // Assert
        expect(result, isA<Message>());
        expect(result.id, testMessageModel.id);
        expect(result.userId, testMessageModel.userId);
        expect(result.botId, testMessageModel.botId);
        expect(result.sender, testMessageModel.sender);
        expect(result.content, testMessageModel.content);
      });
    });

    group('roundtrip', () {
      test('should preserve data through toJson and fromJson', () {
        // Arrange
        final original = MessageModel(
          id: 'msg_130',
          userId: 'user_1',
          botId: 'balance_tracker',
          sender: 'user',
          content: 'Test roundtrip',
          timestamp: testDateTime,
          isSending: true,
          hasError: false,
          isSynced: true,
          syncStatus: 'synced',
          actionType: 'TEST',
        );

        // Act
        final json = original.toJson();
        final restored = MessageModel.fromJson(json);

        // Assert
        expect(restored.id, original.id);
        expect(restored.userId, original.userId);
        expect(restored.botId, original.botId);
        expect(restored.sender, original.sender);
        expect(restored.content, original.content);
        expect(restored.isSending, original.isSending);
        expect(restored.hasError, original.hasError);
        expect(restored.isSynced, original.isSynced);
        expect(restored.syncStatus, original.syncStatus);
        expect(restored.actionType, original.actionType);
      });
    });
  });
}
