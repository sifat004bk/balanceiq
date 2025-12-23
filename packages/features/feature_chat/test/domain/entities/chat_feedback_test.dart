import 'package:feature_chat/domain/entities/chat_feedback.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatFeedback Entity', () {
    group('Equatable', () {
      test('should be equal when all properties match', () {
        const feedback1 = ChatFeedback(
          messageId: 123,
          feedback: FeedbackType.like,
          success: true,
          message: 'Feedback submitted',
        );

        const feedback2 = ChatFeedback(
          messageId: 123,
          feedback: FeedbackType.like,
          success: true,
          message: 'Feedback submitted',
        );

        expect(feedback1, equals(feedback2));
        expect(feedback1.hashCode, equals(feedback2.hashCode));
      });

      test('should not be equal when feedback type differs', () {
        const feedback1 = ChatFeedback(
          messageId: 123,
          feedback: FeedbackType.like,
          success: true,
          message: 'Feedback submitted',
        );

        const feedback2 = ChatFeedback(
          messageId: 123,
          feedback: FeedbackType.dislike,
          success: true,
          message: 'Feedback submitted',
        );

        expect(feedback1, isNot(equals(feedback2)));
      });

      test('should not be equal when messageId differs', () {
        const feedback1 = ChatFeedback(
          messageId: 123,
          feedback: FeedbackType.like,
          success: true,
          message: 'Feedback submitted',
        );

        const feedback2 = ChatFeedback(
          messageId: 456,
          feedback: FeedbackType.like,
          success: true,
          message: 'Feedback submitted',
        );

        expect(feedback1, isNot(equals(feedback2)));
      });
    });

    group('FeedbackType', () {
      test('should have like, dislike, and none values', () {
        expect(FeedbackType.values.length, 3);
        expect(FeedbackType.values.contains(FeedbackType.like), true);
        expect(FeedbackType.values.contains(FeedbackType.dislike), true);
        expect(FeedbackType.values.contains(FeedbackType.none), true);
      });

      test('should convert to string correctly', () {
        expect(FeedbackType.like.toString(), 'FeedbackType.like');
        expect(FeedbackType.dislike.toString(), 'FeedbackType.dislike');
        expect(FeedbackType.none.toString(), 'FeedbackType.none');
      });
    });

    group('Properties', () {
      test('should have correct properties for successful like', () {
        const feedback = ChatFeedback(
          messageId: 123,
          feedback: FeedbackType.like,
          success: true,
          message: 'Feedback submitted successfully',
        );

        expect(feedback.messageId, 123);
        expect(feedback.feedback, FeedbackType.like);
        expect(feedback.success, true);
        expect(feedback.message, 'Feedback submitted successfully');
      });

      test('should have correct properties for successful dislike', () {
        const feedback = ChatFeedback(
          messageId: 456,
          feedback: FeedbackType.dislike,
          success: true,
          message: 'Feedback recorded',
        );

        expect(feedback.messageId, 456);
        expect(feedback.feedback, FeedbackType.dislike);
        expect(feedback.success, true);
      });

      test('should handle failed feedback submission', () {
        const feedback = ChatFeedback(
          messageId: 789,
          feedback: FeedbackType.like,
          success: false,
          message: 'Failed to submit feedback',
        );

        expect(feedback.success, false);
        expect(feedback.message, 'Failed to submit feedback');
      });

      test('should handle none (reset) feedback', () {
        const feedback = ChatFeedback(
          messageId: 999,
          feedback: FeedbackType.none,
          success: true,
          message: 'Feedback reset',
        );

        expect(feedback.feedback, FeedbackType.none);
        expect(feedback.success, true);
      });
    });
  });
}
