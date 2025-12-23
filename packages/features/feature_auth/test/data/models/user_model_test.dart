import 'package:feature_auth/data/models/user_model.dart';
import 'package:feature_auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    final testDateTime = DateTime(2024, 1, 1, 12, 0, 0);

    final testUserModel = UserModel(
      id: 'user_123',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
      authProvider: 'google',
      createdAt: testDateTime,
      isEmailVerified: true,
    );

    final testJson = {
      'id': 'user_123',
      'email': 'test@example.com',
      'name': 'Test User',
      'photo_url': 'https://example.com/photo.jpg',
      'auth_provider': 'google',
      'created_at': '2024-01-01T12:00:00.000',
      'is_email_verified': true,
    };

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Act
        final result = UserModel.fromJson(testJson);

        // Assert
        expect(result.id, testUserModel.id);
        expect(result.email, testUserModel.email);
        expect(result.name, testUserModel.name);
        expect(result.photoUrl, testUserModel.photoUrl);
        expect(result.authProvider, testUserModel.authProvider);
        expect(result.isEmailVerified, testUserModel.isEmailVerified);
      });

      test('should handle null photoUrl', () {
        // Arrange
        final jsonWithoutPhoto = Map<String, dynamic>.from(testJson);
        jsonWithoutPhoto['photo_url'] = null;

        // Act
        final result = UserModel.fromJson(jsonWithoutPhoto);

        // Assert
        expect(result.photoUrl, isNull);
      });

      test('should default isEmailVerified to false when not present', () {
        // Arrange
        final jsonWithoutVerified = Map<String, dynamic>.from(testJson);
        jsonWithoutVerified.remove('is_email_verified');

        // Act
        final result = UserModel.fromJson(jsonWithoutVerified);

        // Assert
        expect(result.isEmailVerified, false);
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        // Act
        final result = testUserModel.toJson();

        // Assert
        expect(result['id'], 'user_123');
        expect(result['email'], 'test@example.com');
        expect(result['name'], 'Test User');
        expect(result['photo_url'], 'https://example.com/photo.jpg');
        expect(result['auth_provider'], 'google');
        expect(result['is_email_verified'], true);
        expect(result['created_at'], isNotNull);
      });

      test('should include null photoUrl in JSON', () {
        // Arrange
        final userWithoutPhoto = UserModel(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: null,
          authProvider: 'email',
          createdAt: testDateTime,
          isEmailVerified: false,
        );

        // Act
        final result = userWithoutPhoto.toJson();

        // Assert
        expect(result['photo_url'], isNull);
      });
    });

    group('fromEntity', () {
      test('should create UserModel from User entity', () {
        // Arrange
        final user = User(
          id: 'user_456',
          email: 'entity@example.com',
          name: 'Entity User',
          photoUrl: 'https://example.com/entity.jpg',
          authProvider: 'apple',
          createdAt: testDateTime,
          isEmailVerified: true,
        );

        // Act
        final result = UserModel.fromEntity(user);

        // Assert
        expect(result.id, user.id);
        expect(result.email, user.email);
        expect(result.name, user.name);
        expect(result.photoUrl, user.photoUrl);
        expect(result.authProvider, user.authProvider);
        expect(result.createdAt, user.createdAt);
        expect(result.isEmailVerified, user.isEmailVerified);
      });
    });

    group('toEntity', () {
      test('should convert UserModel to User entity', () {
        // Act
        final result = testUserModel.toEntity();

        // Assert
        expect(result, isA<User>());
        expect(result.id, testUserModel.id);
        expect(result.email, testUserModel.email);
        expect(result.name, testUserModel.name);
        expect(result.photoUrl, testUserModel.photoUrl);
        expect(result.authProvider, testUserModel.authProvider);
        expect(result.createdAt, testUserModel.createdAt);
        expect(result.isEmailVerified, testUserModel.isEmailVerified);
      });
    });

    group('equality', () {
      test('UserModel should have same props as User with same values', () {
        // Arrange
        final user = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          authProvider: 'google',
          createdAt: testDateTime,
          isEmailVerified: true,
        );

        // Assert - UserModel extends User with Equatable, so props should match
        expect(testUserModel.id, user.id);
        expect(testUserModel.email, user.email);
        expect(testUserModel.name, user.name);
        expect(testUserModel.photoUrl, user.photoUrl);
        expect(testUserModel.authProvider, user.authProvider);
        expect(testUserModel.createdAt, user.createdAt);
        expect(testUserModel.isEmailVerified, user.isEmailVerified);
      });

      test('Two UserModels with same values should be equal', () {
        // Arrange
        final userModel1 = UserModel(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          authProvider: 'google',
          createdAt: testDateTime,
          isEmailVerified: true,
        );

        final userModel2 = UserModel(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          authProvider: 'google',
          createdAt: testDateTime,
          isEmailVerified: true,
        );

        // Assert
        expect(userModel1, equals(userModel2));
      });
    });
  });
}
