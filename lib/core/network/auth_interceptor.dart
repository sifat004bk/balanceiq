import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/models/auth_request_models.dart';
import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;
  final Dio dio; // This should be the main Dio instance to retry the request

  AuthInterceptor({
    required this.sharedPreferences,
    required this.dio,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add the access token to the header if available
    final token = sharedPreferences.getString('auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If the error is 401, try to refresh the token
      final refreshToken = sharedPreferences.getString('refresh_token');

      if (refreshToken != null) {
        try {
          // Create a new Dio instance to avoid circular dependency and interceptor loops
          final tokenDio = Dio();
          tokenDio.options.headers['Content-Type'] = 'application/json';
           tokenDio.options.sendTimeout = AppConstants.apiTimeout;
          tokenDio.options.receiveTimeout = AppConstants.apiTimeout;

          final response = await tokenDio.post(
            ApiEndpoints.refreshToken,
            data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
          );

          if (response.statusCode == 200) {
            final refreshResponse = RefreshTokenResponse.fromJson(response.data);

            if (refreshResponse.data != null) {
              // Update the stored tokens
              await sharedPreferences.setString(
                  'auth_token', refreshResponse.data!.token);
              await sharedPreferences.setString(
                  'refresh_token', refreshResponse.data!.refreshToken);

              // Retry the original request with the new token
              final opts = err.requestOptions;
              opts.headers['Authorization'] =
                  'Bearer ${refreshResponse.data!.token}';
              
              final clonedRequest = await dio.request(
                opts.path,
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
            }
          }
        } catch (e) {
          // Refresh failed, proceed with error
          // Optionally clear tokens here if refresh fails?
           await sharedPreferences.remove('auth_token');
           await sharedPreferences.remove('refresh_token');
        }
      }
    }
    handler.next(err);
  }
}
