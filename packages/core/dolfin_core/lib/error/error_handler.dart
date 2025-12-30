import 'package:dio/dio.dart';
import 'app_exception.dart';
import '../utils/app_logger.dart';

class ErrorHandler {
  static AppException handle(dynamic error, {String? source}) {
    if (source != null) {
      AppLogger.error('Error in $source: $error',
          error: error, name: 'ErrorHandler');
    }

    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppException) {
      return error;
    } else {
      // For unknown errors, we log the specific error but show a generic message to the user
      return const UnknownException(
          'An unexpected error occurred. Please try again.');
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
            'Connection timed out. Please check your internet connection.');
      case DioExceptionType.connectionError:
        return const NetworkException(
            'No internet connection. Please check your settings.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const UnknownException('Request cancelled');
      default:
        return const UnknownException(
            'Something went wrong. Please try again.');
    }
  }

  static AppException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    // Try to extract message from common backend error formats
    String message = 'Server error';

    if (response?.data != null) {
      if (response!.data is Map) {
        message = response.data['message'] ??
            response.data['error'] ??
            'Server error';
      } else if (response.data is String) {
        message = response.data;
      }
    }

    if (statusCode == 401 || statusCode == 403) {
      return AuthException(message);
    }

    return ServerException(message, statusCode: statusCode);
  }
}
