import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    try {
      // Prepare the request payload
      final Map<String, dynamic> payload = {
        'bot_id': botId,
        'message': content,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Add image as base64 if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);
          payload['image'] = base64Image;
        }
      }

      // Add audio as base64 if provided
      if (audioPath != null && audioPath.isNotEmpty) {
        final audioFile = File(audioPath);
        if (await audioFile.exists()) {
          final bytes = await audioFile.readAsBytes();
          final base64Audio = base64Encode(bytes);
          payload['audio'] = base64Audio;
        }
      }

      // Send request to n8n webhook
      final response = await dio.post(
        AppConstants.n8nWebhookUrl,
        data: payload,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response from n8n
        final responseData = response.data as Map<String, dynamic>;

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
}
