import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
