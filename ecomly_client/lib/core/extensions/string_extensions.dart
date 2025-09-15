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

  /// Extracts the initials from a name or phrase.
  ///
  /// Takes the first character of up to 2 words, converts them to uppercase,
  /// and returns the combined initials. Useful for creating avatar placeholders
  /// or user identification displays.
  ///
  /// ### Example:
  /// ```dart
  /// 'John Doe'.initials;           // 'JD'
  /// 'Alice'.initials;              // 'A'
  /// 'Mary Jane Watson'.initials;   // 'MJ' (only first 2 words)
  /// '   '.initials;                // '' (empty/whitespace)
  /// ''.initials;                   // '' (empty string)
  /// ```
  String get initials {
    if (isEmpty) return '';

    final words = trim().split(' ');

    String initials = '';

    for (int i = 0; i < words.length && i < 2; i++) {
      initials += words[i][0];
    }

    return initials.toUpperCase();
  }

  /// Converts a hex color string to a [Color] object.
  ///
  /// Parses a hex color string (with or without '#' prefix) and converts it
  /// to a Flutter [Color]. Automatically adds full alpha (0xFF) to ensure
  /// the color is fully opaque.
  ///
  /// ### Example:
  /// ```dart
  /// '#FF5733'.colour;    // Color(0xFFFF5733) - red-orange
  /// 'FF5733'.colour;     // Color(0xFFFF5733) - same as above
  /// '2196F3'.colour;     // Color(0xFF2196F3) - blue
  /// ```
  ///
  /// ### Expected format:
  /// - 6-digit hex string: 'RRGGBB' or '#RRGGBB'
  /// - Case insensitive
  Color get colour => Color(int.parse(replaceFirst('#', 'ff'), radix: 16));

  /// Truncates the string to a maximum length and adds ellipsis if needed.
  ///
  /// If the string length is within the [maxLength] limit, returns the original
  /// string unchanged. Otherwise, cuts the string at [maxLength] characters
  /// and appends '...' to indicate truncation.
  ///
  /// ### Example:
  /// ```dart
  /// 'This is a long text'.truncateWithEllipsis(10);  // 'This is a...'
  /// 'Short'.truncateWithEllipsis(10);                // 'Short'
  /// 'Exactly ten!'.truncateWithEllipsis(10);         // 'Exactly te...'
  /// ```
  ///
  /// ### Parameters:
  /// - [maxLength]: Maximum allowed length before truncation
  String truncateWithEllipsis(int maxLength) {
    if (length <= maxLength) {
      return this;
    } else {
      return '${substring(0, maxLength)}...';
    }
  }
}
