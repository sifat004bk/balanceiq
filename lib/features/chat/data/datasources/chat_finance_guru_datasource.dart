import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/chat_request_models.dart';
import '../models/message_model.dart';
import 'chat_remote_datasource.dart';

/// Finance Guru API implementation based on Postman API Collection spec
/// Endpoints:
/// - POST /api/finance-guru/chat
/// - GET /api/finance-guru/chat-history
class ChatFinanceGuruDataSource implements ChatRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ChatFinanceGuruDataSource(this.dio, this.sharedPreferences);

  @override
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    try {
      // Get username from SharedPreferences
      final userEmail = sharedPreferences.getString(AppConstants.keyUserEmail) ?? '';
      final userName = sharedPreferences.getString(AppConstants.keyUserName) ?? 'User';

      // Use username from email or full name
      final username = userEmail.split('@').first.isNotEmpty
          ? userEmail.split('@').first
          : userName.replaceAll(' ', '').toLowerCase();

      // Create request matching API spec: {"text": "...", "username": "..."}
      // Note: API spec does not support image_base64 or audio_base64
      final request = ChatRequest(
        text: content,
        username: username,
      );

      // Get auth token if available
      final token = sharedPreferences.getString('auth_token');

      // Send request to finance-guru chat endpoint
      final response = await dio.post(
        '${AppConstants.backendBaseUrl}/api/finance-guru/chat',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final chatResponse = ChatResponse.fromJson(response.data);

        // Create a message model from the bot's response
        final botMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          botId: botId,
          sender: AppConstants.senderBot,
          content: chatResponse.message,
          timestamp: DateTime.now(),
          isSending: false,
          hasError: false,
        );

        return botMessage;
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.response?.data?['error'];
        throw Exception('Server error ($statusCode): ${message ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<ChatHistoryResponse> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  }) async {
    try {
      final queryParams = ChatHistoryQueryParams(
        page: page,
        limit: limit ?? 20,
      );

      // Get auth token if available
      final token = sharedPreferences.getString('auth_token');

      final response = await dio.get(
        '${AppConstants.backendBaseUrl}/api/finance-guru/chat-history',
        queryParameters: queryParams.toQueryParams(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return ChatHistoryResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to get chat history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.response?.data?['error'];
        throw Exception('Server error ($statusCode): ${message ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }
}
