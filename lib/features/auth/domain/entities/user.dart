import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String authProvider; // 'google' or 'apple'
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.authProvider,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        photoUrl,
        authProvider,
        createdAt,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? authProvider,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
