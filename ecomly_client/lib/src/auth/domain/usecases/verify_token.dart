import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

/// Use case for verifying the current authentication token.
///
/// Returns a [bool] indicating whether the stored token is still valid
/// according to the [AuthRepository].
class VerifyToken extends FutureUsecaseWithoutParams<bool> {
  const VerifyToken(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<bool> call() => _repo.verifyToken();
}
