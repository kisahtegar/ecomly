import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:ecomly_client/core/utils/core_utils.dart';

/// A display-only widget for showing star ratings.
///
/// The `RatingStars` widget uses [RatingBarIndicator] from the flutter_rating_bar
/// package to display a read-only star rating. It shows filled amber stars for
/// the rating value and theme-adaptive colors for unrated stars.
///
/// Features:
/// - **Read-only Display**: Shows rating but doesn't allow user interaction
/// - **Fractional Ratings**: Supports decimal ratings (e.g., 4.3 stars)
/// - **Adaptive Unrated Color**: Unrated stars adapt to light/dark theme
/// - **Consistent Size**: Fixed 17px star size for uniform appearance
/// - **Amber Stars**: Uses standard amber color for filled stars
///
/// ### Example usage:
/// ```dart
/// RatingStars(4.5) // Shows 4.5 out of 5 stars
/// ```
///
/// ```dart
/// // In a product card
/// Column(
///   children: [
///     Text('Product Name'),
///     RatingStars(product.rating),
///     Text('\$${product.price}'),
///   ],
/// )
/// ```
///
/// ### Visual behavior:
/// - **Light theme**: Unrated stars appear in light yellow (`#ffeeb9`)
/// - **Dark theme**: Unrated stars appear in dark yellow (`#564411`)
/// - **Rated stars**: Always amber regardless of theme
class RatingStars extends StatelessWidget {
  const RatingStars(this.rating, {super.key});

  /// The rating value to display as stars.
  ///
  /// Should be between 0.0 and 5.0. Fractional values (e.g., 4.3) are supported
  /// and will show partial star filling.
  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) =>
          const Icon(Icons.star_rounded, color: Colors.amber),
      unratedColor: CoreUtils.adaptiveColour(
        context,
        lightModeColour: const Color(0xFFffeeb9),
        darkModeColour: const Color(0xFF564411),
      ),
      itemSize: 17,
    );
  }
}
