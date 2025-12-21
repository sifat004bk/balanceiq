import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:dartz/dartz.dart';

import 'package:dolfin_core/error/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummary>> getDashboardSummary({
    String? startDate,
    String? endDate,
  });
}
