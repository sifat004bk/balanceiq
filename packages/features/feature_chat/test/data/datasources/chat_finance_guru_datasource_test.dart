import 'package:dio/dio.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:feature_chat/data/datasources/chat_finance_guru_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockResponse extends Mock implements Response {}

class MockAppConstants extends Mock implements AppConstants {}

void main() {
  late ChatFinanceGuruDataSource dataSource;
  late MockDio mockDio;
  late MockSharedPreferences mockSharedPreferences;
  late MockSecureStorageService mockSecureStorage;
  late MockAppConstants mockAppConstants;

  setUp(() {
    mockDio = MockDio();
    mockSharedPreferences = MockSharedPreferences();
    mockSecureStorage = MockSecureStorageService();
    mockAppConstants = MockAppConstants();

    GetIt.instance.registerSingleton<AppConstants>(mockAppConstants);
    when(() => mockAppConstants.keyUserEmail).thenReturn('user_email');
    when(() => mockAppConstants.keyUserName).thenReturn('user_name');
    when(() => mockAppConstants.senderBot).thenReturn('bot');
    when(() => mockAppConstants.apiTimeout)
        .thenReturn(const Duration(milliseconds: 1000));

    dataSource = ChatFinanceGuruDataSource(
        mockDio, mockSharedPreferences, mockSecureStorage);

    when(() => mockAppConstants.keyCurrencyCode)
        .thenReturn('selected_currency_code');
    when(() => mockSharedPreferences.getString('selected_currency_code'))
        .thenReturn('USD'); // Default to set
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('sendMessage', () {
    const tBotId = 'bot1';
    const tContent = 'Hello';

    test(
        'should throw ChatApiException with currencyRequired locally when currency is not set',
        () async {
      // Arrange
      when(() => mockSecureStorage.getUserId())
          .thenAnswer((_) async => 'user1');
      when(() => mockSharedPreferences.getString('selected_currency_code'))
          .thenReturn(null); // Currency NOT set

      // Act
      final call = dataSource.sendMessage;

      // Assert
      expect(
          () => call(botId: tBotId, content: tContent),
          throwsA(isA<ChatApiException>().having((e) => e.errorType,
              'errorType', ChatApiErrorType.currencyRequired)));

      verifyNever(() => mockDio.post(any(),
          data: any(named: 'data'), options: any(named: 'options')));
    });

    test(
        'should throw ChatApiException with currencyRequired when 400 error contains "currency"',
        () async {
      // Arrange
      when(() => mockSecureStorage.getUserId())
          .thenAnswer((_) async => 'user1');
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // Ensure currency IS set for this test so it proceeds to API
      when(() => mockSharedPreferences.getString('selected_currency_code'))
          .thenReturn('USD');

      when(() => mockSecureStorage.getToken()).thenAnswer((_) async => 'token');

      when(() => mockDio.post(
                any(),
                data: any(named: 'data'),
                options: any(named: 'options'),
              ))
          .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              response: Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 400,
                  data: {
                    'message': 'Currency not set. Please update profile.'
                  })));

      // Act
      final call = dataSource.sendMessage;

      // Assert
      expect(
          () => call(botId: tBotId, content: tContent),
          throwsA(isA<ChatApiException>().having((e) => e.errorType,
              'errorType', ChatApiErrorType.currencyRequired)));
    });
    test(
        'should throw ChatApiException with currencyRequired when 403 error contains "currency"',
        () async {
      // Arrange
      when(() => mockSecureStorage.getUserId())
          .thenAnswer((_) async => 'user1');
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      // Ensure currency IS set so it hits the API
      when(() => mockSharedPreferences.getString('selected_currency_code'))
          .thenReturn('USD');

      when(() => mockSecureStorage.getToken()).thenAnswer((_) async => 'token');

      when(() => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenThrow(DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 403,
              data: {
                'message':
                    'Please set your preferred currency in your profile settings before using the chat feature.'
              })));

      // Act
      final call = dataSource.sendMessage;

      // Assert
      expect(
          () => call(botId: tBotId, content: tContent),
          throwsA(isA<ChatApiException>().having((e) => e.errorType,
              'errorType', ChatApiErrorType.currencyRequired)));
    });
  });

  group('getChatHistory', () {
    const tUserId = 'user1';

    test(
        'should throw ChatApiException with currencyRequired when currency is null',
        () async {
      // Arrange
      when(() => mockSharedPreferences.getString('selected_currency_code'))
          .thenReturn(null);

      // Act
      final call = dataSource.getChatHistory;

      // Assert
      expect(
          () => call(userId: tUserId, page: 1),
          throwsA(isA<ChatApiException>().having((e) => e.errorType,
              'errorType', ChatApiErrorType.currencyRequired)));
    });

    test(
        'should throw ChatApiException with currencyRequired when currency is empty',
        () async {
      // Arrange
      when(() => mockSharedPreferences.getString('selected_currency_code'))
          .thenReturn('');

      // Act
      final call = dataSource.getChatHistory;

      // Assert
      expect(
          () => call(userId: tUserId, page: 1),
          throwsA(isA<ChatApiException>().having((e) => e.errorType,
              'errorType', ChatApiErrorType.currencyRequired)));
    });

    test(
        'should throw ChatApiException with currencyRequired when 400 error contains "currency"',
        () async {
      // Arrange
      when(() => mockSharedPreferences.getString('selected_currency_code'))
          .thenReturn('USD');
      when(() => mockSecureStorage.getToken()).thenAnswer((_) async => 'token');

      when(() => mockDio.get(
                any(),
                queryParameters: any(named: 'queryParameters'),
                options: any(named: 'options'),
              ))
          .thenThrow(DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.badResponse,
              response: Response(
                  requestOptions: RequestOptions(path: ''),
                  statusCode: 400,
                  data: {
                    'message': 'Currency not set. Please update profile.'
                  })));

      // Act
      final call = dataSource.getChatHistory;

      // Assert
      expect(
          () => call(userId: tUserId, page: 1),
          throwsA(isA<ChatApiException>().having((e) => e.errorType,
              'errorType', ChatApiErrorType.currencyRequired)));
    });
  });
}
