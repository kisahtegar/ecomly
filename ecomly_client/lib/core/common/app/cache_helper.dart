import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/extensions/theme_mode_extension.dart';

/// A helper class for managing cached data using [SharedPreferences].
///
/// The [CacheHelper] class provides a clean abstraction over the [SharedPreferences]
/// API to handle persistent storage of user-related data such as session tokens,
/// user IDs, theme preferences, and onboarding flags. It also keeps the in-memory
/// [Cache] singleton in sync with stored values for faster access during runtime.
/// Using this class ensures consistent data flow between the app’s runtime
/// state and persistent storage.
class CacheHelper {
  const CacheHelper(this._prefs);

  final SharedPreferences _prefs;

  static const _sessionTokenKey = 'user-session-token';
  static const _userIdKey = 'user-id';
  static const _themeModeKey = 'theme-mode';
  static const _firstTimerKey = 'is-user-first-timer';

  /// Caches the session token both locally and in the [Cache] singleton.
  ///
  /// Returns `true` if the operation succeeds, otherwise `false`.
  Future<bool> cacheSessionToken(String token) async {
    try {
      final result = await _prefs.setString(_sessionTokenKey, token);
      Cache.instance.setSessionToken(token);
      return result;
    } catch (_) {
      return false;
    }
  }

  /// Caches the user ID both locally and in the [Cache] singleton.
  ///
  /// Returns `true` if the operation succeeds, otherwise `false`.
  Future<bool> cacheUserId(String userId) async {
    try {
      final result = await _prefs.setString(_userIdKey, userId);
      Cache.instance.setUserId(userId);
      return result;
    } catch (_) {
      return false;
    }
  }

  /// Marks the user as no longer a first-timer.
  ///
  /// This is typically called after onboarding has been completed.
  Future<void> cacheFirstTimer() async {
    await _prefs.setBool(_firstTimerKey, false);
  }

  /// Stores the [ThemeMode] preference and updates the [Cache] singleton.
  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode.stringValue);
    Cache.instance.setThemeMode(themeMode);
  }

  /// Retrieves the cached session token and updates the [Cache] singleton.
  ///
  /// Returns the token if available, otherwise `null`.
  String? getSessionToken() {
    final sessionToken = _prefs.getString(_sessionTokenKey);
    if (sessionToken case String()) {
      Cache.instance.setSessionToken(sessionToken);
    }
    return sessionToken;
  }

  /// Retrieves the cached user ID and updates the [Cache] singleton.
  ///
  /// Returns the user ID if available, otherwise `null`.
  String? getUserId() {
    final userId = _prefs.getString(_userIdKey);
    if (userId case String()) {
      Cache.instance.setUserId(userId);
    }
    return userId;
  }

  /// Retrieves the cached theme mode and updates the [Cache] singleton.
  ///
  /// Returns [ThemeMode.system] if no value is stored.
  ThemeMode getThemeMode() {
    final themeModeStringValue = _prefs.getString(_themeModeKey);
    final themeMode = themeModeStringValue?.toThemeMode ?? ThemeMode.system;
    Cache.instance.setThemeMode(themeMode);
    return themeMode;
  }

  /// Clears the /// Clears the cached session token and user ID, and resets the [Cache].
  ///
  /// Typically used during logout.cached session token and user ID, and resets the [Cache].
  ///
  /// Typically used during logout.
  Future<void> resetSession() async {
    await _prefs.remove(_sessionTokenKey);
    await _prefs.remove(_userIdKey);
    Cache.instance.resetSession();
  }

  /// Checks whether the user is opening the app for the first time.
  ///
  /// Returns `true` if the user has not completed onboarding yet.
  bool isFirstTime() => _prefs.getBool(_firstTimerKey) ?? true;
}
