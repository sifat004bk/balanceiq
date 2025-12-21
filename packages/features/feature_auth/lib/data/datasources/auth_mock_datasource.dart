import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:dolfin_core/utils/app_logger.dart';
import '../models/auth_request_models.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Mock authentication data source that simulates backend API behavior
///
/// This mock implementation:
/// - Matches real API specs exactly
/// - Simulates network delays (300-800ms)
/// - Returns proper success/error responses
/// - Validates input data like the real API
/// - Stores user data in-memory for testing
/// - Works completely offline
class AuthMockDataSource implements AuthRemoteDataSource {
  final SharedPreferences sharedPreferences;
  final Uuid uuid;

  // In-memory storage for mock users
  static final Map<String, _MockUser> _users = {};
  static final Map<String, String> _resetTokens = {}; // token -> email mapping

  AuthMockDataSource({
    required this.sharedPreferences,
    required this.uuid,
  }) {
    _initializeMockUsers();
  }

  /// Initialize some test users for easy testing
  void _initializeMockUsers() {
    if (_users.isEmpty) {
      // Test user 1: Regular user (email not verified - for testing verification flow)
      _users['testuser'] = _MockUser(
        id: 'user_001',
        username: 'testuser',
        password: 'password123',
        fullName: 'Test User',
        email: 'test@example.com',
        photoUrl: null,
        roles: ['user'],
        isEmailVerified: false,
      );

      // Test user 2: Admin user (email verified)
      _users['admin'] = _MockUser(
        id: 'user_002',
        username: 'admin',
        password: 'admin123',
        fullName: 'Admin User',
        email: 'admin@balanceiq.com',
        photoUrl: null,
        roles: ['user', 'admin'],
        isEmailVerified: true,
      );

      // Test user 3: Demo user (email verified)
      _users['demo'] = _MockUser(
        id: 'user_003',
        username: 'demo',
        password: 'demo123',
        fullName: 'Demo Account',
        email: 'demo@balanceiq.com',
        photoUrl: 'https://i.pravatar.cc/150?u=demo',
        roles: ['user'],
        isEmailVerified: true,
      );
    }
  }

  /// Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(
      Duration(milliseconds: 300 + (DateTime.now().millisecond % 500)),
    );
  }

  @override
  Future<SignupResponse> signup(SignupRequest request) async {
    await _simulateDelay();

    // Validate input
    if (request.username.isEmpty || request.password.isEmpty) {
      throw Exception('Username and password are required');
    }

    if (request.password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    if (!request.email.contains('@')) {
      throw Exception('Invalid email format');
    }

    // Check if user already exists
    if (_users.containsKey(request.username)) {
      throw Exception('User already exists');
    }

    // Check if email is already registered
    for (var user in _users.values) {
      if (user.email == request.email) {
        throw Exception('Email already registered');
      }
    }

    // Create new user
    final userId = DateTime.now().millisecondsSinceEpoch % 10000;
    final newUser = _MockUser(
      id: userId.toString(),
      username: request.username,
      password: request.password,
      fullName: request.fullName,
      email: request.email,
      photoUrl: null,
      roles: ['user'],
    );

    _users[request.username] = newUser;

    // Return success response matching actual API
    return SignupResponse(
      success: true,
      message:
          'User registered successfully. Please verify your email to activate your account.',
      data: SignupData(
        id: userId,
        username: request.username,
        email: request.email,
        fullName: request.fullName,
        userRole: 'USER',
        isEmailVerified: false,
        createdAt: DateTime.now().toIso8601String(),
        isActive: true,
      ),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    await _simulateDelay();

    // Validate input
    if (request.username.isEmpty || request.password.isEmpty) {
      throw Exception('Username and password are required');
    }

    // Check if user exists
    if (!_users.containsKey(request.username)) {
      throw Exception('User not found');
    }

    final user = _users[request.username]!;

    // Check password
    if (user.password != request.password) {
      throw Exception('Invalid username or password');
    }

    // Generate mock JWT token
    final token = _generateMockToken(user.id);

    // Store token in SharedPreferences
    await sharedPreferences.setString('auth_token', token);
    await sharedPreferences.setString('user_id', user.id);
    await sharedPreferences.setString('username', user.username);

    // Return success response matching actual API
    return LoginResponse(
      success: true,
      message: 'Login successful.',
      data: LoginData(
        token: token,
        refreshToken: 'mock_refresh_token_${user.id}',
        userId: int.tryParse(user.id) ?? 0,
        username: user.username,
        email: user.email,
        role: user.roles.contains('admin') ? 'ADMIN' : 'USER',
        isEmailVerified: user.isEmailVerified,
      ),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    await _simulateDelay();

    // Validate refresh token
    if (refreshToken.isEmpty ||
        !refreshToken.startsWith('mock_refresh_token_')) {
      throw Exception('Invalid refresh token');
    }

    // Extract user ID from refresh token
    final userId = refreshToken.replaceFirst('mock_refresh_token_', '');

    // Find user
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('User not found'),
    );

    final newToken = _generateMockToken(userId);
    final newRefreshToken = 'mock_refresh_token_$userId';

    // Store token in SharedPreferences
    await sharedPreferences.setString('auth_token', newToken);
    await sharedPreferences.setString('refresh_token', newRefreshToken);

    return RefreshTokenResponse(
      success: true,
      message: 'Token refreshed successfully',
      data: RefreshTokenData(
          token: newToken,
          refreshToken: newRefreshToken,
          user: {
            "id": int.tryParse(user.id) ?? 0,
            "email": user.email,
            "username": user.username,
            "fullName": user.fullName,
            "userRole": user.roles.contains('admin') ? 'SUPER_ADMIN' : 'USER',
            "isActive": true,
            "isEmailVerified": true,
          }),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<UserInfo> getProfile(String token) async {
    await _simulateDelay();

    // Validate token
    if (token.isEmpty) {
      throw Exception('Unauthorized. Please login again.');
    }

    // Extract user ID from token (in real implementation, would verify JWT)
    final userId = _extractUserIdFromToken(token);

    // Find user
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('User not found'),
    );

    return UserInfo(
      id: int.tryParse(user.id) ?? 0,
      username: user.username,
      fullName: user.fullName,
      email: user.email,
      photoUrl: user.photoUrl,
      roles: user.roles,
      isEmailVerified: user.isEmailVerified,
    );
  }

  @override
  Future<void> changePassword(
    ChangePasswordRequest request,
    String token,
  ) async {
    await _simulateDelay();

    // Validate token
    if (token.isEmpty) {
      throw Exception('Unauthorized. Please login again.');
    }

    // Validate passwords
    if (request.newPassword != request.confirmPassword) {
      throw Exception('Passwords do not match');
    }

    if (request.newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Extract user ID from token
    final userId = _extractUserIdFromToken(token);

    // Find user
    final username = _users.entries
        .firstWhere(
          (entry) => entry.value.id == userId,
          orElse: () => throw Exception('User not found'),
        )
        .key;

    final user = _users[username]!;

    // Verify current password
    if (user.password != request.currentPassword) {
      throw Exception('Current password is incorrect');
    }

    // Update password
    _users[username] = _MockUser(
      id: user.id,
      username: user.username,
      password: request.newPassword,
      fullName: user.fullName,
      email: user.email,
      photoUrl: user.photoUrl,
      roles: user.roles,
    );
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    await _simulateDelay();

    // Validate email
    if (!request.email.contains('@')) {
      throw Exception('Invalid email format');
    }

    // Check if email exists
    final userExists = _users.values.any((user) => user.email == request.email);

    if (!userExists) {
      throw Exception('Email not found');
    }

    // Generate reset token
    final resetToken = uuid.v4();
    _resetTokens[resetToken] = request.email;

    // In real implementation, would send email
    // For mock, we'll just store the token
    AppLogger.debug('Password reset token: $resetToken', name: 'MockAuth');
    AppLogger.debug('Reset link: /reset-password?token=$resetToken',
        name: 'MockAuth');
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _simulateDelay();

    // Validate passwords
    if (request.newPassword != request.confirmPassword) {
      throw Exception('Passwords do not match');
    }

    if (request.newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Validate token
    if (!_resetTokens.containsKey(request.token)) {
      throw Exception('Invalid or expired reset token');
    }

    final email = _resetTokens[request.token]!;

    // Find user by email
    final username = _users.entries
        .firstWhere(
          (entry) => entry.value.email == email,
          orElse: () => throw Exception('User not found'),
        )
        .key;

    final user = _users[username]!;

    // Update password
    _users[username] = _MockUser(
      id: user.id,
      username: user.username,
      password: request.newPassword,
      fullName: user.fullName,
      email: user.email,
      photoUrl: user.photoUrl,
      roles: user.roles,
    );

    // Remove used token
    _resetTokens.remove(request.token);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await _simulateDelay();

    // Mock Google Sign-In
    final mockGoogleUser = UserModel(
      id: uuid.v4(),
      email: 'mockgoogle@gmail.com',
      name: 'Mock Google User',
      photoUrl: 'https://i.pravatar.cc/150?u=google',
      authProvider: 'google',
      createdAt: DateTime.now(),
    );

    // Store user in mock database
    _users['mockgoogle'] = _MockUser(
      id: mockGoogleUser.id,
      username: 'mockgoogle',
      password: '', // OAuth users don't have passwords
      fullName: mockGoogleUser.name,
      email: mockGoogleUser.email,
      photoUrl: mockGoogleUser.photoUrl,
      roles: ['user'],
    );

    return mockGoogleUser;
  }

  @override
  Future<void> signOut() async {
    await _simulateDelay();

    // Clear stored auth data
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('username');
  }

  /// Generate a mock JWT token
  String _generateMockToken(String userId) {
    // In real implementation, this would be a proper JWT
    // For mock, just create a base64-like string
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'mock_token_${userId}_$timestamp';
  }

  /// Extract user ID from mock token
  String _extractUserIdFromToken(String token) {
    // In real implementation, would decode and verify JWT
    // For mock, just extract from our format
    if (token.startsWith('mock_token_')) {
      final parts = token.split('_');
      if (parts.length >= 3) {
        return parts[2];
      }
    }
    throw Exception('Invalid token format');
  }

  @override
  Future<void> sendVerificationEmail(String token) async {
    await _simulateDelay();

    // Validate token
    if (token.isEmpty) {
      throw Exception('Unauthorized. Please login again.');
    }

    // Extract user ID from token
    final userId = _extractUserIdFromToken(token);

    // Find user
    final user = _users.values.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw Exception('User not found'),
    );

    if (user.isEmailVerified) {
      throw Exception('Email is already verified');
    }

    // In real implementation, would send email
    AppLogger.debug('Verification email sent to: ${user.email}',
        name: 'MockAuth');
    AppLogger.debug(
        'Verification link: /verify-email?token=mock_verify_${user.id}',
        name: 'MockAuth');
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    await _simulateDelay();

    // Validate email
    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    // Check if email exists
    final user = _users.values.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Email not found'),
    );

    if (user.isEmailVerified) {
      throw Exception('Email is already verified');
    }

    // In real implementation, would send email
    AppLogger.debug('Verification email resent to: $email', name: 'MockAuth');
    AppLogger.debug(
        'Verification link: /verify-email?token=mock_verify_${user.id}',
        name: 'MockAuth');
  }

  /// Clear all mock data (useful for testing)
  static void clearAllData() {
    _users.clear();
    _resetTokens.clear();
  }

  /// Get current stored users (for debugging)
  /// Returns a map of username to mock user data
  static Map<String, dynamic> getStoredUsers() {
    return _users.map((key, value) => MapEntry(key, {
          'id': value.id,
          'username': value.username,
          'email': value.email,
          'fullName': value.fullName,
          'photoUrl': value.photoUrl,
          'roles': value.roles,
        }));
  }

  /// Get reset tokens (for debugging)
  static Map<String, String> getResetTokens() {
    return Map.from(_resetTokens);
  }
}

/// Internal class to represent a mock user in memory
class _MockUser {
  final String id;
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String? photoUrl;
  final List<String> roles;
  final bool isEmailVerified;

  _MockUser({
    required this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    this.photoUrl,
    required this.roles,
    this.isEmailVerified = false,
  });

  _MockUser copyWith({
    String? id,
    String? username,
    String? password,
    String? fullName,
    String? email,
    String? photoUrl,
    List<String>? roles,
    bool? isEmailVerified,
  }) {
    return _MockUser(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      roles: roles ?? this.roles,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  String toString() {
    return 'MockUser(id: $id, username: $username, email: $email, fullName: $fullName, isEmailVerified: $isEmailVerified)';
  }
}
