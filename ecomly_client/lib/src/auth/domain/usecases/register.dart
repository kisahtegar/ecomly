import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

class Register extends FutureUsecaseWithParams<void, RegisterParams> {
  const Register(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(RegisterParams params) => _repo.register(
    name: params.name,
    password: params.password,
    email: params.email,
    phone: params.phone,
  );
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
  });

  final String name;
  final String password;
  final String email;
  final String phone;

  @override
  List<dynamic> get props => [name, password, email, phone];
}
