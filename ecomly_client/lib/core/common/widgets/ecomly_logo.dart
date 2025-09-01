import 'package:flutter/material.dart';

import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

/// A reusable widget for displaying the **Ecomly brand logo** as styled text.
///
/// By default, it renders:
/// - `"Ecom"` in [TextStyles.appLogo.white].
/// - `"ly"` in [Colours.lightThemeSecondaryColour].
///
/// You can override the base text style via [style].
///
/// This widget is purely typographic (text-based) rather than an image asset,
/// making it adaptive to themes and scalable with font sizes.
///
/// Example usage:
/// ```dart
/// const EcomlyLogo(); // Default style
///
/// const EcomlyLogo(
///   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
/// );
/// ```
class EcomlyLogo extends StatelessWidget {
  const EcomlyLogo({super.key, this.style});

  /// The base [TextStyle] applied to the `"Ecom"` part of the logo.
  ///
  /// If `null`, defaults to [TextStyles.appLogo.white].
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Ecom',
        style: style ?? TextStyles.appLogo.white,
        children: const [
          TextSpan(
            text: 'ly',
            style: TextStyle(color: Colours.lightThemeSecondaryColour),
          ),
        ],
      ),
    );
  }
}
