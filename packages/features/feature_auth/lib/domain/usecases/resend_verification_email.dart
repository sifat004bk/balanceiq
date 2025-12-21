import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationEmail {
  final AuthRepository repository;

  ResendVerificationEmail(this.repository);

  Future<Either<Failure, void>> call({required String email}) async {
    return await repository.resendVerificationEmail(email);
  }
}
