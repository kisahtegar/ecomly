import 'package:flutter/material.dart';

import 'package:ecomly_client/core/common/widgets/bottom_sheet_card.dart';

/// Provides helper methods for cart-related operations.
abstract class CartUtils {
  /// Displays a confirmation bottom sheet before deleting an item.
  ///
  /// Shows a modal bottom sheet with a message asking the user if they are sure
  /// they want to remove an item from the cart.
  ///
  /// ### Parameters:
  /// - [context]: The build context used to display the modal.
  /// - [message]: (Optional) A custom confirmation message. Defaults to
  ///   `"Are you sure you want to remove this item?"`.
  ///
  /// ### Returns:
  /// A [Future<bool>] that resolves to:
  /// - `true` if the user confirms removal.
  /// - `false` if the user cancels or dismisses the bottom sheet.
  ///
  /// ### Example:
  /// ```dart
  /// final shouldDelete = await CartUtils.verifyDeletion(context);
  /// if (shouldDelete) {
  ///   // Proceed with removing the item
  /// }
  /// ```
  static Future<bool> verifyDeletion(
    BuildContext context, {
    String? message,
  }) async {
    final finalMessage =
        message ?? 'Are you sure you want to remove this item?';
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isDismissible: false,
      builder: (_) {
        return BottomSheetCard(
          title: finalMessage,
          positiveButtonText: 'Remove',
          negativeButtonText: 'Cancel',
          positiveButtonColour: Colors.red,
        );
      },
    );

    return result ?? false;
  }
}
