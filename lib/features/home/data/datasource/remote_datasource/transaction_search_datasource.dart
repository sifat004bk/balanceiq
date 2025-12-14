import 'package:balance_iq/core/constants/api_endpoints.dart';
import 'package:balance_iq/features/home/data/models/transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Transaction search API data source
/// Endpoint: GET /api/finance-guru/v1/transactions
/// Auth: Bearer token
abstract class TransactionSearchDataSource {
  Future<TransactionSearchResponse> searchTransactions({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit,
  });

  Future<void> updateTransaction({
    required int id,
    int? categoryId,
    String? category,
    String? type,
    double? amount,
    String? description,
    DateTime? transactionDate,
  });

  Future<void> deleteTransaction(int id);
}

/// Implementation of transaction search data source
class TransactionSearchDataSourceImpl implements TransactionSearchDataSource {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  TransactionSearchDataSourceImpl(this.dio, this.sharedPreferences);

  @override
  Future<TransactionSearchResponse> searchTransactions({
    String? search,
    String? category,
    String? type,
    String? startDate,
    String? endDate,
    double? minAmount,
    double? maxAmount,
    int? limit,
  }) async {
    try {
      // Get auth token
      final token = sharedPreferences.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      // Build query parameters
      final queryParameters = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }
      if (type != null && type.isNotEmpty) {
        queryParameters['type'] = type;
      }
      if (startDate != null) {
        queryParameters['startDate'] = startDate;
      }
      if (endDate != null) {
        queryParameters['endDate'] = endDate;
      }
      if (minAmount != null) {
        queryParameters['minAmount'] = minAmount;
      }
      if (maxAmount != null) {
        queryParameters['maxAmount'] = maxAmount;
      }
      if (limit != null) {
        queryParameters['limit'] = limit;
      }

      final response = await dio.get<Map<String, dynamic>>(
        ApiEndpoints.transactions,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
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
          throw Exception('No transaction data available');
        }

        return TransactionSearchResponse.fromJson(responseData);
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
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 400) {
        final message =
            e.response?.data?['message'] ?? 'Invalid request parameters';
        throw Exception('Bad request: $message');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('No transaction data available') ||
          e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Failed to search transactions: $e');
    }
  }

  @override
  Future<void> updateTransaction({
    required int id,
    int? categoryId,
    String? category,
    String? type,
    double? amount,
    String? description,
    DateTime? transactionDate,
  }) async {
    try {
      final token = sharedPreferences.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final data = <String, dynamic>{};
      if (categoryId != null) data['categoryId'] = categoryId;
      if (category != null) data['category'] = category;
      if (type != null) data['type'] = type;
      if (amount != null) data['amount'] = amount;
      if (description != null) data['description'] = description;
      if (transactionDate != null) {
        data['transactionDate'] = transactionDate.toIso8601String();
      }

      final response = await dio.patch(
        '${ApiEndpoints.transactions}/$id',
        data: data,
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    try {
      final token = sharedPreferences.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication required. Please login.');
      }

      final response = await dio.delete(
        '${ApiEndpoints.transactions}/$id',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
