import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../network/auth_interceptor.dart';
import '../../network/logging_interceptor.dart';

void registerNetworkModule(GetIt sl) {
  // Configure Dio with logging interceptor (only logs in debug mode)
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // Add logging interceptor - only logs in debug mode, no logs in release
    dio.interceptors.add(LoggingInterceptor());

    // Add AuthInterceptor - Instantiate directly to pass the dio instance and avoid circular dependency
    dio.interceptors.add(AuthInterceptor(
      secureStorage: sl(),
      dio: dio,
    ));

    return dio;
  });
}
