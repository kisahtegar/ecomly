import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

class OTPFields extends StatelessWidget {
  const OTPFields({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      appContext: context,
      autoFocus: true,
      length: 4,
      dialogConfig: DialogConfig(
        dialogContent: 'Do you want to paste ',
        dialogTitle: 'Paste OTP',
      ),
      textStyle: TextStyles.headingMedium1.copyWith(
        fontWeight: FontWeight.bold,
        color: Colours.classicAdaptiveTextColour(context),
      ),
      pinTheme: PinTheme(
        inactiveColor: const Color(0xFFEEEEEE),
        selectedColor: context.theme.primaryColor,
        activeColor: context.theme.primaryColor,
        shape: PinCodeFieldShape.box,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 59,
        fieldWidth: 86,
        activeFillColor: const Color(0xFFFAFBFA),
        inactiveFillColor: const Color(0xFFFAFBFA),
      ),
      onChanged: (_) {},
      onCompleted: (pin) => controller.text = pin,
      beforeTextPaste: (value) {
        return value != null &&
            value.isNotEmpty &&
            value.length == 4 &&
            int.tryParse(value) != null;
      },
    );
  }
}
