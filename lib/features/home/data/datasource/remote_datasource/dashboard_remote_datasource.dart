import 'package:balance_iq/core/constants/app_constants.dart';
import 'package:balance_iq/features/home/data/models/dashboard_summary_response.dart';
import 'package:dio/dio.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary({
    required String userId,
    required String botId,
    required String firstName,
    required String lastName,
    required String username,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<DashboardSummaryModel> getDashboardSummary({
    required String userId,
    required String botId,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        AppConstants.n8nDashboardUrl,
        data: <String, String>{
          'user_id': userId, // Fixed: Use actual userId parameter
          'bot_id': botId,
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
        },
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'authorization': 'Dolphin D#-#{Oo"|tC[fHDBpCjwhBfrY?O-56s64R|S,b8D-41eRLd8',
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

        // Type-safe extraction of data field
        final dynamic dataField = responseData['data'];

        // Handle null or empty data
        if (dataField == null) {
          throw Exception('No dashboard data available');
        }

        // Type-safe list handling
        if (dataField is! List) {
          throw Exception('Invalid dashboard data format: expected List');
        }

        if (dataField.isEmpty) {
          throw Exception('No dashboard data available');
        }

        // Type-safe map extraction
        final firstItem = dataField.first;
        if (firstItem is! Map<String, dynamic>) {
          throw Exception(
              'Invalid dashboard data format: expected Map<String, dynamic>');
        }

        return DashboardSummaryModel.fromJson(firstItem);
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
        throw Exception('Server error. Please try again later.');
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
}
