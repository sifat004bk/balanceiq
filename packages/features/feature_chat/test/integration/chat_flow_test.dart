import 'package:dartz/dartz.dart';
import 'package:feature_chat/data/datasources/chat_local_datasource.dart';
import 'package:feature_chat/data/datasources/chat_remote_datasource.dart';
import 'package:feature_chat/data/models/message_model.dart';
import 'package:feature_chat/data/repositories/chat_repository_impl.dart';
import 'package:feature_chat/domain/entities/message.dart';
import 'package:feature_chat/domain/usecases/send_message.dart';
import 'package:feature_chat/domain/usecases/get_messages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';

import '../mocks.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockAppConstants extends Mock implements AppConstants {}

class MockUuid extends Mock implements Uuid {}

class FakeMessageModel extends Fake implements MessageModel {}

/// Integration tests for chat feature
/// Tests the complete flow from datasource → repository → use case
void main() {
  late ChatLocalDataSource localDataSource;
  late ChatRemoteDataSource remoteDataSource;
  late SecureStorageService secureStorage;
  late Uuid uuid;
  late ChatRepositoryImpl repository;
  late SendMessage sendMessageUseCase;
  late GetMessages getMessagesUseCase;
  late AppConstants appConstants;

  setUpAll(() {
    registerFallbackValue(FakeMessageModel());
  });

  setUp(() {
    localDataSource = MockChatLocalDataSource();
    remoteDataSource = MockChatRemoteDataSource();
    secureStorage = MockSecureStorageService();
    uuid = MockUuid();
    appConstants = MockAppConstants();

    GetIt.instance.registerSingleton<AppConstants>(appConstants);
    when(() => appConstants.senderUser).thenReturn('user');
    when(() => appConstants.senderBot).thenReturn('bot');

    repository = ChatRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
      secureStorage: secureStorage,
      uuid: uuid,
    );

    sendMessageUseCase = SendMessage(repository);
    getMessagesUseCase = GetMessages(repository);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('Chat Feature Integration Tests', () {
    const testUserId = 'user_123';
    const testBotId = 'finance_guru';
    const testContent = 'What is my balance?';
    const testMessageId = 'msg_123';
    const testBotResponseId = 'msg_456';

    final testBotResponse = MessageModel(
      id: testBotResponseId,
      userId: testUserId,
      botId: testBotId,
      sender: 'bot',
      content: 'Your current balance is 45,000 BDT',
      timestamp: DateTime(2024, 1, 15, 10, 30),
      isSending: false,
      hasError: false,
    );

    group('Complete Chat Flow: Send Message → Get Messages', () {
      test('should complete full chat flow successfully', () async {
        // Step 1: User sends a message
        when(() => secureStorage.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => uuid.v4()).thenReturn(testMessageId);
        when(() => localDataSource.saveMessage(any()))
            .thenAnswer((_) async => {});
        when(() => remoteDataSource.sendMessage(
              botId: any(named: 'botId'),
              content: any(named: 'content'),
              imagePath: any(named: 'imagePath'),
              audioPath: any(named: 'audioPath'),
            )).thenAnswer((_) async => testBotResponse);

        final sendResult = await sendMessageUseCase(
          botId: testBotId,
          content: testContent,
        );

        expect(sendResult.isRight(), true);
        sendResult.fold(
          (failure) => fail('Should not fail'),
          (message) {
            expect(message.id, testBotResponseId);
            expect(message.sender, 'bot');
            expect(message.content, contains('balance'));
          },
        );

        // Verify datasource interactions
        verify(() => secureStorage.getUserId()).called(1);
        verify(() => uuid.v4()).called(1);
        verify(() => localDataSource.saveMessage(any()))
            .called(2); // User + Bot
        verify(() => remoteDataSource.sendMessage(
              botId: testBotId,
              content: testContent,
              imagePath: null,
              audioPath: null,
            )).called(1);

        // Step 2: User retrieves chat history
        final testMessages = [
          MessageModel(
            id: testMessageId,
            userId: testUserId,
            botId: testBotId,
            sender: 'user',
            content: testContent,
            timestamp: DateTime(2024, 1, 15, 10, 29),
            isSending: false,
            hasError: false,
          ),
          testBotResponse,
        ];

        when(() => localDataSource.getMessages(testUserId, testBotId,
            limit: any(named: 'limit'))).thenAnswer((_) async => testMessages);

        final getResult = await getMessagesUseCase(testUserId, testBotId);

        expect(getResult.isRight(), true);
        getResult.fold(
          (failure) => fail('Should not fail'),
          (messages) {
            expect(messages.length, 2);
            expect(messages[0].sender, 'user');
            expect(messages[1].sender, 'bot');
          },
        );

        verify(() =>
                localDataSource.getMessages(testUserId, testBotId, limit: null))
            .called(1);
      });
    });

    group('Error Propagation Through Layers', () {
      test('should propagate authentication error from storage to use case',
          () async {
        // Arrange - secureStorage fails to get userId
        when(() => secureStorage.getUserId())
            .thenThrow(Exception('Not authenticated'));

        // Act
        final result = await sendMessageUseCase(
          botId: testBotId,
          content: testContent,
        );

        // Assert - error flows through repository to use case
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Failed to send')),
          (message) => fail('Should not succeed'),
        );
      });

      test('should propagate cache error from local datasource to use case',
          () async {
        // Arrange
        when(() => localDataSource.getMessages(testUserId, testBotId,
            limit: any(named: 'limit'))).thenThrow(Exception('Database error'));

        // Act
        final result = await getMessagesUseCase(testUserId, testBotId);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Failed to load')),
          (messages) => fail('Should not succeed'),
        );
      });
    });

    group('Data Transformation Through Layers', () {
      test('should correctly transform MessageModel to Message entity',
          () async {
        // Arrange
        final messageModels = [testBotResponse];
        when(() => localDataSource.getMessages(testUserId, testBotId,
            limit: any(named: 'limit'))).thenAnswer((_) async => messageModels);

        // Act
        final result = await getMessagesUseCase(testUserId, testBotId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not fail'),
          (messages) {
            final message = messages[0];
            expect(message, isA<Message>()); // Not MessageModel
            expect(message.id, testBotResponse.id);
            expect(message.content, testBotResponse.content);
            expect(message.sender, testBotResponse.sender);
          },
        );
      });
    });

    group('Edge Cases Through Complete Flow', () {
      test('should handle empty chat history', () async {
        // Arrange
        when(() => localDataSource.getMessages(testUserId, testBotId,
            limit: any(named: 'limit'))).thenAnswer((_) async => []);

        // Act
        final result = await getMessagesUseCase(testUserId, testBotId);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not fail'),
          (messages) => expect(messages, isEmpty),
        );
      });

      test('should handle message with image attachment', () async {
        // Arrange
        const testImagePath = '/path/to/image.jpg';
        when(() => secureStorage.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => uuid.v4()).thenReturn(testMessageId);
        when(() => localDataSource.saveMessage(any()))
            .thenAnswer((_) async => {});

        final botResponseWithImage = MessageModel(
          id: testBotResponseId,
          userId: testUserId,
          botId: testBotId,
          sender: 'bot',
          content: 'Here is your chart',
          imageUrl: 'https://example.com/chart.png',
          timestamp: DateTime(2024, 1, 15),
          isSending: false,
          hasError: false,
        );

        when(() => remoteDataSource.sendMessage(
              botId: any(named: 'botId'),
              content: any(named: 'content'),
              imagePath: any(named: 'imagePath'),
              audioPath: any(named: 'audioPath'),
            )).thenAnswer((_) async => botResponseWithImage);

        // Act
        final result = await sendMessageUseCase(
          botId: testBotId,
          content: testContent,
          imagePath: testImagePath,
        );

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not fail'),
          (message) {
            expect(message.imageUrl, isNotNull);
            expect(message.imageUrl, contains('chart.png'));
          },
        );

        verify(() => remoteDataSource.sendMessage(
              botId: testBotId,
              content: testContent,
              imagePath: testImagePath,
              audioPath: null,
            )).called(1);
      });
    });
  });
}
