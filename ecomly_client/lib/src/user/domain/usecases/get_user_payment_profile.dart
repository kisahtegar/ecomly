import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/domain/repositories/user_repository.dart';

class GetUserPaymentProfile extends FutureUsecaseWithParams<String, String> {
  const GetUserPaymentProfile(this._repo);

  final UserRepository _repo;

  @override
  ResultFuture<String> call(String params) =>
      _repo.getUserPaymentProfile(params);
}
