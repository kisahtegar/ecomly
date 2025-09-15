import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

/// A centered widget for displaying empty state messages.
///
/// The `EmptyData` widget is used to show placeholder messages when there's
/// no content to display, such as empty lists, search results, or data sets.
/// It presents the message in a semi-transparent, centered format that's
/// visually distinct but not overwhelming.
///
/// Features:
/// - **Centered Layout**: Message is always centered both horizontally and vertically
/// - **Styled Text**: Uses [TextStyles.headingBold] with reduced opacity for subtle appearance
/// - **Customizable Padding**: Optional padding parameter for layout control
/// - **Consistent Styling**: Uses theme-aware secondary text color
///
/// ### Example usage:
/// ```dart
/// // Simple empty message
/// const EmptyData('No products found')
///
/// // With custom padding
/// const EmptyData(
///   'Your wishlist is empty\nAdd some products to get started!',
///   padding: EdgeInsets.all(24),
/// )
/// ```
///
/// ### Common use cases:
/// - Empty shopping cart: "Your cart is empty"
/// - No search results: "No results found for '{query}'"
/// - Empty wishlist: "Your wishlist is empty"
/// - Loading states: "Loading your content..."
class EmptyData extends StatelessWidget {
  const EmptyData(this.data, {super.key, this.padding});

  /// The message to display to the user.
  ///
  /// This string can contain line breaks (`\n`) for multi-line messages.
  final String data;

  /// Optional padding around the message text.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 10)` if not provided.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyles.headingBold.copyWith(
            color: Colours.lightThemeSecondaryTextColour.withOpacity(.6),
          ),
        ),
      ),
    );
  }
}
