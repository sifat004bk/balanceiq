import 'package:dolfin_core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';

import '../models/plan_dto.dart';
import '../models/subscription_dto.dart';
import '../models/create_subscription_request.dart';

/// Subscription API data source
/// Endpoints:
/// - GET /api/plans (Get All Plans)
/// - GET /api/subscriptions/status (Get Subscription Status)
/// - POST /api/subscriptions/ (Create Subscription)
/// Auth: Bearer token
abstract class SubscriptionDataSource {
  /// Get all available subscription plans
  Future<List<PlanDto>> getAllPlans();

  /// Get subscription status for authenticated user
  Future<SubscriptionStatusDto> getSubscriptionStatus();

  /// Create a new subscription
  Future<SubscriptionDto> createSubscription(CreateSubscriptionRequest request);
}

/// Implementation of subscription data source
class SubscriptionDataSourceImpl implements SubscriptionDataSource {
  final Dio dio;
  final SecureStorageService secureStorage;

  SubscriptionDataSourceImpl(this.dio, this.secureStorage);

  @override
  Future<List<PlanDto>> getAllPlans() async {
    try {
      final token = await secureStorage.getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final response = await dio.get<List<dynamic>>(
        ApiEndpoints.allPlans,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          return [];
        }

        return responseData
            .map((json) => PlanDto.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Failed to load plans: $e');
    }
  }

  @override
  Future<SubscriptionStatusDto> getSubscriptionStatus() async {
    try {
      final token = await secureStorage.getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.subscriptionStatus,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          return SubscriptionStatusDto(hasActiveSubscription: false);
        }

        return SubscriptionStatusDto.fromJson(responseData);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Failed to get subscription status: $e');
    }
  }

  @override
  Future<SubscriptionDto> createSubscription(
      CreateSubscriptionRequest request) async {
    try {
      final token = await secureStorage.getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final response = await dio.post<Map<String, dynamic>>(
        ApiEndpoints.createSubscription,
        data: request.toJson(),
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        if (responseData == null) {
          throw Exception('No subscription data returned');
        }

        return SubscriptionDto.fromJson(responseData);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } catch (e) {
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Conflict') ||
          e.toString().contains('already exists')) {
        rethrow;
      }
      throw Exception('Failed to create subscription: $e');
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception(
          'Connection timeout. Please check your internet connection.');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception(
          'Server is taking too long to respond. Please try again.');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('No internet connection. Please check your network.');
    } else if (e.response?.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else if (e.response?.statusCode == 403) {
      throw Exception('Access denied. You do not have permission.');
    } else if (e.response?.statusCode == 404) {
      throw Exception('Resource not found.');
    } else if (e.response?.statusCode == 409) {
      final message =
          e.response?.data?['message'] ?? 'Active subscription already exists';
      throw Exception('Conflict: $message');
    } else if (e.response?.statusCode == 400) {
      final message = e.response?.data?['message'] ?? 'Invalid request';
      throw Exception('Bad request: $message');
    } else if (e.response?.statusCode == 500) {
      throw Exception('Server error. Please try again later.');
    }
    throw Exception('Network error: ${e.message}');
  }
}
