import 'package:flutter/material.dart';

/// Global cache manager for session data and theme preferences in the Ecomly app.
///
/// This singleton provides a centralized way to:
/// - Store and retrieve **authentication data** (session token & user ID).
/// - Manage the **application theme mode** with a reactive [ValueNotifier].
///
/// Keeping this logic in one place avoids prop-drilling, simplifies state
/// management, and ensures consistency across the app.
///
/// ### Example:
/// ```dart
/// // Access the cache instance
/// final cache = Cache.instance;
///
/// // Save authentication info
/// cache.setSessionToken("abc123");
/// cache.setUserId("user_42");
///
/// // Read authentication info
/// print(cache.sessionToken); // "abc123"
/// print(cache.userId);       // "user_42"
/// ```
class Cache {
  /// Private constructor to enforce the singleton pattern.
  Cache._internal();

  /// The single global instance of [Cache].
  static final Cache instance = Cache._internal();

  String? _sessionToken;
  String? _userId;

  /// Reactive theme mode notifier for controlling app appearance.
  final themeModeNotifier = ValueNotifier(ThemeMode.system);

  /// Returns the current session token, or `null` if not set.
  String? get sessionToken => _sessionToken;

  /// Returns the current user ID, or `null` if not set.
  String? get userId => _userId;

  /// Updates the session token if it has changed.
  void setSessionToken(String? newToken) {
    if (_sessionToken != newToken) _sessionToken = newToken;
  }

  /// Updates the user ID if it has changed.
  void setUserId(String? userId) {
    if (_userId != userId) _userId = userId;
  }

  /// Updates the current theme mode.
  void setThemeMode(ThemeMode themeMode) {
    if (themeModeNotifier.value != themeMode) {
      themeModeNotifier.value = themeMode;
    }
  }

  /// Resets the session by clearing [sessionToken] and [userId].
  void resetSession() {
    setSessionToken(null);
    setUserId(null);
  }
}
