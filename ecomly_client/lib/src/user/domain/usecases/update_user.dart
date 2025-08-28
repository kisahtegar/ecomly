import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/domain/repositories/user_repository.dart';

class UpdateUser extends FutureUsecaseWithParams<User, UpdateUserParams> {
  const UpdateUser(this._repo);

  final UserRepository _repo;

  @override
  ResultFuture<User> call(UpdateUserParams params) =>
      _repo.updateUser(userId: params.userId, updateData: params.updateData);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.userId, required this.updateData});

  final String userId;
  final DataMap updateData;

  @override
  List<Object?> get props => [userId, updateData];
}
