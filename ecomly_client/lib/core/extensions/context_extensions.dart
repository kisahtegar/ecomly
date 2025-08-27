import 'package:flutter/material.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';

/// Convenient extensions on [BuildContext] for the Ecomly client app.
///
/// This extension centralizes common UI utilities to make widget building
/// more concise and readable. It provides quick access to theme data,
/// screen dimensions, and media queries, while also handling dark mode
/// and light mode detection based on the user’s preference stored in
/// [Cache]. By reducing boilerplate calls such as `MediaQuery.of(context)`
/// or `Theme.of(context)`, it helps keep UI code clean and maintainable.
///
/// ### Example:
/// ```dart
/// Widget build(BuildContext context) {
///   return Container(
///     height: context.height * 0.3,   // 30% of screen height
///     width: context.width * 0.5,     // 50% of screen width
///     color: context.isDarkMode
///         ? Colors.black
///         : Colors.white,
///     child: Text(
///       "Hello, Ecomly!",
///       style: context.theme.textTheme.titleLarge,
///     ),
///   );
/// }
/// ```
extension ContextExt on BuildContext {
  /// Returns the [ThemeData] associated with the current context.
  ThemeData get theme => Theme.of(this);

  /// Returns the [MediaQueryData] associated with the current context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the full screen [Size].
  Size get size => MediaQuery.sizeOf(this);

  /// Returns the current screen height.
  double get height => size.height;

  /// Returns the current screen width.
  double get width => size.width;

  /// Returns `true` if the app is currently in dark mode.
  ///
  /// - Respects [Cache.themeModeNotifier].
  /// - Falls back to system brightness when `ThemeMode.system` is active.
  bool get isDarkMode {
    return switch (Cache.instance.themeModeNotifier.value) {
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(this) == Brightness.dark,
      ThemeMode.dark => true,
      _ => false,
    };
  }

  /// Returns `true` if the app is currently in light mode.
  bool get isLightMode => !isDarkMode;
}
