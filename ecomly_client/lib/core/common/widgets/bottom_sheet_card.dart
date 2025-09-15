import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

/// A reusable bottom sheet card widget for confirmation dialogs.
///
/// This widget creates a styled modal card with a [title] and two action buttons
/// (positive and negative) arranged horizontally. It's designed to be used within
/// a bottom sheet for user confirmations, selections, or binary choices.
///
/// Features:
/// - Adaptive theming (automatically adjusts background color for light/dark modes)
/// - Rounded corners with Material Design styling
/// - Two customizable action buttons with optional color overrides
/// - Returns `true` when positive button is pressed, `false` for negative button
/// - Automatically pops the navigation context when buttons are pressed
///
/// ### Example usage:
/// ```dart
/// showModalBottomSheet<bool>(
///   context: context,
///   builder: (context) => const BottomSheetCard(
///     title: 'Delete this item?',
///     positiveButtonText: 'Delete',
///     negativeButtonText: 'Cancel',
///     positiveButtonColour: Colors.red,
///   ),
/// ).then((result) {
///   if (result == true) {
///     // User confirmed - perform delete action
///   }
/// });
/// ```
///
/// ```dart
/// BottomSheetCard(
///   title: 'Save changes before leaving?',
///   positiveButtonText: 'Save',
///   negativeButtonText: 'Discard',
///   positiveButtonColour: Colors.green,
///   negativeButtonColour: Colors.grey,
/// );
/// ```
class BottomSheetCard extends StatelessWidget {
  const BottomSheetCard({
    super.key,
    required this.title,
    required this.positiveButtonText,
    required this.negativeButtonText,
    this.positiveButtonColour,
    this.negativeButtonColour,
  });

  /// The main message or question displayed at the top of the card.
  final String title;

  /// The text displayed on the positive action button (right side).
  ///
  /// When pressed, returns `true` to the calling context.
  final String positiveButtonText;

  /// The text displayed on the negative action button (left side).
  ///
  /// When pressed, returns `false` to the calling context.
  final String negativeButtonText;

  /// Optional background color override for the positive button.
  ///
  /// If `null`, uses the default [RoundedButton] styling.
  final Color? positiveButtonColour;

  /// Optional background color override for the negative button.
  ///
  /// If `null`, uses the default [RoundedButton] styling.
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
