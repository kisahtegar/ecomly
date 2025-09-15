import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/widgets/favourite_icon.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/presentation/widgets/colour_palette.dart';

/// A tile widget representing a product in the **Home screen**.
///
/// Displays:
/// - Product image with a [FavouriteIcon] overlay
/// - Product name (truncated if too long)
/// - Price
/// - Available colour swatches (up to 3)
/// - Rating (with star icon)
///
/// Navigates to the product details page when tapped.
///
/// ### Example:
/// ```dart
/// HomeProductTile(
///   product,
///   margin: EdgeInsets.only(right: 16),
/// )
/// ```
class HomeProductTile extends StatelessWidget {
  const HomeProductTile(this.product, {super.key, this.margin});

  /// The product entity containing details to display.
  final Product product;

  /// Optional margin around the tile (useful in horizontal lists).
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/products/${product.id}'), // Product details
      child: Container(
        width: 196,
        margin: margin,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: Colours.lightThemeWhiteColour,
            darkModeColour: Colours.darkThemeDarkSharpColour,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image + favourite button overlay
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 131,
                    width: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: FavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),

            // Product name + colour swatches
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name.truncateWithEllipsis(12),
                    style: TextStyles.headingMedium4.adaptiveColour(context),
                  ),
                  if (product.colours.isNotEmpty)
                    Flexible(
                      child: ColourPalette(
                        colours: product.colours.take(3).toList(),
                        radius: 5,
                      ),
                    ),
                ],
              ),
            ),

            // Price + rating
            Padding(
              padding: const EdgeInsets.all(5).copyWith(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyles.paragraphSubTextRegular3.orange,
                  ),
                  const Gap(6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colours.lightThemeYellowColour,
                        size: 11,
                      ),
                      const Gap(3),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyles.paragraphSubTextRegular2
                            .adaptiveColour(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
