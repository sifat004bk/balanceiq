import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await repository.resetPassword(
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
