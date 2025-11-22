/// Request and response models for authentication API endpoints

class SignupRequest {
  final String username;
  final String password;
  final String fullName;
  final String email;

  SignupRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
    };
  }
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class ResetPasswordRequest {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

class AuthResponse {
  final String? token;
  final UserInfo? user;
  final String? message;
  final bool success;

  AuthResponse({
    this.token,
    this.user,
    this.message,
    this.success = true,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String?,
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? true,
    );
  }
}

class UserInfo {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? photoUrl;
  final List<String> roles;

  UserInfo({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.roles = const [],
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((role) => role.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'roles': roles,
    };
  }
}

class ChatHistoryRequest {
  final String userId;
  final int page;
  final int? limit;

  ChatHistoryRequest({
    required this.userId,
    required this.page,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'user_id': userId,
      'page': page,
    };
    if (limit != null) {
      data['limit'] = limit!;
    }
    return data;
  }
}

class ChatHistoryResponse {
  final List<ChatMessage> messages;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  ChatHistoryResponse({
    required this.messages,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      messages: (json['messages'] as List<dynamic>?)
              ?.map((msg) => ChatMessage.fromJson(msg))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}

class ChatMessage {
  final String id;
  final String userId;
  final String message;
  final String? response;
  final String? imageBase64;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.message,
    this.response,
    this.imageBase64,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      message: json['message'] as String? ?? '',
      response: json['response'] as String?,
      imageBase64: json['image_base64'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'response': response,
      'image_base64': imageBase64,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
