import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../network/auth_interceptor.dart';
import '../../network/logging_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:dolfin_core/utils/app_logger.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/network/interceptors/certificate_pinning_interceptor.dart';

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

    // Add Retry Interceptor
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: (message) => AppLogger.info(message, name: 'RetryInterceptor'),
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ));

    // Add AuthInterceptor
    dio.interceptors.add(AuthInterceptor(
      secureStorage: sl(),
      dio: dio,
    ));

    // Add Certificate Pinning Interceptor
    // sl<AppConstants>() must be registered in CoreModule or similar.
    // Assuming AppConstants is available via sl()
    dio.interceptors.add(CertificatePinningInterceptor(
      sl<AppConstants>(),
    ));

    return dio;
  });
}
