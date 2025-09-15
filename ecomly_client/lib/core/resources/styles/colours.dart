import 'package:flutter/material.dart';

import 'package:ecomly_client/core/utils/core_utils.dart';

/// Centralized color palette for the Ecomly client app.
///
/// The [Colours] class defines a collection of color constants used across both
/// light and dark themes of the application. By centralizing all color values in
/// one place, it ensures consistency in the design system, improves maintainability,
/// and makes it easier to tweak or extend the app’s theme.
///
/// This class also provides utility methods such as [classicAdaptiveTextColour]
/// to dynamically resolve colors based on the current theme context.
///
/// ### Example:
/// ```dart
/// // Using a color constant
/// Container(color: Colours.lightThemePrimaryColour);
///
/// // Using an adaptive color
/// final adaptiveTextColor = Colours.classicAdaptiveTextColour(context);
/// ```
abstract class Colours {
  /// Primary tint for the light theme.
  static const Color lightThemePrimaryTint = Color(0xff9e9cdc);

  /// Main primary color for the light theme.
  static const Color lightThemePrimaryColour = Color(0xff524eb7);

  /// Secondary accent color for the light theme.
  static const Color lightThemeSecondaryColour = Color(0xfff76631);

  /// Primary text color in the light theme.
  static const Color lightThemePrimaryTextColour = Color(0xff282344);

  /// Secondary text color in the light theme.
  static const Color lightThemeSecondaryTextColour = Color(0xff9491a1);

  /// Pink accent color for the light theme.
  static const Color lightThemePinkColour = Color(0xfff08e98);

  /// White color swatch for the light theme.
  static const Color lightThemeWhiteColour = Color(0xffffffff);

  /// Background tint stock color for the light theme.
  static const Color lightThemeTintStockColour = Color(0xfff6f6f9);

  /// Yellow accent color for the light theme.
  static const Color lightThemeYellowColour = Color(0xfffec613);

  /// Stock (neutral) color for the light theme.
  static const Color lightThemeStockColour = Color(0xffe4e4e9);

  /// Sharp dark tone used in the dark theme.
  static const Color darkThemeDarkSharpColour = Color(0xff191821);

  /// Background dark tone for the dark theme.
  static const Color darkThemeBGDark = Color(0xff0e0d11);

  /// Dark navigation bar color for the dark theme.
  static const Color darkThemeDarkNavBarColour = Color(0xff201f27);

  /// Returns an adaptive text color depending on the current theme mode.
  ///
  /// - In light mode, this resolves to [lightThemePrimaryTextColour].
  /// - In dark mode, this resolves to [lightThemeWhiteColour].
  static Color classicAdaptiveTextColour(BuildContext context) =>
      CoreUtils.adaptiveColour(
        context,
        lightModeColour: lightThemePrimaryTextColour,
        darkModeColour: lightThemeWhiteColour,
      );
}
