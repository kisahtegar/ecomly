import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.controller,
    this.obscureText = false,
    this.defaultValidation = true,
    this.enabled = true,
    this.readOnly = false,
    this.expandable = false,
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
    this.onTap,
    this.suffixIconConstraints,
  });

  final Widget? suffixIcon;
  final String? hintText;
  final String? Function(String? value)? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool defaultValidation;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool enabled;
  final bool readOnly;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool expandable;
  final BoxConstraints? suffixIconConstraints;

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
        suffixIconConstraints: suffixIconConstraints,
        hintStyle: TextStyles.paragraphSubTextRegular3.grey,
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
