import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/data/models/message_model.dart';
import 'package:feature_chat/data/datasources/chat_finance_guru_datasource.dart';
import 'package:feature_chat/data/repositories/chat_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart'; // Standard Flutter Test
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../mocks/mock_datasources.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockUuid extends Mock implements Uuid {}

// Fallback values for mocktail's any() matcher
class FakeMessageModel extends Fake implements MessageModel {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;
  late MockChatLocalDataSource mockLocalDataSource;
  late MockSharedPreferences mockSharedPreferences;
  late MockUuid mockUuid;

  setUpAll(() {
    registerFallbackValue(FakeMessageModel());
  });

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    mockLocalDataSource = MockChatLocalDataSource();
    mockSharedPreferences = MockSharedPreferences();
    mockUuid = MockUuid();

    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      sharedPreferences: mockSharedPreferences,
      uuid: mockUuid,
    );
  });

  group('sendMessage', () {
    const tUserId = 'user1';
    const tBotId = 'finance_guru';
    const tContent = 'Hello';
    const tMessageId = 'msg1';

    // final tUserMessage = MessageModel(
    //   id: tMessageId,
    //   userId: tUserId,
    //   botId: tBotId,
    //   sender: AppConstants.senderUser,
    //   content: tContent,
    //   timestamp: DateTime(2023, 1, 1),
    // );

    final tBotMessage = MessageModel(
      id: 'msg2',
      userId: tUserId,
      botId: tBotId,
      sender: AppConstants.senderBot,
      content: 'Hi there',
      timestamp: DateTime(2023, 1, 1),
    );

    test('should send message successfully', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AppConstants.keyUserId))
          .thenReturn(tUserId);
      when(() => mockUuid.v4()).thenReturn(tMessageId);

      // Stub saveMessage for user message
      when(() => mockLocalDataSource.saveMessage(any()))
          .thenAnswer((_) => Future.value());

      // Stub remote sendMessage with all parameters (including optional ones)
      when(() => mockRemoteDataSource.sendMessage(
            botId: any(named: 'botId'),
            content: any(named: 'content'),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenAnswer((_) async => tBotMessage);

      // The repository saves user message, calls remote, then saves bot message.
      // We already stubbed saveMessage (it will be called twice)

      // Act
      final result = await repository.sendMessage(
        botId: tBotId,
        content: tContent,
      );

      // Assert
      expect(result, Right(tBotMessage));
      verify(() => mockSharedPreferences.getString(AppConstants.keyUserId));
      verify(() => mockLocalDataSource.saveMessage(any())).called(2);
      verify(() => mockRemoteDataSource.sendMessage(
            botId: tBotId,
            content: tContent,
            imagePath: null,
            audioPath: null,
          )).called(1);
    });

    test('should return ChatApiFailure when remote throws ChatApiException',
        () async {
      // Arrange
      when(() => mockSharedPreferences.getString(AppConstants.keyUserId))
          .thenReturn(tUserId);
      when(() => mockUuid.v4()).thenReturn(tMessageId);
      when(() => mockLocalDataSource.saveMessage(any()))
          .thenAnswer((_) => Future.value());

      when(() => mockRemoteDataSource.sendMessage(
            botId: any(named: 'botId'),
            content: any(named: 'content'),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenThrow(ChatApiException(
        message: 'Limit exceeded',
        errorType: ChatApiErrorType.tokenLimitExceeded,
      ));

      // Act
      final result = await repository.sendMessage(
        botId: tBotId,
        content: tContent,
      );

      // Assert
      expect(
          result,
          const Left(ChatApiFailure('Limit exceeded',
              failureType: ChatFailureType.tokenLimitExceeded)));
    });
  });

  group('getMessages', () {
    const tUserId = 'user1';
    const tBotId = 'bot1';

    test('should return list of messages from local source', () async {
      // Arrange
      final tMessageModels = [
        MessageModel(
          id: '1',
          userId: tUserId,
          botId: tBotId,
          sender: 'user',
          content: 'Hi',
          timestamp: DateTime(2023, 1, 1),
        )
      ];
      final tMessages = tMessageModels.map((e) => e.toEntity()).toList();

      when(() => mockLocalDataSource.getMessages(tUserId, tBotId, limit: null))
          .thenAnswer((_) async => tMessageModels);

      // Act
      final result = await repository.getMessages(tUserId, tBotId);

      // Assert
      // We need to compare entities, but Equatable should handle it if Message extends Equatable

      result.fold((l) => fail('Should returns Right'), (r) {
        expect(r.length, tMessages.length);
        expect(r.first.id, tMessages.first.id);
      });

      verify(() =>
              mockLocalDataSource.getMessages(tUserId, tBotId, limit: null))
          .called(1);
    });

    test('should return CacheFailure on exception', () async {
      // Arrange
      when(() => mockLocalDataSource.getMessages(tUserId, tBotId, limit: null))
          .thenThrow(Exception('Cache error'));

      // Act
      final result = await repository.getMessages(tUserId, tBotId);

      // Assert
      expect(
          result,
          const Left(
              CacheFailure('Failed to load messages: Exception: Cache error')));
    });
  });
}
