import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/subscription_status.dart';
import '../repositories/subscription_repository.dart';

/// Use case for getting subscription status
class GetSubscriptionStatus {
  final SubscriptionRepository repository;

  GetSubscriptionStatus(this.repository);

  /// Get subscription status for authenticated user
  Future<Either<Failure, SubscriptionStatus>> call() async {
    return await repository.getSubscriptionStatus();
  }
}
