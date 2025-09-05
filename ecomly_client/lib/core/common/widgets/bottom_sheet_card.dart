import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

class BottomSheetCard extends StatelessWidget {
  const BottomSheetCard({
    super.key,
    required this.title,
    required this.positiveButtonText,
    required this.negativeButtonText,
    this.positiveButtonColour,
    this.negativeButtonColour,
  });

  final String title;
  final String positiveButtonText;
  final String negativeButtonText;
  final Color? positiveButtonColour;
  final Color? negativeButtonColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: CoreUtils.adaptiveColour(
          context,
          lightModeColour: Colours.lightThemeWhiteColour,
          darkModeColour: Colours.darkThemeDarkNavBarColour,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.headingMedium1.adaptiveColour(context),
            ),
          ),
          const Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: RoundedButton(
                    text: negativeButtonText,
                    backgroundColour: negativeButtonColour,
                    height: 55,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: RoundedButton(
                    text: positiveButtonText,
                    backgroundColour: positiveButtonColour,
                    height: 55,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
