import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../../data/models/auth_request_models.dart';
import '../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<Either<Failure, SignupResponse>> call({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    return await repository.signup(
      username: username,
      password: password,
      fullName: fullName,
      email: email,
    );
  }
}
