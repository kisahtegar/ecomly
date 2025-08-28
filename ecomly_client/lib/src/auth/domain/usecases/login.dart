import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

class Login extends FutureUsecaseWithParams<User, LoginParams> {
  const Login(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<User> call(LoginParams params) =>
      _repo.login(email: params.email, password: params.password);
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  const LoginParams.empty() : email = 'Test String', password = 'Test String';

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
