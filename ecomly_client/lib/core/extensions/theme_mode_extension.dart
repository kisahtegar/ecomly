import 'package:flutter/material.dart';

/// Utility extensions on [ThemeMode] for the Ecomly client app.
///
/// The [ThemeModeExt] extension adds functionality to the [ThemeMode] enum,
/// allowing conversion into a string representation. This is particularly
/// useful when persisting theme preferences to storage or sending them
/// to an API.
extension ThemeModeExt on ThemeMode {
  /// Returns the string representation of the [ThemeMode].
  ///
  /// - [ThemeMode.light] → `"light"`
  /// - [ThemeMode.dark] → `"dark"`
  /// - [ThemeMode.system] → `"system"`
  ///
  /// ### Example:
  /// ```dart
  /// final theme = ThemeMode.dark;
  /// print(theme.stringValue); // Output: "dark"
  /// ```
  String get stringValue {
    return switch (this) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
  }
}
