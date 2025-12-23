import 'package:feature_auth/data/models/auth_request_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignupRequest', () {
    test('should correctly create SignupRequest', () {
      // Arrange
      final request = SignupRequest(
        username: 'testuser',
        password: 'Password123!',
        fullName: 'Test User',
        email: 'test@example.com',
      );

      // Assert
      expect(request.username, 'testuser');
      expect(request.password, 'Password123!');
      expect(request.fullName, 'Test User');
      expect(request.email, 'test@example.com');
    });

    test('toJson should return correct map', () {
      // Arrange
      final request = SignupRequest(
        username: 'testuser',
        password: 'Password123!',
        fullName: 'Test User',
        email: 'test@example.com',
      );

      // Act
      final result = request.toJson();

      // Assert
      expect(result['username'], 'testuser');
      expect(result['password'], 'Password123!');
      expect(result['fullName'], 'Test User');
      expect(result['email'], 'test@example.com');
    });
  });

  group('LoginRequest', () {
    test('should correctly create LoginRequest', () {
      // Arrange
      final request = LoginRequest(
        username: 'testuser',
        password: 'Password123!',
      );

      // Assert
      expect(request.username, 'testuser');
      expect(request.password, 'Password123!');
    });

    test('toJson should return correct map', () {
      // Arrange
      final request = LoginRequest(
        username: 'testuser',
        password: 'Password123!',
      );

      // Act
      final result = request.toJson();

      // Assert
      expect(result['username'], 'testuser');
      expect(result['password'], 'Password123!');
    });
  });

  group('ChangePasswordRequest', () {
    test('should correctly create ChangePasswordRequest', () {
      // Arrange
      final request = ChangePasswordRequest(
        currentPassword: 'OldPassword123!',
        newPassword: 'NewPassword123!',
        confirmPassword: 'NewPassword123!',
      );

      // Assert
      expect(request.currentPassword, 'OldPassword123!');
      expect(request.newPassword, 'NewPassword123!');
      expect(request.confirmPassword, 'NewPassword123!');
    });

    test('toJson should return correct map', () {
      // Arrange
      final request = ChangePasswordRequest(
        currentPassword: 'OldPassword123!',
        newPassword: 'NewPassword123!',
        confirmPassword: 'NewPassword123!',
      );

      // Act
      final result = request.toJson();

      // Assert
      expect(result['currentPassword'], 'OldPassword123!');
      expect(result['newPassword'], 'NewPassword123!');
      expect(result['confirmPassword'], 'NewPassword123!');
    });
  });

  group('ForgotPasswordRequest', () {
    test('should correctly create ForgotPasswordRequest', () {
      // Arrange
      final request = ForgotPasswordRequest(email: 'test@example.com');

      // Assert
      expect(request.email, 'test@example.com');
    });

    test('toJson should return correct map', () {
      // Arrange
      final request = ForgotPasswordRequest(email: 'test@example.com');

      // Act
      final result = request.toJson();

      // Assert
      expect(result['email'], 'test@example.com');
    });
  });

  group('ResetPasswordRequest', () {
    test('should correctly create ResetPasswordRequest', () {
      // Arrange
      final request = ResetPasswordRequest(
        token: 'reset_token_123',
        newPassword: 'NewPassword123!',
        confirmPassword: 'NewPassword123!',
      );

      // Assert
      expect(request.token, 'reset_token_123');
      expect(request.newPassword, 'NewPassword123!');
      expect(request.confirmPassword, 'NewPassword123!');
    });

    test('toJson should return correct map', () {
      // Arrange
      final request = ResetPasswordRequest(
        token: 'reset_token_123',
        newPassword: 'NewPassword123!',
        confirmPassword: 'NewPassword123!',
      );

      // Act
      final result = request.toJson();

      // Assert
      expect(result['token'], 'reset_token_123');
      expect(result['newPassword'], 'NewPassword123!');
      expect(result['confirmPassword'], 'NewPassword123!');
    });
  });

  group('SignupResponse', () {
    test('fromJson should parse successful response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Signup successful',
        'data': {
          'id': 1,
          'email': 'test@example.com',
          'username': 'testuser',
          'fullName': 'Test User',
          'userRole': 'USER',
          'isActive': true,
          'isEmailVerified': false,
          'createdAt': '2024-01-01T12:00:00Z',
        },
        'timestamp': 1704067200,
      };

      // Act
      final result = SignupResponse.fromJson(json);

      // Assert
      expect(result.success, true);
      expect(result.message, 'Signup successful');
      expect(result.data, isNotNull);
      expect(result.data!.id, 1);
      expect(result.data!.email, 'test@example.com');
      expect(result.data!.username, 'testuser');
    });

    test('fromJson should handle error response', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Signup failed',
        'error': 'Email already exists',
        'timestamp': 1704067200,
      };

      // Act
      final result = SignupResponse.fromJson(json);

      // Assert
      expect(result.success, false);
      expect(result.error, 'Email already exists');
      expect(result.data, isNull);
    });
  });

  group('LoginResponse', () {
    test('fromJson should parse successful response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Login successful',
        'data': {
          'token': 'jwt_token',
          'refreshToken': 'refresh_token',
          'userId': 1,
          'username': 'testuser',
          'email': 'test@example.com',
          'role': 'USER',
          'isEmailVerified': true,
        },
        'timestamp': 1704067200,
      };

      // Act
      final result = LoginResponse.fromJson(json);

      // Assert
      expect(result.success, true);
      expect(result.message, 'Login successful');
      expect(result.data, isNotNull);
      expect(result.data!.token, 'jwt_token');
      expect(result.data!.refreshToken, 'refresh_token');
      expect(result.data!.userId, 1);
    });

    test('fromJson should handle missing optional fields', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Login successful',
        'data': {
          'token': 'jwt_token',
          'refreshToken': 'refresh_token',
          'userId': 1,
          'username': 'testuser',
          'email': 'test@example.com',
        },
        'timestamp': 1704067200,
      };

      // Act
      final result = LoginResponse.fromJson(json);

      // Assert
      expect(result.data!.role, 'USER');
      expect(result.data!.isEmailVerified, false);
    });
  });

  group('ApiResponse', () {
    test('fromJson should parse successful response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Operation successful',
        'data': {'key': 'value'},
        'timestamp': 1704067200,
      };

      // Act
      final result = ApiResponse.fromJson(json);

      // Assert
      expect(result.success, true);
      expect(result.message, 'Operation successful');
      expect(result.data, isNotNull);
    });

    test('fromJson should handle error response', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Operation failed',
        'error': 'Something went wrong',
        'timestamp': 1704067200,
      };

      // Act
      final result = ApiResponse.fromJson(json);

      // Assert
      expect(result.success, false);
      expect(result.error, 'Something went wrong');
    });
  });

  group('UserInfo', () {
    test('fromJson should parse user info correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'username': 'testuser',
        'email': 'test@example.com',
        'fullName': 'Test User',
        'photoUrl': 'https://example.com/photo.jpg',
        'roles': ['USER', 'ADMIN'],
        'isEmailVerified': true,
      };

      // Act
      final result = UserInfo.fromJson(json);

      // Assert
      expect(result.id, 1);
      expect(result.username, 'testuser');
      expect(result.email, 'test@example.com');
      expect(result.fullName, 'Test User');
      expect(result.photoUrl, 'https://example.com/photo.jpg');
      expect(result.roles, ['USER', 'ADMIN']);
      expect(result.isEmailVerified, true);
    });

    test('fromJson should handle nested data structure', () {
      // Arrange
      final json = {
        'success': true,
        'data': {
          'id': 1,
          'username': 'testuser',
          'email': 'test@example.com',
          'fullName': 'Test User',
          'role': 'USER',
        },
      };

      // Act
      final result = UserInfo.fromJson(json);

      // Assert
      expect(result.id, 1);
      expect(result.username, 'testuser');
      expect(result.roles, ['USER']);
    });

    test('toJson should return correct map', () {
      // Arrange
      final userInfo = UserInfo(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        fullName: 'Test User',
        photoUrl: 'https://example.com/photo.jpg',
        roles: ['USER'],
        isEmailVerified: true,
      );

      // Act
      final result = userInfo.toJson();

      // Assert
      expect(result['id'], 1);
      expect(result['username'], 'testuser');
      expect(result['email'], 'test@example.com');
      expect(result['fullName'], 'Test User');
      expect(result['photoUrl'], 'https://example.com/photo.jpg');
      expect(result['roles'], ['USER']);
      expect(result['isEmailVerified'], true);
    });
  });

  group('RefreshTokenRequest', () {
    test('toJson should return correct map', () {
      // Arrange
      final request = RefreshTokenRequest(refreshToken: 'refresh_token_123');

      // Act
      final result = request.toJson();

      // Assert
      expect(result['refreshToken'], 'refresh_token_123');
    });
  });

  group('RefreshTokenResponse', () {
    test('fromJson should parse successful response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Token refreshed',
        'data': {
          'token': 'new_jwt_token',
          'refreshToken': 'new_refresh_token',
          'user': {'id': 1, 'username': 'testuser'},
        },
        'timestamp': 1704067200,
      };

      // Act
      final result = RefreshTokenResponse.fromJson(json);

      // Assert
      expect(result.success, true);
      expect(result.data, isNotNull);
      expect(result.data!.token, 'new_jwt_token');
      expect(result.data!.refreshToken, 'new_refresh_token');
    });
  });
}
