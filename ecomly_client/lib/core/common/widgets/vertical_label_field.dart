import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/widgets/input_field.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

/// A form field widget with a vertical label above an [InputField].
///
/// The `VerticalLabelField` is commonly used in forms where each input requires
/// a descriptive label placed on top of the input field. It supports flexible
/// customization, including optional prefix widgets, suffix icons, validation,
/// and input formatting.
///
/// Example:
///
/// ```dart
/// VerticalLabelField(
///   label: 'Email Address',
///   controller: emailController,
///   hintText: 'Enter your email',
///   keyboardType: TextInputType.emailAddress,
///   validator: (value) {
///     if (value == null || value.isEmpty) return 'Email is required';
///     return null;
///   },
/// )
/// ```
class VerticalLabelField extends StatelessWidget {
  const VerticalLabelField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.defaultValidation = true,
    this.enabled = true,
    this.readOnly = false,
    this.mainFieldFlex = 1,
    this.prefixFlex = 1,
    super.key,
    this.suffixIcon,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.contentPadding,
    this.prefixIcon,
    this.focusNode,
  });

  /// The label text displayed above the input field.
  final String label;

  /// An optional suffix widget (e.g., an icon button) shown inside the field.
  final Widget? suffixIcon;

  /// A placeholder text displayed when the field is empty.
  final String? hintText;

  /// A custom validator function for the input field.
  ///
  /// If [defaultValidation] is `true`, built-in validation may also apply.
  final String? Function(String? value)? validator;

  /// Controller used to read and manipulate the input text.
  final TextEditingController controller;

  /// The type of keyboard to display for the input.
  final TextInputType? keyboardType;

  /// Whether the input text should be obscured (e.g., for passwords).
  final bool obscureText;

  /// Enables built-in validation in addition to [validator].
  final bool defaultValidation;

  /// List of input formatters applied to the field.
  final List<TextInputFormatter>? inputFormatters;

  /// An optional prefix widget (e.g., a country flag in a phone field).
  ///
  /// Displayed to the left of the input field.
  final Widget? prefix;

  /// Whether the field is enabled for editing.
  final bool enabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Custom padding inside the input field.
  final EdgeInsetsGeometry? contentPadding;

  /// An optional prefix icon displayed inside the field.
  final Widget? prefixIcon;

  /// Controls the focus state of the input field.
  final FocusNode? focusNode;

  /// Defines how much space the main input field takes relative to [prefix].
  final int mainFieldFlex;

  /// Defines how much space the [prefix] takes relative to the input field.
  final int prefixFlex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.headingMedium4.adaptiveColour(context)),
        const Gap(10),
        Row(
          children: [
            if (prefix != null) ...[
              Expanded(flex: prefixFlex, child: prefix!),
              const Gap(8),
            ],
            Expanded(
              flex: mainFieldFlex,
              child: InputField(
                controller: controller,
                focusNode: focusNode,
                suffixIcon: suffixIcon,
                hintText: hintText,
                validator: validator,
                keyboardType: keyboardType,
                obscureText: obscureText,
                defaultValidation: defaultValidation,
                inputFormatters: inputFormatters,
                enabled: enabled,
                readOnly: readOnly,
                contentPadding: contentPadding,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
