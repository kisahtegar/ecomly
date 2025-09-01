import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

/// Use case for requesting a password reset.
///
/// Takes the user's [email] as input and triggers the password recovery flow
/// through the [AuthRepository].
class ForgotPassword extends FutureUsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
