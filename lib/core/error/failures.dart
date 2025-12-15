import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Chat API failure with specific error types for 403/429 handling
enum ChatFailureType {
  emailNotVerified,
  subscriptionRequired,
  subscriptionExpired,
  tokenLimitExceeded,
  rateLimitExceeded,
  general,
}

class ChatApiFailure extends Failure {
  final ChatFailureType failureType;

  const ChatApiFailure(super.message, {this.failureType = ChatFailureType.general});

  @override
  List<Object> get props => [message, failureType];
}
