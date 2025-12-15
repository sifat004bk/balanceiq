import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
  Future<bool> isSignedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(AppConstants.keyUserId, user.id);
    await sharedPreferences.setString(AppConstants.keyUserEmail, user.email);
    await sharedPreferences.setString(AppConstants.keyUserName, user.name);
    if (user.photoUrl != null) {
      await sharedPreferences.setString(AppConstants.keyUserPhotoUrl, user.photoUrl!);
    }
    await sharedPreferences.setString(AppConstants.keyUserAuthProvider, user.authProvider);
    await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, true);
    await sharedPreferences.setBool(AppConstants.keyIsEmailVerified, user.isEmailVerified);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final isLoggedIn = sharedPreferences.getBool(AppConstants.keyIsLoggedIn);
    if (isLoggedIn == true) {
      final userId = sharedPreferences.getString(AppConstants.keyUserId);
      final email = sharedPreferences.getString(AppConstants.keyUserEmail);
      final name = sharedPreferences.getString(AppConstants.keyUserName);
      final photoUrl = sharedPreferences.getString(AppConstants.keyUserPhotoUrl);
      final authProvider = sharedPreferences.getString(AppConstants.keyUserAuthProvider);
      final isEmailVerified = sharedPreferences.getBool(AppConstants.keyIsEmailVerified) ?? false;

      if (userId != null && email != null && name != null) {
        return UserModel(
          id: userId,
          email: email,
          name: name,
          photoUrl: photoUrl,
          authProvider: authProvider ?? 'google',
          createdAt: DateTime.now(),
          isEmailVerified: isEmailVerified,
        );
      }
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(AppConstants.keyUserId);
    await sharedPreferences.remove(AppConstants.keyUserEmail);
    await sharedPreferences.remove(AppConstants.keyUserName);
    await sharedPreferences.remove(AppConstants.keyUserPhotoUrl);
    await sharedPreferences.remove(AppConstants.keyUserAuthProvider);
    await sharedPreferences.remove(AppConstants.keyIsEmailVerified);
    await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, false);
  }

  @override
  Future<bool> isSignedIn() async {
    return sharedPreferences.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }
}
