import 'package:balance_iq/core/mock/mock_data.dart';
import 'package:balance_iq/features/home/data/models/dashboard_summary_response.dart';
import 'dashboard_remote_datasource.dart';

/// Mock implementation of DashboardRemoteDataSource for testing without API calls
class DashboardMockDataSource implements DashboardRemoteDataSource {
  /// Simulate network delay (500-1000ms)
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(
      Duration(milliseconds: 500 + DateTime.now().millisecond % 500),
    );
  }

  @override
  Future<DashboardSummaryModel> getDashboardSummary({
    required String userId,
    required String botId,
    required String firstName,
    required String lastName,
    required String username,
  }) async {
    print('🏠 [MockDashboard] Fetching dashboard for user: $userId, bot: $botId');

    // Simulate network delay
    await _simulateNetworkDelay();

    // Get mock dashboard data
    final mockData = MockData.getMockDashboardSummary(
      userId: userId,
      botId: botId,
    );

    print('✅ [MockDashboard] Mock dashboard data generated');

    // Convert to model
    return DashboardSummaryModel.fromJson(mockData);
  }
}
