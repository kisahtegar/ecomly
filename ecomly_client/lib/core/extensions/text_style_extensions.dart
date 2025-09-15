import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';

/// An extension on [TextStyle] that provides convenient accessors
/// for commonly used theme colors in the app.
///
/// This extension simplifies applying brand-consistent colors
/// to text styles without needing to manually set [Color] values.
///
/// Example:
///
/// ```dart
/// Text(
///   'Welcome Back!',
///   style: TextStyles.headingMedium4.orange, // Applies secondary color
/// )
///
/// Text(
///   'Hello World',
///   style: TextStyles.bodySmall.adaptiveColour(context),
/// )
/// ```
extension TextStyleExt on TextStyle {
  /// Applies the light theme's secondary (orange) color.
  TextStyle get orange => copyWith(color: Colours.lightThemeSecondaryColour);

  /// Applies the light theme's primary dark text color.
  TextStyle get dark => copyWith(color: Colours.lightThemePrimaryTextColour);

  /// Applies the light theme's secondary grey text color.
  TextStyle get grey => copyWith(color: Colours.lightThemeSecondaryTextColour);

  /// Applies the light theme's white text color.
  TextStyle get white => copyWith(color: Colours.lightThemeWhiteColour);

  /// Applies the light theme's primary brand color.
  TextStyle get primary => copyWith(color: Colours.lightThemePrimaryColour);

  /// Dynamically applies either light or dark text color, depending on the
  /// current app theme.
  TextStyle adaptiveColour(BuildContext context) =>
      copyWith(color: Colours.classicAdaptiveTextColour(context));
}
