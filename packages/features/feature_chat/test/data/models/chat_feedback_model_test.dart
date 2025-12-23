import 'package:feature_chat/data/models/chat_feedback_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedbackType', () {
    group('value', () {
      test('like should have value LIKE', () {
        expect(FeedbackType.like.value, 'LIKE');
      });

      test('dislike should have value DISLIKE', () {
        expect(FeedbackType.dislike.value, 'DISLIKE');
      });

      test('none should have value NONE', () {
        expect(FeedbackType.none.value, 'NONE');
      });
    });

    group('fromString', () {
      test('should return like for LIKE', () {
        expect(FeedbackType.fromString('LIKE'), FeedbackType.like);
      });

      test('should return dislike for DISLIKE', () {
        expect(FeedbackType.fromString('DISLIKE'), FeedbackType.dislike);
      });

      test('should return none for NONE', () {
        expect(FeedbackType.fromString('NONE'), FeedbackType.none);
      });

      test('should be case insensitive', () {
        expect(FeedbackType.fromString('like'), FeedbackType.like);
        expect(FeedbackType.fromString('Like'), FeedbackType.like);
        expect(FeedbackType.fromString('LIKE'), FeedbackType.like);
      });

      test('should throw for invalid value', () {
        expect(
          () => FeedbackType.fromString('INVALID'),
          throwsArgumentError,
        );
      });
    });
  });

  group('ChatFeedbackRequest', () {
    test('should correctly create request with like', () {
      // Arrange
      const request = ChatFeedbackRequest(feedback: FeedbackType.like);

      // Assert
      expect(request.feedback, FeedbackType.like);
    });

    test('toJson should return correct map for like', () {
      // Arrange
      const request = ChatFeedbackRequest(feedback: FeedbackType.like);

      // Act
      final result = request.toJson();

      // Assert
      expect(result['feedback'], 'LIKE');
    });

    test('toJson should return correct map for dislike', () {
      // Arrange
      const request = ChatFeedbackRequest(feedback: FeedbackType.dislike);

      // Act
      final result = request.toJson();

      // Assert
      expect(result['feedback'], 'DISLIKE');
    });

    test('toJson should return correct map for none', () {
      // Arrange
      const request = ChatFeedbackRequest(feedback: FeedbackType.none);

      // Act
      final result = request.toJson();

      // Assert
      expect(result['feedback'], 'NONE');
    });

    test('toString should return readable format', () {
      // Arrange
      const request = ChatFeedbackRequest(feedback: FeedbackType.like);

      // Act
      final result = request.toString();

      // Assert
      expect(result, 'ChatFeedbackRequest(feedback: LIKE)');
    });
  });

  group('ChatFeedbackResponse', () {
    test('fromJson should parse successful response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Feedback submitted successfully',
      };

      // Act
      final result = ChatFeedbackResponse.fromJson(json);

      // Assert
      expect(result.success, true);
      expect(result.message, 'Feedback submitted successfully');
    });

    test('fromJson should parse failure response', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Failed to submit feedback',
      };

      // Act
      final result = ChatFeedbackResponse.fromJson(json);

      // Assert
      expect(result.success, false);
      expect(result.message, 'Failed to submit feedback');
    });

    test('toJson should return correct map', () {
      // Arrange
      const response = ChatFeedbackResponse(
        success: true,
        message: 'Feedback submitted',
      );

      // Act
      final result = response.toJson();

      // Assert
      expect(result['success'], true);
      expect(result['message'], 'Feedback submitted');
    });

    test('toString should return readable format', () {
      // Arrange
      const response = ChatFeedbackResponse(
        success: true,
        message: 'Test message',
      );

      // Act
      final result = response.toString();

      // Assert
      expect(result, 'ChatFeedbackResponse(success: true, message: Test message)');
    });

    group('roundtrip', () {
      test('should preserve data through toJson and fromJson', () {
        // Arrange
        const original = ChatFeedbackResponse(
          success: true,
          message: 'Roundtrip test',
        );

        // Act
        final json = original.toJson();
        final restored = ChatFeedbackResponse.fromJson(json);

        // Assert
        expect(restored.success, original.success);
        expect(restored.message, original.message);
      });
    });
  });
}
