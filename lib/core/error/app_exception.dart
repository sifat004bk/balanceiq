/// Sealed class hierarchy for application exceptions
/// typically thrown by data sources.
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message, code: 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(String message, {this.statusCode})
      : super(message, code: 'SERVER_ERROR', details: statusCode);
}

class AuthException extends AppException {
  const AuthException(String message) : super(message, code: 'AUTH_ERROR');
}

class CacheException extends AppException {
  const CacheException(String message) : super(message, code: 'CACHE_ERROR');
}

class ValidationException extends AppException {
  const ValidationException(String message)
      : super(message, code: 'VALIDATION_ERROR');
}

class UnknownException extends AppException {
  const UnknownException(String message)
      : super(message, code: 'UNKNOWN_ERROR');
}
