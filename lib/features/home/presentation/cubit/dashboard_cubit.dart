import 'package:balance_iq/features/home/domain/usecase/get_user_dashbaord.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardSummary getDashboardSummary;

  DashboardCubit({required this.getDashboardSummary})
      : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());

    final result = await getDashboardSummary();

    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }

  Future<void> refreshDashboard() => loadDashboard();
}
