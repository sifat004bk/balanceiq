import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.photoUrl,
    required super.authProvider,
    required super.createdAt,
    super.isEmailVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      authProvider: json['auth_provider'] as String,
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
      authProvider: authProvider,
      createdAt: createdAt,
      isEmailVerified: isEmailVerified,
    );
  }
}
