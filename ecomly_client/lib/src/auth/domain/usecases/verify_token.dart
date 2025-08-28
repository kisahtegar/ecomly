import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

class VerifyToken extends FutureUsecaseWithoutParams<bool> {
  const VerifyToken(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<bool> call() => _repo.verifyToken();
}
