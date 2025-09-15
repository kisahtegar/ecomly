import 'package:dartz/dartz.dart';

import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/errors/failures.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/data/datasources/user_remote_data_source.dart';
import 'package:ecomly_client/src/user/domain/repositories/user_repository.dart';

/// Implementation of [UserRepository] using a remote data source.
///
/// This class communicates with [UserRemoteDataSource] to perform user-related
/// operations such as fetching user details, updating user information, and
/// retrieving payment profiles. Errors from the remote source are caught and
/// converted into [ServerFailure] to maintain a consistent failure handling
/// mechanism.
class UserRepositoryImplementation implements UserRepository {
  const UserRepositoryImplementation(this._remoteDataSrc);

  final UserRemoteDataSource _remoteDataSrc;

  /// Fetches a [User] by [userId].
  ///
  /// Returns:
  /// - [Right(User)] if successful.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<User> getUser(String userId) async {
    try {
      final result = await _remoteDataSrc.getUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Fetches the payment profile ID associated with a user.
  ///
  /// Returns:
  /// - [Right(String)] containing the payment profile ID if successful.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<String> getUserPaymentProfile(String userId) async {
    try {
      final result = await _remoteDataSrc.getUserPaymentProfile(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Updates a [User] with the given [updateData].
  ///
  /// Returns:
  /// - [Right(User)] with updated data if successful.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
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
