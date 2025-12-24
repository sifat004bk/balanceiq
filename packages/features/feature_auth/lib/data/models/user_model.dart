import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.photoUrl,
    super.currency,
    required super.authProvider,
    required super.createdAt,
    super.isEmailVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      currency: json['currency'] as String?,
      authProvider: json['auth_provider'] as String? ??
          'email', // Handle generic fallback or ensure API sends it
      createdAt: DateTime.parse(json['created_at'] as String),
      isEmailVerified: json['is_email_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'currency': currency,
      'auth_provider': authProvider,
      'created_at': createdAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
      currency: user.currency,
      authProvider: user.authProvider,
      createdAt: user.createdAt,
      isEmailVerified: user.isEmailVerified,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      currency: currency,
      authProvider: authProvider,
      createdAt: createdAt,
      isEmailVerified: isEmailVerified,
    );
  }
}
