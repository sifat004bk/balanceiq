import 'package:balance_iq/features/home/data/models/dashboard_summary_response.dart';

/// Remote data source for dashboard data
/// API Spec: GET /api/finance-guru/v1/dashboard
/// Optional query parameters: startDate, endDate (YYYY-MM-DD format)
/// Auth: Bearer token
abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary({
    String? startDate,
    String? endDate,
  });

  /// Update the onboarding status
  Future<bool> updateOnboarded(bool onboarded);
}
