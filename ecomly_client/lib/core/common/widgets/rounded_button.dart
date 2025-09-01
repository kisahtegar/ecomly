import 'package:flutter/material.dart';

import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

/// A custom rounded button widget built on top of [FilledButton].
///
/// The `RoundedButton` provides a consistent design with rounded corners,
/// optional background color, padding, and text style. It also automatically
/// dismisses the keyboard before executing the [onPressed] callback.
///
/// Example:
///
/// ```dart
/// RoundedButton(
///   text: 'Login',
///   backgroundColour: Colors.blue,
///   onPressed: () {
///     // Handle login action
///   },
/// )
/// ```
class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    super.key,
    this.onPressed,
    this.height,
    this.padding,
    this.textStyle,
    this.backgroundColour,
  });

  /// Callback executed when the button is pressed.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The text displayed inside the button.
  final String text;

  /// The height of the button. Defaults to `66`.
  final double? height;

  /// Padding applied inside the button.
  final EdgeInsetsGeometry? padding;

  /// Custom text style for the button label.
  ///
  /// Defaults to [TextStyles.buttonTextHeadingSemiBold.white].
  final TextStyle? textStyle;

  /// The background color of the button.
  ///
  /// If null, the default [FilledButton] color is used.
  final Color? backgroundColour;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 66,
      width: double.maxFinite,
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: backgroundColour,
          padding: padding,
        ),
        onPressed: () {
          // Ensure keyboard is dismissed before action.
          FocusManager.instance.primaryFocus?.unfocus();
          onPressed?.call();
        },
        child: Text(
          text,
          style: textStyle ?? TextStyles.buttonTextHeadingSemiBold.white,
        ),
      ),
    );
  }
}
