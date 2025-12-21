// ignore_for_file: avoid_print
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
    String? startDate,
    String? endDate,
  }) async {
    print(
        '🏠 [MockDashboard] Fetching dashboard data (startDate: $startDate, endDate: $endDate)');

    // Simulate network delay
    await _simulateNetworkDelay();

    // Get mock dashboard data (date parameters are ignored in mock mode)
    final mockData = MockData.getMockDashboardSummary(
      userId: 'mock_user',
      botId: 'balance_tracker',
    );

    print('✅ [MockDashboard] Mock dashboard data generated');

    // Convert to model
    return DashboardSummaryModel.fromJson(mockData);
  }

  @override
  Future<bool> updateOnboarded(bool onboarded) async {
    print('🏠 [MockDashboard] Updating onboarded status: $onboarded');
    await _simulateNetworkDelay();
    return true;
  }
}
