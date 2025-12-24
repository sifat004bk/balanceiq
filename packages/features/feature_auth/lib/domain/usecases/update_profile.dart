import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../../data/models/auth_request_models.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, UserInfo>> call({
    String? fullName,
    String? username,
    String? email,
    String? currency,
  }) {
    return repository.updateProfile(
      fullName: fullName,
      username: username,
      email: email,
      currency: currency,
    );
  }
}
