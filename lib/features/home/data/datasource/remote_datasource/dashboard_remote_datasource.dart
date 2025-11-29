import 'package:balance_iq/features/home/data/models/dashboard_summary_response.dart';

/// Remote data source for dashboard data
/// API Spec: GET /api/finance-guru/dashboard (no parameters, uses Bearer auth)
abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary();
}
