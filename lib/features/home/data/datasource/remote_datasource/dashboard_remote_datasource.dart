import 'package:balance_iq/features/home/data/models/dashboard_summary_response.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary({
    required String userId,
    required String botId,
    required String firstName,
    required String lastName,
    required String username,
  });
}
