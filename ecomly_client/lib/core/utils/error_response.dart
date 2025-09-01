import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/utils/typedefs.dart';

/// A model class that represents an error response returned
/// from an API or data source.
///
/// It captures both a general error message and a collection
/// of more detailed error messages, if available.
class ErrorResponse extends Equatable {
  /// Creates an [ErrorResponse] with optional [type], [message],
  /// and a list of [errorMessages].
  const ErrorResponse({this.type, this.message, this.errorMessages});

  /// Creates an [ErrorResponse] from a raw [DataMap] (decoded JSON).
  ///
  /// Expects the map to contain optional keys:
  /// - `"type"`: a string describing the error category.
  /// - `"message"`: a general error message.
  /// - `"errors"`: a list of error objects with `"message"` fields.
  ///
  /// Example JSON:
  /// ```json
  /// {
  ///   "type": "ValidationError",
  ///   "message": "Invalid input data",
  ///   "errors": [
  ///     { "message": "Email is required" },
  ///     { "message": "Password must be at least 8 characters" }
  ///   ]
  /// }
  /// ```
  factory ErrorResponse.fromMap(DataMap map) {
    var errorMessages = (map['errors'] as List?)
        ?.cast<DataMap>()
        .map((error) => error['message'] as String)
        .toList();
    if (errorMessages != null && errorMessages.isEmpty) errorMessages = null;

    return ErrorResponse(
      type: map['type'] as String?,
      message: map['message'] as String?,
      errorMessages: errorMessages,
    );
  }

  /// The category or type of error, e.g. `"ValidationError"`.
  final String? type;

  /// The main error message, usually provided by the API.
  final String? message;

  /// A list of more specific error messages, such as field-level errors.
  final List<String>? errorMessages;

  /// Builds a user-friendly error message string.
  ///
  /// - Includes [type] if available.
  /// - Falls back to [message] if present.
  /// - Otherwise, concatenates [errorMessages] with spacing.
  ///
  /// Example output:
  /// ```
  /// ValidationError
  /// Invalid input data
  ///
  /// Email is required
  ///
  /// Password must be at least 8 characters
  /// ```
  String get errorMessage {
    var payload = '';
    if (type != null) payload = '${type!}\n';
    if (message != null) {
      payload += message!;
    } else {
      if (errorMessages != null) {
        payload += '\nWhat went wrong?';
        for (final (index, message) in errorMessages!.indexed) {
          if (index == 0) {
            payload += '\n$message';
          } else {
            payload += '\n\n$message';
          }
        }
      }
    }
    return payload;
  }

  @override
  List<Object?> get props => [type, message];
}
