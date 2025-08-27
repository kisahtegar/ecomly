import 'package:flutter/material.dart';

/// Utility extensions on [String] for the Ecomly client app.
///
/// The [StringExt] extension provides additional functionality for the `String`
/// class. Dart extensions allow you to add new methods to existing classes
/// without modifying their source code. Centralizing these operations into
/// extensions reduces repetitive code and improves readability.
extension StringExt on String {
  /// Converts the string into an authentication header map.
  ///
  /// Useful for adding a bearer token to API requests.
  ///
  /// Example:
  /// ```dart
  /// final headers = token.toAuthHeaders;
  /// ```
  Map<String, String> get toAuthHeaders {
    return {
      'Authorization': 'Bearer $this',
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  /// Converts a string into a [ThemeMode].
  ///
  /// Supported values: "light", "dark", otherwise defaults to [ThemeMode.system].
  ///
  /// Example:
  /// ```dart
  /// // Converting a string into ThemeMode
  /// final theme = "dark".toThemeMode;  // ThemeMode.dark
  /// ```
  ThemeMode get toThemeMode {
    return switch (toLowerCase()) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Obscures an email address for privacy or security purposes by partially
  /// hiding it.
  ///
  /// It splits the email address into the username and domain parts, obscures
  /// the username, and displays only the first and last characters.
  ///
  /// Example:
  /// ```dart
  /// final emailAddress = 'example.email@example.com';
  /// final obscuredEmail = emailAddress.obscureEmail;
  /// print(obscuredEmail); // Output: 'e****l@example.com'
  /// ```
  String get obscureEmail {
    // Split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    // Obscure the username and display only the first and last characters
    username = '${username[0]}****${username[username.length - 1]}';
    return '$username@$domain';
  }
}
