import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteTransaction(id);
  }
}
