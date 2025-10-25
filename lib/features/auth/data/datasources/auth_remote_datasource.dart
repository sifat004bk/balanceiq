import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl(this.googleSignIn);

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        throw Exception('Google sign in was cancelled');
      }

      return UserModel(
        id: account.id,
        email: account.email,
        name: account.displayName ?? 'Unknown',
        photoUrl: account.photoUrl,
        authProvider: 'google',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String name = credential.givenName != null && credential.familyName != null
          ? '${credential.givenName} ${credential.familyName}'
          : credential.email?.split('@').first ?? 'Unknown';

      return UserModel(
        id: credential.userIdentifier ?? DateTime.now().millisecondsSinceEpoch.toString(),
        email: credential.email ?? 'no-email@apple.com',
        name: name,
        authProvider: 'apple',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to sign in with Apple: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
