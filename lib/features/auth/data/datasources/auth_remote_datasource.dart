import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/api_endpoints.dart';
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
        ApiEndpoints.signup,
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
        ApiEndpoints.login,
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
        if (loginResponse.data?.refreshToken != null) {
           await sharedPreferences.setString('refresh_token', loginResponse.data!.refreshToken);
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
  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        final refreshResponse = RefreshTokenResponse.fromJson(response.data);
         if (refreshResponse.data?.token != null) {
          await sharedPreferences.setString('auth_token', refreshResponse.data!.token);
        }
        if (refreshResponse.data?.refreshToken != null) {
           await sharedPreferences.setString('refresh_token', refreshResponse.data!.refreshToken);
        }
        return refreshResponse;
      } else {
        throw Exception('Refresh token failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
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
        ApiEndpoints.changePassword,
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
        ApiEndpoints.forgotPassword,
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
        ApiEndpoints.resetPassword,
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

  @override
  Future<void> sendVerificationEmail(String token) async {
    try {
      // Note: AuthInterceptor automatically adds Authorization header from SharedPreferences
      final response = await dio.post(
        ApiEndpoints.sendVerification,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to send verification email: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final message = e.response?.data is Map
            ? e.response?.data['message']
            : e.response?.data?.toString();
        throw Exception(message ?? 'Failed to send verification email');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail(String email) async {
    try {
      final response = await dio.post(
        ApiEndpoints.resendVerification,
        data: {'email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to resend verification email: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Email not found');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Email is already verified');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to resend verification email: $e');
    }
  }
}
