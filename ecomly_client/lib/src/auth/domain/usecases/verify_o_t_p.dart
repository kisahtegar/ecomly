import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

class VerifyOTP extends FutureUsecaseWithParams<void, VerifyOTPParams> {
  const VerifyOTP(this._repo);

  final AuthRepository _repo;

  @override
  ResultFuture<void> call(VerifyOTPParams params) =>
      _repo.verifyOTP(email: params.email, otp: params.otp);
}

class VerifyOTPParams extends Equatable {
  const VerifyOTPParams({required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  List<dynamic> get props => [email, otp];
}
