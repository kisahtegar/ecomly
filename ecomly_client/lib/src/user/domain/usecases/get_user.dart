import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/domain/repositories/user_repository.dart';

class GetUser extends FutureUsecaseWithParams<User, String> {
  const GetUser(this._repo);

  final UserRepository _repo;

  @override
  ResultFuture<User> call(String params) => _repo.getUser(params);
}
