import 'package:balance_iq/core/constants/api_endpoints.dart';
import 'package:balance_iq/features/home/data/models/dashboard_summary_response.dart';
import 'package:dio/dio.dart';
import '../../../../../core/storage/secure_storage_service.dart';
import 'dashboard_remote_datasource.dart';

/// Finance Guru Dashboard API implementation based on Postman API Collection spec
/// Endpoint: GET /api/finance-guru/v1/dashboard
/// Auth: Bearer token (from SecureStorage)
/// Optional query parameters: startDate, endDate (YYYY-MM-DD format)
class DashboardFinanceGuruDataSource implements DashboardRemoteDataSource {
  final Dio dio;
  final SecureStorageService secureStorage;

  DashboardFinanceGuruDataSource(this.dio, this.secureStorage);

  @override
  Future<DashboardSummaryModel> getDashboardSummary({
    String? startDate,
    String? endDate,
  }) async {
    try {
      // Get auth token if available
      final token = await secureStorage.getToken();

      // Build query parameters
      final queryParameters = <String, dynamic>{};
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }

      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.dashboard,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Type-safe null check
        if (responseData == null) {
          throw Exception('No dashboard data available');
        }

        // The finance-guru API might return the data directly or nested
        // Handle both formats
        Map<String, dynamic> dashboardData;

        if (responseData.containsKey('data')) {
          // Data is nested
          final dynamic dataField = responseData['data'];

          if (dataField == null) {
            throw Exception('No dashboard data available');
          }

          if (dataField is Map<String, dynamic>) {
            dashboardData = dataField;
          } else if (dataField is List && dataField.isNotEmpty) {
            // Handle list format
            final firstItem = dataField.first;
            if (firstItem is! Map<String, dynamic>) {
              throw Exception(
                  'Invalid dashboard data format: expected Map<String, dynamic>');
            }
            dashboardData = firstItem;
          } else {
            throw Exception('Invalid dashboard data format');
          }
        } else {
          // Data is returned directly
          dashboardData = responseData;
        }

        return DashboardSummaryModel.fromJson(dashboardData);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Server is taking too long to respond. Please try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection. Please check your network.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Service not found. Please contact support.');
      } else if (e.response?.statusCode == 500) {
        final message =
            e.response?.data?['message'] ?? e.response?.data?['error'];
        throw Exception(
            'Server error: ${message ?? 'Please try again later.'}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      // Re-throw our custom exceptions
      if (e.toString().contains('No dashboard data available')) {
        rethrow;
      }
      throw Exception('Failed to load dashboard: $e');
    }
  }

  /// Update the onboarding status via PATCH /api/finance-guru/v1/dashboard/onboarded
  @override
  Future<bool> updateOnboarded(bool onboarded) async {
    try {
      final token = await secureStorage.getToken();

      final response = await dio.patch<Map<String, dynamic>>(
        '${ApiEndpoints.dashboard}/onboarded',
        data: {'onboarded': onboarded},
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        return response.data?['onboarded'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
