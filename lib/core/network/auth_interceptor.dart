import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/data/models/auth_request_models.dart';
import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';
import '../navigation/navigator_service.dart';
import '../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;
  final Dio dio; // This should be the main Dio instance to retry the request

  // Flag to prevent infinite refresh loops
  bool _isRefreshing = false;

  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add the access token to the header if available
    final token = await secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      print('🔐 [AuthInterceptor] Request: ${options.method} ${options.path}');
      print('🔐 [AuthInterceptor] Has token: ${token != null}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
          '🔐 [AuthInterceptor] Error: ${err.response?.statusCode} for ${err.requestOptions.path}');
    }

    // Only handle 401 errors and prevent infinite refresh loops
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      // Skip refresh for auth endpoints to prevent loops
      final requestPath = err.requestOptions.path;
      if (requestPath.contains('/auth/login') ||
          requestPath.contains('/auth/signup') ||
          requestPath.contains('/auth/refresh-token')) {
        if (kDebugMode) {
          print(
              '🔐 [AuthInterceptor] Skipping refresh for auth endpoint: $requestPath');
        }
        return handler.next(err);
      }

      final refreshToken = await secureStorage.getRefreshToken();

      if (kDebugMode) {
        print('🔐 [AuthInterceptor] Got 401, attempting token refresh...');
        print(
            '🔐 [AuthInterceptor] Has refresh token: ${refreshToken != null}');
      }

      if (refreshToken != null && refreshToken.isNotEmpty) {
        _isRefreshing = true;

        try {
          // Create a new Dio instance to avoid circular dependency and interceptor loops
          final tokenDio = Dio();
          tokenDio.options.headers['Content-Type'] = 'application/json';
          tokenDio.options.sendTimeout = AppConstants.apiTimeout;
          tokenDio.options.receiveTimeout = AppConstants.apiTimeout;

          if (kDebugMode) {
            print(
                '🔐 [AuthInterceptor] Calling refresh token endpoint: ${ApiEndpoints.refreshToken}');
          }

          final response = await tokenDio.post(
            ApiEndpoints.refreshToken,
            data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
          );

          if (kDebugMode) {
            print(
                '🔐 [AuthInterceptor] Refresh response status: ${response.statusCode}');
            print(
                '🔐 [AuthInterceptor] Refresh response data: ${response.data}');
          }

          if (response.statusCode == 200) {
            final refreshResponse =
                RefreshTokenResponse.fromJson(response.data);

            if (refreshResponse.success && refreshResponse.data != null) {
              if (kDebugMode) {
                print(
                    '🔐 [AuthInterceptor] Token refresh successful! Updating tokens...');
              }

              // Update the stored tokens
              if (refreshResponse.data != null) {
                await secureStorage.saveToken(refreshResponse.data!.token);
                await secureStorage
                    .saveRefreshToken(refreshResponse.data!.refreshToken);
              }

              _isRefreshing = false;

              // Retry the original request with the new token
              final opts = err.requestOptions;
              opts.headers['Authorization'] =
                  'Bearer ${refreshResponse.data!.token}';

              if (kDebugMode) {
                print(
                    '🔐 [AuthInterceptor] Retrying original request: ${opts.method} ${opts.path}');
              }

              // Use a fresh Dio without the interceptor to avoid loops
              final retryDio = Dio();
              retryDio.options.baseUrl = dio.options.baseUrl;

              // Determine the URL to use - if path is already absolute, use it directly
              final requestUrl = opts.path.startsWith('http')
                  ? opts.path
                  : opts.uri.toString();

              final clonedRequest = await retryDio.request(
                requestUrl,
                options: Options(
                  method: opts.method,
                  headers: opts.headers,
                  contentType: opts.contentType,
                  responseType: opts.responseType,
                  followRedirects: opts.followRedirects,
                  validateStatus: opts.validateStatus,
                  receiveTimeout: opts.receiveTimeout,
                  sendTimeout: opts.sendTimeout,
                  extra: opts.extra,
                ),
                data: opts.data,
                queryParameters: opts.queryParameters,
              );

              return handler.resolve(clonedRequest);
            } else {
              if (kDebugMode) {
                print(
                    '🔐 [AuthInterceptor] Refresh response unsuccessful: ${refreshResponse.message}');
              }
              // Refresh response indicated failure
              _isRefreshing = false;
              await _handleRefreshFailure();
              return handler.reject(err);
            }
          }

          // If we get here, refresh was unsuccessful (non-200)
          if (kDebugMode) {
            print(
                '🔐 [AuthInterceptor] Refresh returned non-200 status: ${response.statusCode}');
          }
          _isRefreshing = false;
          await _handleRefreshFailure();
          return handler.reject(err);
        } catch (e) {
          // Refresh failed, clear tokens and navigate to login
          _isRefreshing = false;
          if (kDebugMode) {
            print(
                '🔐 [AuthInterceptor] Token refresh failed with exception: $e');
          }
          await _handleRefreshFailure();
          return handler.reject(err);
        }
      } else {
        // No refresh token available, navigate to login
        if (kDebugMode) {
          print(
              '🔐 [AuthInterceptor] No refresh token available, redirecting to login');
        }
        await _handleRefreshFailure();
        return handler.reject(err);
      }
    }

    // For non-401 errors, pass through
    return handler.next(err);
  }

  /// Handles token refresh failure by clearing tokens and navigating to login
  Future<void> _handleRefreshFailure() async {
    // Clear stored tokens
    await secureStorage.clearAllTokens();
    await secureStorage.delete(key: 'user_id');

    if (kDebugMode) {
      print(
          '🔐 [AuthInterceptor] Session expired. Tokens cleared. Navigating to login screen.');
    }

    // Navigate to login screen with error message
    navigateToLogin(
        errorMessage: 'Your session has expired. Please log in again.');
  }
}
