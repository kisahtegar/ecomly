import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

/// A reusable styled [TextFormField] for consistent input handling across the app.
///
/// Features:
/// - Built-in **default validation** (`Required Field`) with optional custom validator.
/// - Supports `enabled`, `readOnly`, and `expandable` (multi-line) modes.
/// - Automatically adapts **text color** and **background fill color** to light/dark themes.
///
/// Example usage:
/// ```dart
/// InputField(
///   controller: _emailController,
///   hintText: 'Enter your email',
///   keyboardType: TextInputType.emailAddress,
///   validator: (value) {
///     if (value == null || !value.contains('@')) {
///       return 'Enter a valid email';
///     }
///     return null;
///   },
/// );
///
/// InputField(
///   controller: _passwordController,
///   hintText: 'Password',
///   obscureText: true,
///   suffixIcon: Icon(Icons.visibility_off),
/// );
/// ```
class InputField extends StatelessWidget {
  const InputField({
    required this.controller,
    this.obscureText = false,
    this.defaultValidation = true,
    this.enabled = true,
    this.readOnly = false,
    this.expandable = false,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.contentPadding,
    this.prefixIcon,
    this.focusNode,
    this.onTap,
    this.suffixIconConstraints,
    super.key,
  });

  /// Controller that manages the text being edited.
  final TextEditingController controller;

  /// If true, hides the text being entered (e.g., for passwords).
  final bool obscureText;

  /// If true, applies a default validator (`Required Field`).
  /// If false, only [validator] is used.
  final bool defaultValidation;

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the field is read-only (still focusable if [onTap] is provided).
  final bool readOnly;

  /// Expands input field into multi-line (1–5 lines).
  final bool expandable;

  /// Optional placeholder text.
  final String? hintText;

  /// Optional validator override.
  final String? Function(String? value)? validator;

  /// Type of keyboard to use for the field.
  final TextInputType? keyboardType;

  /// Input formatters for restricting/modifying input.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional widget to show before the text (not inside the border).
  final Widget? prefix;

  /// Optional widget inside the border at the start.
  final Widget? prefixIcon;

  /// Optional widget inside the border at the end.
  final Widget? suffixIcon;

  /// Constraints for the suffix icon size.
  final BoxConstraints? suffixIconConstraints;

  /// Custom padding for the text content.
  final EdgeInsetsGeometry? contentPadding;

  /// Optional [FocusNode] for focus control.
  final FocusNode? focusNode;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: expandable ? 5 : 1,
      minLines: expandable ? 1 : null,
      style: TextStyles.paragraphSubTextRegular3.adaptiveColour(context),
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: context.theme.primaryColor),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: TextStyles.paragraphSubTextRegular3.grey,
        suffixIconConstraints: suffixIconConstraints,
        suffixIconColor: Colours.lightThemeSecondaryTextColour,
        prefix: prefix,
        prefixIcon: prefixIcon,
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        filled: true,
        fillColor: CoreUtils.adaptiveColour(
          context,
          lightModeColour: Colours.lightThemeStockColour,
          darkModeColour: Colours.darkThemeDarkSharpColour,
        ),
      ),
      inputFormatters: inputFormatters,
      validator: defaultValidation
          ? (value) {
              if (value == null || value.isEmpty) return 'Required Field';
              return validator?.call(value);
            }
          : validator,
    );
  }
}
