import 'package:equatable/equatable.dart';

/// Exception thrown when a server-related error occurs.
///
/// The [ServerException] is typically used in data sources or repositories to
/// represent API errors. It contains an error [message] and the HTTP [statusCode]
/// returned by the server.
///
/// Example:
///
/// ```dart
/// try {
///   final response = await apiClient.getData();
///   if (response.statusCode != 200) {
///     throw ServerException(
///       message: 'Failed to load data',
///       statusCode: response.statusCode,
///     );
///   }
/// } on ServerException catch (e) {
///   print('Server error: ${e.message} (code: ${e.statusCode})');
/// }
/// ```
class ServerException extends Equatable implements Exception {
  /// Creates a [ServerException] with the provided [message] and [statusCode].
  const ServerException({required this.message, required this.statusCode});

  /// A description of the server error.
  final String message;

  /// The HTTP status code returned by the server.
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Exception thrown when a local cache operation fails.
///
/// The [CacheException] is commonly used in data sources to indicate that cached
/// data could not be retrieved, parsed, or stored.
///
/// Example:
///
/// ```dart
/// try {
///   final cachedData = cacheManager.read('user_profile');
///   if (cachedData == null) {
///     throw const CacheException(message: 'No cached data available');
///   }
/// } on CacheException catch (e) {
///   print('Cache error: ${e.message}');
/// }
/// ```
class CacheException extends Equatable implements Exception {
  /// Creates a [CacheException] with the provided [message].
  const CacheException({required this.message});

  /// A description of the cache error.
  final String message;

  @override
  List<Object?> get props => [message];
}
