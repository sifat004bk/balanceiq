// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication API Tests', () {
    late Dio dio;
    late String baseUrl;
    String? authToken;
    final testUsername = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
    final testEmail =
        'test_${DateTime.now().millisecondsSinceEpoch}@example.com';
    final testPassword = 'Test@123456';
    final testFullName = 'Test User';

    setUpAll(() async {
      // Load environment variables
      await dotenv.load(fileName: '.env');
      baseUrl = dotenv.get('BACKEND_BASE_URL',
          fallback: 'https://primary-production-7383b.up.railway.app');

      // Initialize Dio
      dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
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

    test('1. Signup - Create new user account', () async {
      final response = await dio.post(
        '/api/auth/signup',
        data: {
          'username': testUsername,
          'password': testPassword,
          'fullName': testFullName,
          'email': testEmail,
        },
      );

      expect(response.statusCode, anyOf([200, 201]));
      expect(response.data, isNotNull);
      print('✅ Signup successful: ${response.data}');
    });

    test('2. Login - Authenticate with credentials', () async {
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'username': testUsername,
          'password': testPassword,
        },
      );

      expect(response.statusCode, 200);
      expect(response.data, isNotNull);
      expect(response.data['token'], isNotNull);

      // Store token for subsequent tests
      authToken = response.data['token'];
      print('✅ Login successful. Token: ${authToken?.substring(0, 20)}...');
    });

    test('3. Get Profile - Fetch user profile', () async {
      expect(authToken, isNotNull,
          reason: 'Auth token should be available from login test');

      final response = await dio.get(
        '/api/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      expect(response.statusCode, 200);
      expect(response.data, isNotNull);
      expect(response.data['username'], testUsername);
      expect(response.data['email'], testEmail);
      print('✅ Profile retrieved: ${response.data}');
    });

    test('4. Change Password - Update user password', () async {
      expect(authToken, isNotNull,
          reason: 'Auth token should be available from login test');

      final newPassword = 'NewTest@123456';

      final response = await dio.post(
        '/api/auth/change-password',
        data: {
          'currentPassword': testPassword,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      );

      expect(response.statusCode, 200);
      print('✅ Password changed successfully');

      // Test login with new password
      final loginResponse = await dio.post(
        '/api/auth/login',
        data: {
          'username': testUsername,
          'password': newPassword,
        },
      );

      expect(loginResponse.statusCode, 200);
      expect(loginResponse.data['token'], isNotNull);
      authToken = loginResponse.data['token'];
      print('✅ Login with new password successful');
    });

    test('5. Forgot Password - Request password reset', () async {
      final response = await dio.post(
        '/api/auth/forgot-password',
        data: {'email': testEmail},
      );

      expect(response.statusCode, 200);
      print('✅ Forgot password request sent successfully');
    });

    test('6. Login with invalid credentials - Should fail', () async {
      try {
        await dio.post(
          '/api/auth/login',
          data: {
            'username': 'invalid_user',
            'password': 'invalid_password',
          },
        );
        fail('Should have thrown an exception');
      } on DioException catch (e) {
        expect(e.response?.statusCode, anyOf([401, 404]));
        print(
            '✅ Invalid login correctly rejected with status ${e.response?.statusCode}');
      }
    });

    test('7. Access protected endpoint without token - Should fail', () async {
      try {
        await dio.get('/api/auth/me');
        fail('Should have thrown an exception');
      } on DioException catch (e) {
        expect(e.response?.statusCode, 401);
        print('✅ Unauthorized access correctly rejected');
      }
    });
  });
}
