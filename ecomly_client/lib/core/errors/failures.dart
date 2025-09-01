import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/errors/exceptions.dart';

/// Base class for representing errors in the application domain layer.
///
/// Unlike [Exception], which is thrown in the data layer, [Failure] is returned
/// from repositories or use cases to the UI layer, making it easier to handle
/// errors in a clean and consistent way.
///
/// Each failure contains a [message] describing the error, and a [statusCode]
/// representing the error type.
///
/// Example:
///
/// ```dart
/// Future<Either<Failure, User>> getUserProfile() async {
///   try {
///     final user = await remoteDataSource.fetchUser();
///     return Right(user);
///   } on ServerException catch (e) {
///     return Left(ServerFailure.fromException(e));
///   } on CacheException catch (e) {
///     return Left(CacheFailure.fromException(e));
///   }
/// }
/// ```
sealed class Failure extends Equatable {
  /// Creates a [Failure] with the provided [message] and [statusCode].
  const Failure({required this.message, required this.statusCode});

  /// A human-readable description of the error.
  final String message;

  /// A status code representing the error type.
  ///
  /// Can be an HTTP code (for server errors) or a custom code
  /// (e.g., `3` for cache not found).
  final int statusCode;

  /// Combines the [statusCode] and [message] into a formatted error string.
  String get errorMessage => '$statusCode Error: $message';

  @override
  List<Object?> get props => [message, statusCode];
}

/// Represents a failure that occurs due to server-side issues.
///
/// Typically constructed from a [ServerException].
///
/// Example:
///
/// ```dart
/// final failure = ServerFailure.fromException(
///   ServerException(message: 'Internal Server Error', statusCode: 500),
/// );
/// print(failure.errorMessage); // "500 Error: Internal Server Error"
/// ```
class ServerFailure extends Failure {
  /// Creates a [ServerFailure] with the provided [message] and [statusCode].
  const ServerFailure({required super.message, required super.statusCode});

  /// Creates a [ServerFailure] from a [ServerException].
  ServerFailure.fromException(ServerException e)
    : this(message: e.message, statusCode: e.statusCode);
}

/// Represents a failure related to cache operations.
///
/// Typically constructed from a [CacheException].
///
/// The [statusCode] is set to `3` by default as a custom identifier
/// for cache-related errors.
///
/// Example:
///
/// ```dart
/// final failure = CacheFailure.fromException(
///   const CacheException(message: 'Cache is empty'),
/// );
/// print(failure.errorMessage); // "3 Error: Cache is empty"
/// ```
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with the provided [message]. Uses a default
  /// [statusCode] of `3`.
  const CacheFailure({required super.message}) : super(statusCode: 3);

  /// Creates a [CacheFailure] from a [CacheException].
  CacheFailure.fromException(CacheException e) : this(message: e.message);
}
