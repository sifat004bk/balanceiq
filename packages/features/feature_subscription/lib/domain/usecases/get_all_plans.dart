import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/plan.dart';
import '../repositories/subscription_repository.dart';

/// Use case for getting all available subscription plans
class GetAllPlans {
  final SubscriptionRepository repository;

  GetAllPlans(this.repository);

  /// Get all available plans
  Future<Either<Failure, List<Plan>>> call() async {
    return await repository.getAllPlans();
  }
}
