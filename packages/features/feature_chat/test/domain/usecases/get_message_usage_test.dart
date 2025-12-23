import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/domain/entities/message_usage.dart';
import 'package:feature_chat/domain/usecases/get_message_usage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late GetMessageUsage getMessageUsage;
  late MockMessageUsageRepository mockMessageUsageRepository;

  setUp(() {
    mockMessageUsageRepository = MockMessageUsageRepository();
    getMessageUsage = GetMessageUsage(mockMessageUsageRepository);
  });

  group('GetMessageUsage', () {
    final testMessageUsage = MessageUsage(
      messagesUsedToday: 5,
      messagesRemaining: 5,
      dailyLimit: 10,
      limitResetsAt: DateTime.now().add(const Duration(hours: 12)),
      usagePercentage: 50.0,
      lastMessageAt: DateTime.now(),
      recentMessages: const [],
    );

    test('should return MessageUsage when successful', () async {
      // Arrange
      when(() => mockMessageUsageRepository.getMessageUsage())
          .thenAnswer((_) async => Right(testMessageUsage));

      // Act
      final result = await getMessageUsage();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockMessageUsageRepository.getMessageUsage()).called(1);
    });

    test('should return MessageUsage with limit reached', () async {
      // Arrange
      final limitReachedUsage = MessageUsage(
        messagesUsedToday: 10,
        messagesRemaining: 0,
        dailyLimit: 10,
        limitResetsAt: DateTime.now().add(const Duration(hours: 12)),
        usagePercentage: 100.0,
        lastMessageAt: DateTime.now(),
        recentMessages: const [],
      );

      when(() => mockMessageUsageRepository.getMessageUsage())
          .thenAnswer((_) async => Right(limitReachedUsage));

      // Act
      final result = await getMessageUsage();

      // Assert
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (usage) {
          expect(usage.isLimitReached, true);
          expect(usage.messagesRemaining, 0);
        },
      );
    });

    test('should return MessageUsage with recent messages', () async {
      // Arrange
      final usageWithRecent = MessageUsage(
        messagesUsedToday: 3,
        messagesRemaining: 7,
        dailyLimit: 10,
        limitResetsAt: DateTime.now().add(const Duration(hours: 12)),
        usagePercentage: 30.0,
        lastMessageAt: DateTime.now(),
        recentMessages: [
          RecentMessageItem(
            timestamp: DateTime.now(),
            actionType: 'BALANCE_CHECK',
          ),
          RecentMessageItem(
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            actionType: 'TRANSACTION_QUERY',
          ),
        ],
      );

      when(() => mockMessageUsageRepository.getMessageUsage())
          .thenAnswer((_) async => Right(usageWithRecent));

      // Act
      final result = await getMessageUsage();

      // Assert
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (usage) {
          expect(usage.recentMessages.length, 2);
        },
      );
    });

    test('should return AuthFailure when not authenticated', () async {
      // Arrange
      when(() => mockMessageUsageRepository.getMessageUsage())
          .thenAnswer((_) async => const Left(AuthFailure('Unauthorized')));

      // Act
      final result = await getMessageUsage();

      // Assert
      expect(result, const Left(AuthFailure('Unauthorized')));
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(() => mockMessageUsageRepository.getMessageUsage())
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // Act
      final result = await getMessageUsage();

      // Assert
      expect(result, const Left(ServerFailure('Server error')));
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(() => mockMessageUsageRepository.getMessageUsage()).thenAnswer(
          (_) async => const Left(NetworkFailure('No internet connection')));

      // Act
      final result = await getMessageUsage();

      // Assert
      expect(result, const Left(NetworkFailure('No internet connection')));
    });

    test('should return near limit indicator correctly', () async {
      // Arrange
      final nearLimitUsage = MessageUsage(
        messagesUsedToday: 8,
        messagesRemaining: 2,
        dailyLimit: 10,
        limitResetsAt: DateTime.now().add(const Duration(hours: 12)),
        usagePercentage: 80.0,
        lastMessageAt: DateTime.now(),
        recentMessages: const [],
      );

      when(() => mockMessageUsageRepository.getMessageUsage())
          .thenAnswer((_) async => Right(nearLimitUsage));

      // Act
      final result = await getMessageUsage();

      // Assert
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (usage) {
          expect(usage.isNearLimit, true);
          expect(usage.isLimitReached, false);
        },
      );
    });
  });
}
