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

/// Signup API Response
/// POST /api/auth/signup
class SignupResponse {
  final bool success;
  final String message;
  final SignupData? data;
  final String? error;
  final int timestamp;

  SignupResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    required this.timestamp,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? SignupData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}

class SignupData {
  final int id;
  final String email;
  final String username;
  final String fullName;
  final String userRole;
  final String? subscriptionPlanName;
  final String? subscriptionStatus;
  final String? subscriptionEndDate;
  final bool isActive;
  final bool isEmailVerified;
  final String createdAt;

  SignupData({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.userRole,
    this.subscriptionPlanName,
    this.subscriptionStatus,
    this.subscriptionEndDate,
    required this.isActive,
    required this.isEmailVerified,
    required this.createdAt,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      userRole: json['userRole'] as String? ?? 'USER',
      subscriptionPlanName: json['subscriptionPlanName'] as String?,
      subscriptionStatus: json['subscriptionStatus'] as String?,
      subscriptionEndDate: json['subscriptionEndDate'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

/// Login API Response
/// POST /api/auth/login
class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;
  final String? error;
  final int timestamp;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    required this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}

class LoginData {
  final String token;
  final String refreshToken;
  final int userId;
  final String username;
  final String email;
  final String role;
  final bool isEmailVerified;

  LoginData({
    required this.token,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.isEmailVerified,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }
}

/// Generic API Response for simple success/error messages
/// Used by: forgot-password, reset-password, change-password
class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? error;
  final int timestamp;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'],
      error: json['error'] as String?,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}

/// User profile information
/// GET /api/auth/me
class UserInfo {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String? photoUrl;
  final List<String> roles;
  final bool isEmailVerified;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.photoUrl,
    required this.roles,
    this.isEmailVerified = false,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    // Handle both direct user object and nested data structure
    final Map<String, dynamic> userData = json.containsKey('data')
        ? json['data'] as Map<String, dynamic>
        : json;

    return UserInfo(
      id: userData['id'] as int? ?? userData['userId'] as int? ?? 0,
      username: userData['username'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      fullName: userData['fullName'] as String? ?? '',
      photoUrl: userData['photoUrl'] as String?,
      roles: (userData['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [userData['role'] as String? ?? 'USER'],
      isEmailVerified: userData['isEmailVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'roles': roles,
      'isEmailVerified': isEmailVerified,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}

class RefreshTokenResponse {
  final bool success;
  final String message;
  final RefreshTokenData? data;
  final String? error;
  final int timestamp;

  RefreshTokenResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    required this.timestamp,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RefreshTokenData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      error: json['error'] as String?,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}

class RefreshTokenData {
  final String token;
  final String refreshToken;
  final dynamic user;

  RefreshTokenData({
    required this.token,
    required this.refreshToken,
    this.user,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return RefreshTokenData(
      token: json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: json['user'],
    );
  }
}
