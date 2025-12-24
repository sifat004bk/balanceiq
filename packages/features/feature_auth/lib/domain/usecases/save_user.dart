import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SaveUser {
  final AuthRepository repository;

  SaveUser(this.repository);

  Future<Either<Failure, void>> call(User user) async {
    return await repository.saveUser(user);
  }
}
