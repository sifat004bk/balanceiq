import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/auth_request_models.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  // OAuth Methods
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();

  // Backend API Methods
  Future<SignupResponse> signup(SignupRequest request);
  Future<LoginResponse> login(LoginRequest request);
  Future<UserInfo> getProfile(String token);
  Future<void> changePassword(ChangePasswordRequest request, String token);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  final Dio dio;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.googleSignIn,
    required this.dio,
    required this.sharedPreferences,
  });

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
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<SignupResponse> signup(SignupRequest request) async {
    try {
      final response = await dio.post(
        '${AppConstants.backendBaseUrl}/api/auth/signup',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SignupResponse.fromJson(response.data);
      } else {
        throw Exception('Signup failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
            e.response?.data['message'] ?? 'Invalid signup data');
      } else if (e.response?.statusCode == 409) {
        throw Exception('User already exists');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to signup: $e');
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        '${AppConstants.backendBaseUrl}/api/auth/login',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Store the token in SharedPreferences
        if (loginResponse.data?.token != null) {
          await sharedPreferences.setString('auth_token', loginResponse.data!.token);
        }

        return loginResponse;
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<UserInfo> getProfile(String token) async {
    try {
      final response = await dio.get(
        '${AppConstants.backendBaseUrl}/api/auth/me',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return UserInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to get profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<void> changePassword(
      ChangePasswordRequest request, String token) async {
    try {
      final response = await dio.post(
        '${AppConstants.backendBaseUrl}/api/auth/change-password',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
            e.response?.data['message'] ?? 'Invalid password data');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Current password is incorrect');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await dio.post(
        '${AppConstants.backendBaseUrl}/api/auth/forgot-password',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to send reset email: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Email not found');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to send reset email: $e');
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await dio.post(
        '${AppConstants.backendBaseUrl}/api/auth/reset-password',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Invalid reset token');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}
