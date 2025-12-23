import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dolfin_core/constants/api_endpoints.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/error/app_exception.dart';
import 'package:dolfin_core/error/error_handler.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import '../models/auth_request_models.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  // OAuth Methods
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();

  // Backend API Methods
  Future<SignupResponse> signup(SignupRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<RefreshTokenResponse> refreshToken(String refreshToken);
  Future<UserInfo> getProfile(String token);
  Future<void> changePassword(ChangePasswordRequest request, String token);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);

  // Email Verification Methods
  Future<void> sendVerificationEmail(String token);
  Future<void> resendVerificationEmail(String email);

  // New Methods
  Future<void> updateCurrency(String currency);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  final Dio dio;
  final SecureStorageService secureStorage;

  AuthRemoteDataSourceImpl({
    required this.googleSignIn,
    required this.dio,
    required this.secureStorage,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    GoogleSignInAccount? account;
    try {
      // 1. Trigger Google Sign-In Flow
      account = await googleSignIn.signIn();

      if (account == null) {
        throw const UnknownException('Google sign in was cancelled');
      }

      // 2. Get the idToken from Google authentication
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        // Sign out so user can try with different account
        await googleSignIn.signOut();
        throw const AuthException('Failed to retrieve Google ID Token');
      }

      // 3. Send idToken to backend for verification and session creation
      final response = await dio.post(
        ApiEndpoints.googleOAuth,
        data: {'idToken': idToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final data = jsonResponse['data'];

        // Store the JWT token from backend
        if (data['token'] != null) {
          await secureStorage.saveToken(data['token']);
        }
        // Store refresh token if present
        if (data['refreshToken'] != null) {
          await secureStorage.saveRefreshToken(data['refreshToken']);
        }

        // Return user model with backend data
        return UserModel(
          id: data['userId']?.toString() ?? account.id,
          email: data['email'] ?? account.email,
          name: data['fullName'] ??
              data['username'] ??
              account.displayName ??
              'Unknown',
          photoUrl: account.photoUrl,
          authProvider: 'google',
          createdAt: DateTime.now(),
          isEmailVerified: data['isEmailVerified'] ?? true,
        );
      } else {
        // Backend failed - sign out so user can try different account
        await googleSignIn.signOut();
        throw ServerException(
            'Backend authentication failed: ${response.statusCode}',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (account != null) {
        await googleSignIn.signOut();
      }
      throw ErrorHandler.handle(e, source: 'signInWithGoogle');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Sign out from Google
      await googleSignIn.signOut();

      // Call Backend Logout API
      try {
        await logout();
      } catch (_) {
        // Ignore backend logout errors during local sign out
      }

      // Clear all cached tokens
      await secureStorage.clearAllTokens();
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'signOut');
    }
  }

  @override
  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.signup,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      return SignupResponse.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'signup');
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // Store the token in SecureStorage
      if (loginResponse.data?.token != null) {
        await secureStorage.saveToken(loginResponse.data!.token);
      }
      if (loginResponse.data?.refreshToken != null) {
        await secureStorage.saveRefreshToken(loginResponse.data!.refreshToken);
      }

      return loginResponse;
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'login');
    }
  }

  @override
  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      final refreshResponse = RefreshTokenResponse.fromJson(response.data);
      if (refreshResponse.data?.token != null) {
        await secureStorage.saveToken(refreshResponse.data!.token);
      }
      if (refreshResponse.data?.refreshToken != null) {
        await secureStorage
            .saveRefreshToken(refreshResponse.data!.refreshToken);
      }
      return refreshResponse;
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'refreshToken');
    }
  }

  @override
  Future<UserInfo> getProfile(String token) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getProfile,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );

      return UserInfo.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'getProfile');
    }
  }

  @override
  Future<void> changePassword(
      ChangePasswordRequest request, String token) async {
    try {
      await dio.post(
        ApiEndpoints.changePassword,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'changePassword');
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await dio.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'forgotPassword');
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await dio.post(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'resetPassword');
    }
  }

  @override
  Future<void> sendVerificationEmail(String token) async {
    try {
      // Note: AuthInterceptor automatically adds Authorization header from SharedPreferences
      await dio.post(
        ApiEndpoints.sendVerification,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'sendVerificationEmail');
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      await dio.post(
        ApiEndpoints.resendVerification,
        data: {'email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'resendVerificationEmail');
    }
  }

  @override
  Future<void> updateCurrency(String currency) async {
    try {
      await dio.patch(
        ApiEndpoints.updateCurrency,
        data: {'currency': currency},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'updateCurrency');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(
        ApiEndpoints.logout,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: GetIt.instance<AppConstants>().apiTimeout,
          receiveTimeout: GetIt.instance<AppConstants>().apiTimeout,
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e, source: 'logout');
    }
  }
}
