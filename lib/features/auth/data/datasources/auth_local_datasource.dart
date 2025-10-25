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
    await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, true);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final isLoggedIn = sharedPreferences.getBool(AppConstants.keyIsLoggedIn);
    if (isLoggedIn == true) {
      final userId = sharedPreferences.getString(AppConstants.keyUserId);
      final email = sharedPreferences.getString(AppConstants.keyUserEmail);
      final name = sharedPreferences.getString(AppConstants.keyUserName);

      if (userId != null && email != null && name != null) {
        return UserModel(
          id: userId,
          email: email,
          name: name,
          authProvider: 'google', // Default, should be stored if needed
          createdAt: DateTime.now(),
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
    await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, false);
  }

  @override
  Future<bool> isSignedIn() async {
    return sharedPreferences.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }
}
