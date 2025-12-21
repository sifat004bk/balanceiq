import 'package:dolfin_core/constants/api_endpoints.dart';
import 'package:feature_chat/data/models/message_usage_model.dart';
import 'package:dio/dio.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

/// Message usage API data source
/// Endpoint: GET /api/finance-guru/v1/usage
/// Auth: Bearer token
abstract class MessageUsageDataSource {
  Future<MessageUsageModel> getMessageUsage();
}

/// Implementation of message usage data source
class MessageUsageDataSourceImpl implements MessageUsageDataSource {
  final Dio dio;
  final SecureStorageService secureStorage;

  MessageUsageDataSourceImpl(this.dio, this.secureStorage);

  @override
  Future<MessageUsageModel> getMessageUsage() async {
    try {
      // Get auth token
      final token = await secureStorage.getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.messageUsage,
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
          throw Exception('No message usage data available');
        }

        return MessageUsageModel.fromJson(responseData);
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
      if (e.toString().contains('No message usage data') ||
          e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Failed to load message usage: $e');
    }
  }
}
