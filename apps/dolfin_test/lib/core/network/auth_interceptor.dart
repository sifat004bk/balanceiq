import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:feature_auth/data/models/auth_request_models.dart';
import "package:dolfin_core/constants/api_endpoints.dart";
import "package:dolfin_core/constants/app_constants.dart";
import '../navigation/navigator_service.dart';
import "package:dolfin_core/storage/secure_storage_service.dart";
import "package:dolfin_core/utils/app_logger.dart";

class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;
  final Dio dio;

  bool _isRefreshing = false;

  AuthInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      AppLogger.debug('🔐 Request: ${options.method} ${options.path}',
          name: 'AuthInterceptor');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      AppLogger.debug(
          '🔐 Error: ${err.response?.statusCode} for ${err.requestOptions.path}',
          name: 'AuthInterceptor');
    }

    if (err.response?.statusCode == 401 && !_isRefreshing) {
      final requestPath = err.requestOptions.path;
      if (requestPath.contains('/auth/login') ||
          requestPath.contains('/auth/signup') ||
          requestPath.contains('/auth/refresh-token')) {
        return handler.next(err);
      }

      _isRefreshing = true;

      try {
        final tokenDio = Dio();
        tokenDio.options.headers['Content-Type'] = 'application/json';
        tokenDio.options.sendTimeout =
            GetIt.instance<AppConstants>().apiTimeout;
        tokenDio.options.receiveTimeout =
            GetIt.instance<AppConstants>().apiTimeout;

        final refreshToken = await secureStorage.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          await _handleRefreshFailure();
          return handler.reject(err);
        }

        final response = await tokenDio.post(
          ApiEndpoints.refreshToken,
          data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
        );

        if (response.statusCode == 200) {
          final refreshResponse = RefreshTokenResponse.fromJson(response.data);

          if (refreshResponse.success && refreshResponse.data != null) {
            await secureStorage.saveToken(refreshResponse.data!.token);
            await secureStorage
                .saveRefreshToken(refreshResponse.data!.refreshToken);

            _isRefreshing = false;

            final opts = err.requestOptions;
            opts.headers['Authorization'] =
                'Bearer ${refreshResponse.data!.token}';

            final retryDio = Dio();
            retryDio.options.baseUrl = dio.options.baseUrl;

            final requestUrl =
                opts.path.startsWith('http') ? opts.path : opts.uri.toString();

            final clonedRequest = await retryDio.request(
              requestUrl,
              options: Options(
                method: opts.method,
                headers: opts.headers,
                contentType: opts.contentType,
                responseType: opts.responseType,
              ),
              data: opts.data,
              queryParameters: opts.queryParameters,
            );

            return handler.resolve(clonedRequest);
          }
        }

        _isRefreshing = false;
        await _handleRefreshFailure();
        return handler.reject(err);
      } catch (e) {
        _isRefreshing = false;
        await _handleRefreshFailure();
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  Future<void> _handleRefreshFailure() async {
    await secureStorage.clearAllTokens();
    await secureStorage.delete(key: 'user_id');
    navigateToLogin(
        errorMessage: 'Your session has expired. Please log in again.');
  }
}
