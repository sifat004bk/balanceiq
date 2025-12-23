import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../repositories/auth_repository.dart';

class UpdateCurrency {
  final AuthRepository repository;

  UpdateCurrency(this.repository);

  Future<Either<Failure, void>> call(String currency) async {
    return await repository.updateCurrency(currency);
  }
}
