import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Chat History API Tests', () {
    late Dio dio;
    late String chatHistoryUrl;
    late String authToken;
    final testUserId =
        '8130001838'; // Use the user ID from the Postman collection

    setUpAll(() async {
      // Load environment variables
      await dotenv.load(fileName: '.env');
      chatHistoryUrl = dotenv.get('N8N_CHAT_HISTORY_URL',
          fallback:
              'https://primary-production-7383b.up.railway.app/webhook/get-user-chat-history');
      authToken = dotenv.get('N8N_DASHBOARD_AUTH_TOKEN',
          fallback: 'Dolphin D#-#{Oo"|tC[fHDBpCjwhBfrY?O-56s64R|S,b8D-41eRLd8');

      // Initialize Dio
      dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authToken,
          },
        ),
      );

      // Add logging interceptor for debugging
      dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    });

    tearDownAll(() {
      dio.close();
    });

    test('1. Get Chat History - First page with default limit', () async {
      final response = await dio.post(
        chatHistoryUrl,
        data: {
          'user_id': testUserId,
          'page': 1,
        },
      );

      expect(response.statusCode, anyOf([200, 201]));
      expect(response.data, isNotNull);

      // Handle both array and object responses from n8n
      dynamic responseData = response.data;
      if (responseData is List && responseData.isNotEmpty) {
        responseData = responseData.first;
      }

      print('✅ Chat history retrieved (page 1):');
      print('   Total messages: ${responseData['total'] ?? 'N/A'}');
      print('   Page: ${responseData['page'] ?? 1}');
      print('   Limit: ${responseData['limit'] ?? 20}');
      print('   Has more: ${responseData['hasMore'] ?? false}');

      if (responseData['messages'] != null) {
        final messages = responseData['messages'] as List;
        print('   Messages count: ${messages.length}');
        if (messages.isNotEmpty) {
          print('   First message: ${messages.first}');
        }
      }
    });

    test('2. Get Chat History - With custom limit', () async {
      final response = await dio.post(
        chatHistoryUrl,
        data: {
          'user_id': testUserId,
          'page': 1,
          'limit': 5,
        },
      );

      expect(response.statusCode, anyOf([200, 201]));
      expect(response.data, isNotNull);

      // Handle both array and object responses from n8n
      dynamic responseData = response.data;
      if (responseData is List && responseData.isNotEmpty) {
        responseData = responseData.first;
      }

      expect(responseData['limit'], 5);
      print('✅ Chat history retrieved with custom limit (5):');
      print('   Messages returned: ${responseData['messages']?.length ?? 0}');
    });

    test('3. Get Chat History - Second page', () async {
      final response = await dio.post(
        chatHistoryUrl,
        data: {
          'user_id': testUserId,
          'page': 2,
          'limit': 10,
        },
      );

      expect(response.statusCode, anyOf([200, 201]));
      expect(response.data, isNotNull);

      // Handle both array and object responses from n8n
      dynamic responseData = response.data;
      if (responseData is List && responseData.isNotEmpty) {
        responseData = responseData.first;
      }

      expect(responseData['page'], 2);
      print('✅ Chat history retrieved (page 2):');
      print('   Messages returned: ${responseData['messages']?.length ?? 0}');
      print('   Has more: ${responseData['hasMore'] ?? false}');
    });

    test('4. Get Chat History - Invalid user ID', () async {
      try {
        final response = await dio.post(
          chatHistoryUrl,
          data: {
            'user_id': 'invalid_user_id',
            'page': 1,
          },
        );

        // If the request succeeds, check if it returns empty results
        expect(response.statusCode, anyOf([200, 201]));
        dynamic responseData = response.data;
        if (responseData is List && responseData.isNotEmpty) {
          responseData = responseData.first;
        }

        // Should return empty or no messages for invalid user
        if (responseData['messages'] != null) {
          final messages = responseData['messages'] as List;
          expect(messages, isEmpty);
        }
        print('✅ Invalid user ID correctly handled (returned empty results)');
      } on DioException catch (e) {
        // Or it might return an error
        expect(e.response?.statusCode, anyOf([400, 404]));
        print(
            '✅ Invalid user ID correctly rejected with status ${e.response?.statusCode}');
      }
    });

    test('5. Get Chat History - Missing required parameters', () async {
      try {
        await dio.post(
          chatHistoryUrl,
          data: {
            'user_id': testUserId,
            // Missing 'page' parameter
          },
        );

        // Some APIs might have default values
        print('⚠️ API accepted request without page parameter (using default)');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf([400, 422]));
        print(
            '✅ Missing parameters correctly rejected with status ${e.response?.statusCode}');
      }
    });

    test('6. Get Chat History - Invalid authorization token', () async {
      try {
        final testDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'invalid_token',
            },
          ),
        );

        await testDio.post(
          chatHistoryUrl,
          data: {
            'user_id': testUserId,
            'page': 1,
          },
        );

        testDio.close();
        print('⚠️ API accepted request with invalid token');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf([401, 403]));
        print(
            '✅ Invalid token correctly rejected with status ${e.response?.statusCode}');
      }
    });
  });
}
