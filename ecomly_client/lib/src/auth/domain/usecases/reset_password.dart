import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

/// Use case for resetting a user's password.
///
/// Requires [ResetPasswordParams] containing the user's email
/// and the new password. Returns `void` on success.
class ResetPassword extends FutureUsecaseWithParams<void, ResetPasswordParams> {
  const ResetPassword(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(ResetPasswordParams params) =>
      _repo.resetPassword(email: params.email, newPassword: params.newPassword);
}

/// Parameters for the [ResetPassword] use case.
class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;

  @override
  List<dynamic> get props => [email, newPassword];
}
