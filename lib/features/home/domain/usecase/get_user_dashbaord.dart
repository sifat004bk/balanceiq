import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:balance_iq/features/home/domain/repository/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class GetDashboardSummary {
  final DashboardRepository repository;

  GetDashboardSummary(this.repository);

  Future<Either<Failure, DashboardSummary>> call() {
    return repository.getDashboardSummary();
  }
}
