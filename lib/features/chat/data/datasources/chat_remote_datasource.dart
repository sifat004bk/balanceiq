import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/chat_request_models.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  });

  Future<ChatHistoryResponse> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  ChatRemoteDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    try {
      // Hardcoded user ID for development/testing
      final userId = '6130001838';

      // Get user information from SharedPreferences
      final userName = sharedPreferences.getString(AppConstants.keyUserName) ?? 'User';
      final userEmail = sharedPreferences.getString(AppConstants.keyUserEmail) ?? '';

      // Parse name into first and last name
      final nameParts = userName.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Prepare the request payload matching webhook's expected format
      final Map<String, dynamic> payload = {
        'user_id': userId,
        'bot_id': botId,
        'content': content,
        'text': content,
        'message': content,
        'first_name': firstName,
        'last_name': lastName,
        'username': userEmail.split('@').first,
      };

      // Add image as base64 if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);
          payload['image_base64'] = base64Image;
        }
      }

      // Add audio as base64 if provided
      if (audioPath != null && audioPath.isNotEmpty) {
        final audioFile = File(audioPath);
        if (await audioFile.exists()) {
          final bytes = await audioFile.readAsBytes();
          final base64Audio = base64Encode(bytes);
          payload['audio_base64'] = base64Audio;
        }
      }

      // Send request to n8n webhook
      final response = await dio.post(
        AppConstants.n8nWebhookUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'authorization': AppConstants.n8nWebhookAuthToken,
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response from n8n
        // n8n webhook returns an array, so we get the first item
        dynamic rawData = response.data;
        Map<String, dynamic> responseData;

        if (rawData is List && rawData.isNotEmpty) {
          responseData = rawData.first as Map<String, dynamic>;
        } else if (rawData is Map<String, dynamic>) {
          responseData = rawData;
        } else {
          throw Exception('Unexpected response format from webhook');
        }

        // Create a message model from the bot's response
        final botMessage = MessageModel(
          id: responseData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          botId: botId,
          sender: AppConstants.senderBot,
          content: responseData['message'] ?? responseData['response'] ?? 'No response',
          imageUrl: responseData['image_url'],
          audioUrl: responseData['audio_url'],
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
        throw Exception('Server error: ${e.response?.statusCode}');
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
      // Create request body for n8n
      final requestBody = {
        'user_id': userId,
        'page': page,
        if (limit != null) 'limit': limit,
      };

      final response = await dio.post(
        AppConstants.n8nChatHistoryUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': AppConstants.n8nDashboardAuthToken,
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response from n8n
        dynamic rawData = response.data;
        Map<String, dynamic> responseData;

        if (rawData is List && rawData.isNotEmpty) {
          responseData = rawData.first as Map<String, dynamic>;
        } else if (rawData is Map<String, dynamic>) {
          responseData = rawData;
        } else {
          throw Exception('Unexpected response format from webhook');
        }

        return ChatHistoryResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to get chat history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }
}
