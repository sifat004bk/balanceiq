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
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  group('sendMessage', () {
    const tBotId = 'bot1';
    const tContent = 'Hello';

    test(
        'should throw ChatApiException with currencyRequired when 400 error contains "currency"',
        () async {
      // Arrange
      when(() => mockSecureStorage.getUserId())
          .thenAnswer((_) async => 'user1');
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
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
  });
}
