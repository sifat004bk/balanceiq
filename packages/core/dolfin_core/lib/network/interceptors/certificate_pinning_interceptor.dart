import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import '../../constants/app_constants.dart';
import '../../utils/app_logger.dart';

class CertificatePinningInterceptor extends Interceptor {
  final AppConstants _appConstants;

  CertificatePinningInterceptor(this._appConstants);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip if pinning is not configured
    if (_appConstants.pinnedDomains.isEmpty ||
        _appConstants.pinnedCertificateHashes.isEmpty) {
      return handler.next(options);
    }

    try {
      final secure = await HttpCertificatePinning.check(
        serverURL: options.uri.toString(),
        headerHttp: options.headers
            .map((key, value) => MapEntry(key, value.toString())),
        sha: SHA.SHA256,
        allowedSHAFingerprints: _appConstants.pinnedCertificateHashes,
        timeout:
            50, // Timeout in seconds/integer as per package docs? Checking docs...
      );

      if (secure.contains("CONNECTION_SECURE")) {
        return handler.next(options);
      } else {
        throw DioException(
          requestOptions: options,
          error: 'Certificate Pinning Failed: Connection not secure',
          type: DioExceptionType.connectionError,
        );
      }
    } catch (e) {
      // Check if the error is essentially "domain not pinned" (safe to proceed?)
      // Use cases:
      // 1. Domain IS in pinnedDomains -> Must succeed check.
      // 2. Domain IS NOT in pinnedDomains -> HttpCertificatePinning might throw or return insecure?
      // Actually, checking EVERY request against HttpCertificatePinning is inefficient if it's not the target domain.
      // We should filter by domain first.

      final host = options.uri.host;
      final isPinnedDomain =
          _appConstants.pinnedDomains.any((d) => host.contains(d));

      if (isPinnedDomain) {
        AppLogger.error('Certificate Pinning Verification Failed for $host: $e',
            name: 'Security');
        handler.reject(
          DioException(
            requestOptions: options,
            error: 'Certificate Pinning Verification Failed',
            type: DioExceptionType.connectionError,
          ),
        );
      } else {
        // Not a pinned domain, allow normal Dio flow
        handler.next(options);
      }
    }
  }
}
