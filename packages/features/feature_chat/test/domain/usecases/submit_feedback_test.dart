import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/domain/entities/chat_feedback.dart';
import 'package:feature_chat/domain/usecases/submit_feedback.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late SubmitFeedback submitFeedback;
  late MockChatFeedbackRepository mockChatFeedbackRepository;

  setUpAll(() {
    registerFallbackValue(FeedbackType.like);
  });

  setUp(() {
    mockChatFeedbackRepository = MockChatFeedbackRepository();
    submitFeedback = SubmitFeedback(mockChatFeedbackRepository);
  });

  group('SubmitFeedback', () {
    const testMessageId = 123;

    const testFeedbackLike = ChatFeedback(
      messageId: testMessageId,
      feedback: FeedbackType.like,
      success: true,
      message: 'Feedback submitted successfully',
    );

    const testFeedbackDislike = ChatFeedback(
      messageId: testMessageId,
      feedback: FeedbackType.dislike,
      success: true,
      message: 'Feedback submitted successfully',
    );

    test('should return ChatFeedback when submitting like succeeds', () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
            messageId: any(named: 'messageId'),
            feedback: any(named: 'feedback'),
          )).thenAnswer((_) async => const Right(testFeedbackLike));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.like,
      );

      // Assert
      expect(result, const Right(testFeedbackLike));
      verify(() => mockChatFeedbackRepository.submitFeedback(
            messageId: testMessageId,
            feedback: FeedbackType.like,
          )).called(1);
    });

    test('should return ChatFeedback when submitting dislike succeeds',
        () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
            messageId: any(named: 'messageId'),
            feedback: any(named: 'feedback'),
          )).thenAnswer((_) async => const Right(testFeedbackDislike));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.dislike,
      );

      // Assert
      expect(result, const Right(testFeedbackDislike));
    });

    test('should return ChatFeedback when submitting none (reset) succeeds',
        () async {
      // Arrange
      const testFeedbackNone = ChatFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.none,
        success: true,
        message: 'Feedback reset successfully',
      );

      when(() => mockChatFeedbackRepository.submitFeedback(
            messageId: any(named: 'messageId'),
            feedback: any(named: 'feedback'),
          )).thenAnswer((_) async => const Right(testFeedbackNone));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.none,
      );

      // Assert
      expect(result, const Right(testFeedbackNone));
    });

    test('should return AuthFailure when not authenticated', () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
            messageId: any(named: 'messageId'),
            feedback: any(named: 'feedback'),
          )).thenAnswer((_) async => const Left(AuthFailure('Unauthorized')));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.like,
      );

      // Assert
      expect(result, const Left(AuthFailure('Unauthorized')));
    });

    test('should return PermissionFailure when user does not own message',
        () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
                messageId: any(named: 'messageId'),
                feedback: any(named: 'feedback'),
              ))
          .thenAnswer((_) async => const Left(PermissionFailure(
              'You do not have permission for this message')));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.like,
      );

      // Assert
      expect(
          result,
          const Left(PermissionFailure(
              'You do not have permission for this message')));
    });

    test('should return NotFoundFailure when message not found', () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
                messageId: any(named: 'messageId'),
                feedback: any(named: 'feedback'),
              ))
          .thenAnswer(
              (_) async => const Left(NotFoundFailure('Message not found')));

      // Act
      final result = await submitFeedback(
        messageId: 99999,
        feedback: FeedbackType.like,
      );

      // Assert
      expect(result, const Left(NotFoundFailure('Message not found')));
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
            messageId: any(named: 'messageId'),
            feedback: any(named: 'feedback'),
          )).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.like,
      );

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockChatFeedbackRepository.submitFeedback(
                messageId: any(named: 'messageId'),
                feedback: any(named: 'feedback'),
              ))
          .thenAnswer((_) async =>
              const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await submitFeedback(
        messageId: testMessageId,
        feedback: FeedbackType.like,
      );

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });
  });
}
