import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

/// Use case for authenticating a user with email and password.
///
/// Returns a [User] entity on success.
class Login extends FutureUsecaseWithParams<User, LoginParams> {
  const Login(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<User> call(LoginParams params) =>
      _repo.login(email: params.email, password: params.password);
}

/// Parameters required for the [Login] use case.
class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  /// Factory constructor for testing with default values.
  const LoginParams.empty() : email = 'Test String', password = 'Test String';

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
