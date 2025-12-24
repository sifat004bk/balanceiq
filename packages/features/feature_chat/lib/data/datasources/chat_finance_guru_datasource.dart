import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/constants/api_endpoints.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import '../../domain/entities/chart_data.dart';
import '../models/chat_request_models.dart';
import '../models/chat_history_response_model.dart';
import '../models/message_model.dart';
import 'chat_remote_datasource.dart';

/// Error types for chat API exceptions
enum ChatApiErrorType {
  emailNotVerified,
  subscriptionRequired,
  subscriptionExpired,
  tokenLimitExceeded,
  rateLimitExceeded,
  currencyRequired,
  general,
}

/// Custom exception for chat API errors
class ChatApiException implements Exception {
  final String message;
  final ChatApiErrorType errorType;

  ChatApiException({
    required this.message,
    required this.errorType,
  });

  @override
  String toString() => message;
}

/// Finance Guru API implementation based on Postman API Collection spec
/// Endpoints:
/// - POST /api/finance-guru/chat
/// - GET /api/finance-guru/chat-history
class ChatFinanceGuruDataSource implements ChatRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final SecureStorageService secureStorage;

  ChatFinanceGuruDataSource(
      this.dio, this.sharedPreferences, this.secureStorage);

  @override
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    try {
      // Get user info
      final userId = await secureStorage.getUserId() ?? '';
      final userEmail = sharedPreferences
              .getString(GetIt.instance<AppConstants>().keyUserEmail) ??
          '';
      final userName = sharedPreferences
              .getString(GetIt.instance<AppConstants>().keyUserName) ??
          'User';

      // Check if currency is set
      final currency = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyCurrencyCode);
      if (currency == null) {
        throw ChatApiException(
          message: 'Currency not set',
          errorType: ChatApiErrorType.currencyRequired,
        );
      }

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
      final token = await secureStorage.getToken();

      // Send request to finance-guru chat endpoint
      final response = await dio.post(
        ApiEndpoints.chat,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final chatResponse = ChatResponse.fromJson(response.data);

        // Convert graphType string to GraphType enum
        final graphTypeEnum = chatResponse.graphType != null
            ? (chatResponse.graphType == 'line'
                ? GraphType.line
                : GraphType.bar)
            : null;

        // Create a message model from the bot's response
        final botMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          botId: botId,
          sender: GetIt.instance<AppConstants>().senderBot,
          content: chatResponse.message,
          timestamp: DateTime.now(),
          isSending: false,
          hasError: false,
          actionType: chatResponse.actionType,
          hasTable: chatResponse.table,
          tableData: chatResponse.tableData,
          graphType: graphTypeEnum,
          graphData: chatResponse.graphData,
        );

        return botMessage;
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Request timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? e.response?.data?['error'] ?? '';

        // Handle 403 Forbidden errors with specific error types
        if (statusCode == 403) {
          if (message.toString().toLowerCase().contains('verify your email')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.emailNotVerified,
            );
          } else if (message
              .toString()
              .toLowerCase()
              .contains('active subscription')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.subscriptionRequired,
            );
          } else if (message.toString().toLowerCase().contains('expired')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.subscriptionExpired,
            );
          } else if (message.toString().toLowerCase().contains('token limit')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.tokenLimitExceeded,
            );
          } else if (message.toString().toLowerCase().contains('currency')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.currencyRequired,
            );
          }
        } else if (statusCode == 429) {
          throw ChatApiException(
            message: message.toString(),
            errorType: ChatApiErrorType.rateLimitExceeded,
          );
        } else if (statusCode == 400) {
          if (message.toString().toLowerCase().contains('currency')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.currencyRequired,
            );
          }
        }
        throw Exception(
            'Server error ($statusCode): ${message ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ChatApiException) rethrow;
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<ChatHistoryResponseModel> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  }) async {
    try {
      final queryParams = ChatHistoryQueryParams(
        page: page,
        size: limit ?? 20,
      );

      // Check if currency is set
      final currency = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyCurrencyCode);
      if (currency == null || currency.isEmpty) {
        throw ChatApiException(
          message: 'Currency not set',
          errorType: ChatApiErrorType.currencyRequired,
        );
      }

      // Get auth token if available
      final token = await secureStorage.getToken();

      final response = await dio.get(
        ApiEndpoints.chatHistory,
        queryParameters: queryParams.toQueryParams(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return ChatHistoryResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get chat history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Request timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? e.response?.data?['error'] ?? '';

        // Handle 403 Forbidden errors with specific error types
        if (statusCode == 403) {
          if (message.toString().toLowerCase().contains('verify your email')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.emailNotVerified,
            );
          } else if (message
              .toString()
              .toLowerCase()
              .contains('active subscription')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.subscriptionRequired,
            );
          } else if (message.toString().toLowerCase().contains('expired')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.subscriptionExpired,
            );
          } else if (message.toString().toLowerCase().contains('token limit')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.tokenLimitExceeded,
            );
          } else if (message.toString().toLowerCase().contains('currency')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.currencyRequired,
            );
          }
        } else if (statusCode == 429) {
          throw ChatApiException(
            message: message.toString(),
            errorType: ChatApiErrorType.rateLimitExceeded,
          );
        } else if (statusCode == 400) {
          if (message.toString().toLowerCase().contains('currency')) {
            throw ChatApiException(
              message: message.toString(),
              errorType: ChatApiErrorType.currencyRequired,
            );
          }
        }
        throw Exception(
            'Server error ($statusCode): ${message ?? 'Unknown error'}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is ChatApiException) rethrow;
      throw Exception('Failed to get chat history: $e');
    }
  }
}
