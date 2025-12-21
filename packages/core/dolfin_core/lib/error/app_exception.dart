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
  const NetworkException([super.message = 'No internet connection'])
      : super(code: 'NETWORK_ERROR');
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode})
      : super(code: 'SERVER_ERROR', details: statusCode);
}

class AuthException extends AppException {
  const AuthException(super.message) : super(code: 'AUTH_ERROR');
}

class CacheException extends AppException {
  const CacheException(super.message) : super(code: 'CACHE_ERROR');
}

class ValidationException extends AppException {
  const ValidationException(super.message) : super(code: 'VALIDATION_ERROR');
}

class UnknownException extends AppException {
  const UnknownException(super.message) : super(code: 'UNKNOWN_ERROR');
}
