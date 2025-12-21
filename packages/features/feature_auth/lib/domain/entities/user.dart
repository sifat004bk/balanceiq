import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String authProvider; // 'google', 'apple', or 'email'
  final DateTime createdAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.authProvider,
    required this.createdAt,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        photoUrl,
        authProvider,
        createdAt,
        isEmailVerified,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? authProvider,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
