import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendVerificationEmail {
  final AuthRepository repository;

  SendVerificationEmail(this.repository);

  Future<Either<Failure, void>> call({required String token}) async {
    return await repository.sendVerificationEmail(token);
  }
}
