import 'package:feature_auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Entity', () {
    final testDate = DateTime(2024, 1, 15);

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final user1 = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        final user2 = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when id differs', () {
        final user1 = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        final user2 = User(
          id: '2',
          email: 'test@example.com',
          name: 'Test User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user1, isNot(equals(user2)));
      });

      test('should not be equal when email differs', () {
        final user1 = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        final user2 = User(
          id: '1',
          email: 'different@example.com',
          name: 'Test User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user1, isNot(equals(user2)));
      });
    });

    group('Properties', () {
      test('should have correct properties', () {
        final user = User(
          id: '123',
          email: 'john@example.com',
          name: 'John Doe',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
          photoUrl: 'https://example.com/photo.jpg',
        );

        expect(user.id, '123');
        expect(user.email, 'john@example.com');
        expect(user.name, 'John Doe');
        expect(user.authProvider, 'email');
        expect(user.createdAt, testDate);
        expect(user.isEmailVerified, true);
        expect(user.photoUrl, 'https://example.com/photo.jpg');
      });

      test('should handle unverified email', () {
        final user = User(
          id: '2',
          email: 'new@example.com',
          name: 'New User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: false,
        );

        expect(user.isEmailVerified, false);
      });

      test('should handle optional photoUrl', () {
        final user = User(
          id: '3',
          email: 'user@example.com',
          name: 'User',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user.photoUrl, null);
      });
    });

    group('Auth Provider', () {
      test('should support email auth provider', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user.authProvider, 'email');
      });

      test('should support google auth provider', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test',
          authProvider: 'google',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user.authProvider, 'google');
      });

      test('should support apple auth provider', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test',
          authProvider: 'apple',
          createdAt: testDate,
          isEmailVerified: true,
        );

        expect(user.authProvider, 'apple');
      });
    });

    group('copyWith', () {
      test('should create copy with updated name', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Old Name',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: false,
        );

        final updated = user.copyWith(name: 'New Name');

        expect(updated.id, user.id);
        expect(updated.name, 'New Name');
        expect(updated.email, user.email);
      });

      test('should create copy with updated email verification', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: false,
        );

        final updated = user.copyWith(isEmailVerified: true);

        expect(updated.isEmailVerified, true);
        expect(updated.id, user.id);
        expect(updated.name, user.name);
      });

      test('should preserve values when not specified', () {
        final user = User(
          id: '1',
          email: 'test@example.com',
          name: 'Test',
          authProvider: 'email',
          createdAt: testDate,
          isEmailVerified: true,
          photoUrl: 'https://example.com/photo.jpg',
        );

        final updated = user.copyWith();

        expect(updated, equals(user));
      });
    });
  });
}
