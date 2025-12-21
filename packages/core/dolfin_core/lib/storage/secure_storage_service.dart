abstract class SecureStorageService {
  /// Reads a value from secure storage
  Future<String?> read({required String key});

  /// Writes a value to secure storage
  Future<void> write({required String key, required String value});

  /// Deletes a value from secure storage
  Future<void> delete({required String key});

  /// Deletes all values from secure storage
  Future<void> deleteAll();

  // Typed helpers for specific keys
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearAllTokens();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
}
