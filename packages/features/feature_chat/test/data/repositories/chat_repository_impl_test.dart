import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/error/failures.dart';
import 'package:feature_chat/data/models/message_model.dart';
import 'package:feature_chat/data/datasources/chat_finance_guru_datasource.dart';
import 'package:feature_chat/data/repositories/chat_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart'; // Standard Flutter Test
import 'package:mocktail/mocktail.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:uuid/uuid.dart';

import '../../mocks.dart';

import 'package:get_it/get_it.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAppConstants extends Mock implements AppConstants {}

class MockUuid extends Mock implements Uuid {}

// Fallback values for mocktail's any() matcher
class FakeMessageModel extends Fake implements MessageModel {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;
  late MockChatLocalDataSource mockLocalDataSource;
  late MockSecureStorageService mockSecureStorageService;
  late MockUuid mockUuid;
  late MockAppConstants mockAppConstants;

  setUpAll(() {
    registerFallbackValue(FakeMessageModel());
  });

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    mockLocalDataSource = MockChatLocalDataSource();
    mockSecureStorageService = MockSecureStorageService();
    mockUuid = MockUuid();
    mockAppConstants = MockAppConstants();

    GetIt.instance.registerSingleton<AppConstants>(mockAppConstants);
    when(() => mockAppConstants.senderUser).thenReturn('user_sender');
    when(() => mockAppConstants.senderBot).thenReturn('bot_sender');
    when(() => mockAppConstants.keyUserId).thenReturn('user_id_key');

    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      secureStorage: mockSecureStorageService,
      uuid: mockUuid,
    );
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('sendMessage', () {
    const tUserId = 'user1';
    const tBotId = 'finance_guru';
    const tContent = 'Hello';
    const tMessageId = 'msg1';

    test('should send message successfully', () async {
      // Arrange
      final tBotMessage = MessageModel(
        id: 'msg2',
        userId: tUserId,
        botId: tBotId,
        sender: GetIt.instance<AppConstants>().senderBot,
        content: 'Hi there',
        timestamp: DateTime(2023, 1, 1),
      );

      when(() => mockSecureStorageService.getUserId())
          .thenAnswer((_) async => tUserId);
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

      // Act
      final result = await repository.sendMessage(
        botId: tBotId,
        content: tContent,
      );

      // Assert
      expect(result, Right(tBotMessage));
      verify(() => mockSecureStorageService.getUserId());
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
      when(() => mockSecureStorageService.getUserId())
          .thenAnswer((_) async => tUserId);
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

    test(
        'should return ChatFailureType.currencyRequired when remote throws currencyRequired error',
        () async {
      // Arrange
      when(() => mockSecureStorageService.getUserId())
          .thenAnswer((_) async => tUserId);
      when(() => mockUuid.v4()).thenReturn(tMessageId);
      when(() => mockLocalDataSource.saveMessage(any()))
          .thenAnswer((_) => Future.value());

      when(() => mockRemoteDataSource.sendMessage(
            botId: any(named: 'botId'),
            content: any(named: 'content'),
            imagePath: any(named: 'imagePath'),
            audioPath: any(named: 'audioPath'),
          )).thenThrow(ChatApiException(
        message: 'Currency required',
        errorType: ChatApiErrorType.currencyRequired,
      ));

      // Act
      final result = await repository.sendMessage(
        botId: tBotId,
        content: tContent,
      );

      // Assert
      expect(
          result,
          const Left(ChatApiFailure('Currency required',
              failureType: ChatFailureType.currencyRequired)));
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
