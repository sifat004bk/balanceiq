import 'package:shared_preferences/shared_preferences.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<void> saveAuthToken(String token);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
  Future<bool> isSignedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final SecureStorageService secureStorage;

  AuthLocalDataSourceImpl(this.sharedPreferences, this.secureStorage);

  @override
  Future<void> saveUser(UserModel user) async {
    await secureStorage.saveUserId(user.id);
    await sharedPreferences.setString(
        GetIt.instance<AppConstants>().keyUserEmail, user.email);
    await sharedPreferences.setString(
        GetIt.instance<AppConstants>().keyUserName, user.name);
    if (user.photoUrl != null) {
      await sharedPreferences.setString(
          GetIt.instance<AppConstants>().keyUserPhotoUrl, user.photoUrl!);
    }
    await sharedPreferences.setString(
        GetIt.instance<AppConstants>().keyUserAuthProvider, user.authProvider);
    await sharedPreferences.setBool(
        GetIt.instance<AppConstants>().keyIsLoggedIn, true);
    if (user.currency != null) {
      await sharedPreferences.setString(
          GetIt.instance<AppConstants>().keyUserCurrency, user.currency!);
    }
    await sharedPreferences.setBool(
        GetIt.instance<AppConstants>().keyIsEmailVerified,
        user.isEmailVerified);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await secureStorage.saveToken(token);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final isLoggedIn =
        sharedPreferences.getBool(GetIt.instance<AppConstants>().keyIsLoggedIn);
    if (isLoggedIn == true) {
      final userId = await secureStorage.getUserId();
      final email = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyUserEmail);
      final name = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyUserName);
      final photoUrl = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyUserPhotoUrl);
      final authProvider = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyUserAuthProvider);
      final currency = sharedPreferences
          .getString(GetIt.instance<AppConstants>().keyUserCurrency);
      final isEmailVerified = sharedPreferences
              .getBool(GetIt.instance<AppConstants>().keyIsEmailVerified) ??
          false;

      if (userId != null && email != null && name != null) {
        return UserModel(
          id: userId,
          email: email,
          name: name,
          photoUrl: photoUrl,
          currency: currency,
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
    await secureStorage.clearAllTokens();
    await secureStorage.delete(key: 'user_id');
    await sharedPreferences.remove(GetIt.instance<AppConstants>().keyUserEmail);
    await sharedPreferences.remove(GetIt.instance<AppConstants>().keyUserName);
    await sharedPreferences
        .remove(GetIt.instance<AppConstants>().keyUserPhotoUrl);
    await sharedPreferences
        .remove(GetIt.instance<AppConstants>().keyUserAuthProvider);
    await sharedPreferences
        .remove(GetIt.instance<AppConstants>().keyUserCurrency);
    await sharedPreferences
        .remove(GetIt.instance<AppConstants>().keyCurrencyCode);
    await sharedPreferences
        .remove(GetIt.instance<AppConstants>().keyIsEmailVerified);
    await sharedPreferences.setBool(
        GetIt.instance<AppConstants>().keyIsLoggedIn, false);
  }

  @override
  Future<bool> isSignedIn() async {
    return sharedPreferences
            .getBool(GetIt.instance<AppConstants>().keyIsLoggedIn) ??
        false;
  }
}
