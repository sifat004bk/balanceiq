import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummary>> getDashboardSummary({
    String? startDate,
    String? endDate,
  });
}
