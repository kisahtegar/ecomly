import 'package:dartz/dartz.dart';

import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/errors/failures.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/data/datasources/user_remote_data_source.dart';
import 'package:ecomly_client/src/user/domain/repositories/user_repository.dart';

class UserRepositoryImplementation implements UserRepository {
  const UserRepositoryImplementation(this._remoteDataSrc);

  final UserRemoteDataSource _remoteDataSrc;

  @override
  ResultFuture<User> getUser(String userId) async {
    try {
      final result = await _remoteDataSrc.getUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<String> getUserPaymentProfile(String userId) async {
    try {
      final result = await _remoteDataSrc.getUserPaymentProfile(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<User> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    try {
      final result = await _remoteDataSrc.updateUser(
        userId: userId,
        updateData: updateData,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
