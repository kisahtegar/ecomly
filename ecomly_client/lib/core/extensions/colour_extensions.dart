import 'dart:ui';

/// Utility extensions on [Color] for color format conversions.
///
/// The [ColourExtensions] extension provides additional functionality for the `Color`
/// class.
extension ColourExtensions on Color {
  /// Converts the color to a hexadecimal string representation.
  ///
  /// Returns a 6-character hex string in the format `#RRGGBB` (without alpha channel).
  /// Each RGB component is converted from the 0.0-1.0 float range to 0-255 integer
  /// range, then formatted as a 2-digit hexadecimal value with leading zeros.
  ///
  /// ### Example usage:
  /// ```dart
  /// final red = Color(0xFFFF0000);
  /// print(red.hex); // "#ff0000"
  ///
  /// final blue = Colors.blue;
  /// print(blue.hex); // "#2196f3"
  ///
  /// final customColor = Color.fromRGBO(128, 64, 192, 1.0);
  /// print(customColor.hex); // "#8040c0"
  /// ```
  ///
  /// ### Use cases:
  /// - Storing color preferences in SharedPreferences or databases
  /// - Sending color data to REST APIs
  /// - Displaying color values in debug screens
  /// - Converting Flutter colors for web/CSS usage
  ///
  /// ### Returns:
  /// A string in format `#RRGGBB` where each component is a 2-digit lowercase hex value.
  String get hex {
    // Convert color to hex string format using non-deprecated API
    // Format as #RRGGBB (6 characters, no alpha)
    final int red = (r * 255).round();
    final int green = (g * 255).round();
    final int blue = (b * 255).round();
    return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
}
