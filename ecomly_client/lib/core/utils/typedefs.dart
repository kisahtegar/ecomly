import 'package:dartz/dartz.dart';

import 'package:ecomly_client/core/errors/failures.dart';

/// A shorthand alias for a JSON-like map structure.
///
/// Commonly used when parsing API responses or
/// working with request/response payloads.
///
/// Example:
/// ```dart
/// DataMap userJson = {
///   "id": 1,
///   "name": "Alice",
/// };
/// ```
typedef DataMap = Map<String, dynamic>;

/// A standardized return type for asynchronous repository or data source methods.
///
/// - On **success**, returns a `Right<T>` containing the expected result.
/// - On **failure**, returns a `Left<Failure>` describing the error.
///
/// This enforces consistent error handling across the app by
/// leveraging the [Either] type from `dartz`.
///
/// Example:
/// ```dart
/// ResultFuture<User> getUserProfile() async {
///   try {
///     final user = await api.fetchUser();
///     return Right(user);
///   } on ServerException catch (e) {
///     return Left(ServerFailure.fromException(e));
///   }
/// }
/// ```
typedef ResultFuture<T> = Future<Either<Failure, T>>;
