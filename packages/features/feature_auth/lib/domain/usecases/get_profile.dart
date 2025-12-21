import 'package:dartz/dartz.dart';
import 'package:dolfin_core/error/failures.dart';
import '../../data/models/auth_request_models.dart';
import '../repositories/auth_repository.dart';

class GetProfile {
  final AuthRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, UserInfo>> call(String token) async {
    return await repository.getProfile(token);
  }
}
