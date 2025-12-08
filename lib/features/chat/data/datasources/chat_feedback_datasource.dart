import 'package:balance_iq/core/constants/api_endpoints.dart';
import 'package:balance_iq/features/chat/data/models/chat_feedback_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chat feedback API data source
/// Endpoint: POST /api/finance-guru/v1/chat-history/{id}/feedback
/// Auth: Bearer token
abstract class ChatFeedbackDataSource {
  Future<ChatFeedbackResponse> submitFeedback({
    required int messageId,
    required FeedbackType feedback,
  });
}

/// Implementation of chat feedback data source
class ChatFeedbackDataSourceImpl implements ChatFeedbackDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ChatFeedbackDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<ChatFeedbackResponse> submitFeedback({
    required int messageId,
    required FeedbackType feedback,
  }) async {
    try {
      // Get auth token
      final token = sharedPreferences.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final request = ChatFeedbackRequest(feedback: feedback);

      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.chatFeedback(messageId),
        data: request.toJson(),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          throw Exception('No response data');
        }

        return ChatFeedbackResponse.fromJson(responseData);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is taking too long to respond.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 403) {
        throw Exception(
            'You can only provide feedback on your own messages.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Chat message not found.');
      } else if (e.response?.statusCode == 400) {
        final message = e.response?.data?['message'] ??
            'Invalid feedback value. Must be LIKE, DISLIKE, or NONE.';
        throw Exception(message);
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Unauthorized') ||
          e.toString().contains('not found') ||
          e.toString().contains('own messages')) {
        rethrow;
      }
      throw Exception('Failed to submit feedback: $e');
    }
  }
}
