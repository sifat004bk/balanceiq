import 'package:balance_iq/core/constants/api_endpoints.dart';
import 'package:balance_iq/features/chat/data/models/token_usage_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Token usage API data source
/// Endpoint: GET /api/finance-guru/v1/token-usage
/// Auth: Bearer token
abstract class TokenUsageDataSource {
  Future<TokenUsageModel> getTokenUsage();
}

/// Implementation of token usage data source
class TokenUsageDataSourceImpl implements TokenUsageDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  TokenUsageDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<TokenUsageModel> getTokenUsage() async {
    try {
      // Get auth token
      final token = sharedPreferences.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.tokenUsage,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          throw Exception('No token usage data available');
        }

        return TokenUsageModel.fromJson(responseData);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Server is taking too long to respond. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('No token usage data') ||
          e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Failed to load token usage: $e');
    }
  }
}
