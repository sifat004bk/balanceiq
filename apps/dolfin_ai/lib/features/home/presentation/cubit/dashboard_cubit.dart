import 'package:balance_iq/features/home/domain/usecase/get_user_dashbaord.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardSummary getDashboardSummary;

  DashboardCubit({required this.getDashboardSummary})
      : super(DashboardInitial());

  Future<void> loadDashboard({String? startDate, String? endDate}) async {
    emit(DashboardLoading());

    // Default to current month if not provided
    // This ensures explicit dates are always sent to backend, preventing "missing parameter" issues
    String? finalStartDate = startDate;
    String? finalEndDate = endDate;

    if (finalStartDate == null || finalEndDate == null) {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);

      // Basic ISO 8601 format YYYY-MM-DD
      finalStartDate =
          "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
      finalEndDate =
          "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
    }

    final result = await getDashboardSummary(
      startDate: finalStartDate,
      endDate: finalEndDate,
    );

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }

  Future<void> refreshDashboard({String? startDate, String? endDate}) =>
      loadDashboard(startDate: startDate, endDate: endDate);
}
