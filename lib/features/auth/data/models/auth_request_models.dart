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
