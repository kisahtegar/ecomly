import 'package:dartz/dartz.dart';

import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/errors/failures.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] using a remote data source.
///
/// This class communicates with [AuthRemoteDataSource] to handle authentication-related
/// operations such as login, registration, password reset, and token verification.
///
/// Any [ServerException] thrown by the data source is caught and converted into a
/// [ServerFailure] to ensure consistent error handling across the app.
class AuthRepositoryImplementation implements AuthRepository {
  const AuthRepositoryImplementation(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  /// Sends a password reset request for the given [email].
  ///
  /// Returns:
  /// - [Right(void)] if the operation succeeds.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<void> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Attempts to log in a user with [email] and [password].
  ///
  /// Returns:
  /// - [Right(User)] containing user data if successful.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Registers a new user with the provided [name], [email], [phone], and [password].
  ///
  /// Returns:
  /// - [Right(void)] if the registration is successful.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<void> register({
    required String name,
    required String password,
    required String email,
    required String phone,
  }) async {
    try {
      await _remoteDataSource.register(
        name: name,
        password: password,
        email: email,
        phone: phone,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Resets the password for the user with the given [email].
  ///
  /// The password will be updated to [newPassword].
  ///
  /// Returns:
  /// - [Right(void)] if the reset is successful.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Verifies the provided [otp] for the given [email].
  ///
  /// Returns:
  /// - [Right(void)] if the OTP is valid.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<void> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOTP(email: email, otp: otp);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  /// Verifies whether the current authentication token is valid.
  ///
  /// Returns:
  /// - [Right(true)] if the token is valid.
  /// - [Right(false)] if the token is invalid.
  /// - [Left(ServerFailure)] if a [ServerException] occurs.
  @override
  ResultFuture<bool> verifyToken() async {
    try {
      final result = await _remoteDataSource.verifyToken();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
