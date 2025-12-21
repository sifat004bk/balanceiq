import 'package:balance_iq/core/mock/mock_data.dart';
import 'package:balance_iq/core/utils/app_logger.dart';
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
    AppLogger.debug(
        'Fetching dashboard data (startDate: $startDate, endDate: $endDate)',
        name: 'MockDashboard');

    // Simulate network delay
    await _simulateNetworkDelay();

    // Get mock dashboard data (date parameters are ignored in mock mode)
    final mockData = MockData.getMockDashboardSummary(
      userId: 'mock_user',
      botId: 'balance_tracker',
    );

    AppLogger.debug('Mock dashboard data generated', name: 'MockDashboard');

    // Convert to model
    return DashboardSummaryModel.fromJson(mockData);
  }

  @override
  Future<bool> updateOnboarded(bool onboarded) async {
    AppLogger.debug('Updating onboarded status: $onboarded',
        name: 'MockDashboard');
    await _simulateNetworkDelay();
    return true;
  }
}
