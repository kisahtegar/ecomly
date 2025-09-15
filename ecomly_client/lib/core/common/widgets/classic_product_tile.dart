import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/widgets/favourite_icon.dart';
import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/presentation/widgets/colour_palette.dart';

/// A tile widget for displaying product information in a grid layout.
///
/// The `ClassicProductTile` presents a [Product] in a compact, visually appealing
/// format suitable for product listing pages. It displays the product's image,
/// name, description, price, available colors, and a favorite toggle button.
///
/// Features:
/// - **Product Image**: Network image with 228px height and rounded corners
/// - **Favorite Button**: Positioned overlay that allows users to add/remove from wishlist
/// - **Product Name**: Truncated to 15 characters with ellipsis if longer
/// - **Description**: Limited to 2 lines with text overflow handling
/// - **Price**: Formatted as currency with orange styling
/// - **Color Palette**: Shows up to 3 available product colors as small circles
/// - **Navigation**: Tappable area that navigates to product detail page
/// - **Responsive Width**: Automatically sized to half screen width minus padding
///
/// The tile is designed for use in `GridView` or similar layouts where products
/// need to be displayed in a compact, scannable format.
///
/// ### Example usage:
/// ```dart
/// GridView.builder(
///   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2,
///     childAspectRatio: 0.6,
///   ),
///   itemCount: products.length,
///   itemBuilder: (context, index) {
///     return ClassicProductTile(products[index]);
///   },
/// )
/// ```
///
/// ### Navigation:
/// When tapped, navigates to `/products/{productId}` using GoRouter.
class ClassicProductTile extends StatelessWidget {
  const ClassicProductTile(this.product, {super.key});

  /// The [Product] entity containing all the information to display.
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/products/${product.id}'),
      child: Container(
        width: (context.width / 2) - 30,
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 228,
                  width: (context.width / 2) - 30,
                  decoration: BoxDecoration(
                    color: const Color(0xfff0f0f0),
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: NetworkImage(product.image)),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: FavouriteIcon(productId: product.id),
                ),
              ],
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.all(5).copyWith(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.truncateWithEllipsis(15),
                    maxLines: 1,
                    style: TextStyles.headingMedium4.adaptiveColour(context),
                  ),
                  const Gap(2),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.paragraphSubTextRegular2.grey,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyles.paragraphSubTextRegular3.orange,
                      ),
                      const Gap(6),
                      Flexible(
                        child: ColourPalette(
                          colours: product.colours.take(3).toList(),
                          radius: 5,
                        ),
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
