import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/bottom_sheet_card.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/cart/data/models/cart_product_model.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:ecomly_client/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:ecomly_client/src/wishlist/presentation/app/adapter/wishlist_provider.dart';

/// A widget that displays a single product in the user's wishlist.
///
/// Provides options to:
/// - Navigate to the product detail page.
/// - Remove the product from the wishlist.
/// - Add the product to the shopping cart (if in stock).
///
/// Handles product availability states:
/// - **Normal product** → Can be added to cart or opened in detail page.
/// - **Out of stock** → Shows "OUT OF STOCK".
/// - **Deleted product** → Shows "REMOVE" option with greyed-out styling.
class WishlistProductTile extends ConsumerStatefulWidget {
  const WishlistProductTile(
    this.wishlistProduct, {
    required this.mainPageFamilyKey,
    super.key,
  });

  /// The wishlist entry that this tile represents.
  final WishlistProduct wishlistProduct;

  /// A [GlobalKey] used to refresh the main wishlist page when an item is removed.
  final GlobalKey mainPageFamilyKey;

  @override
  ConsumerState createState() => _WishlistProductTileState();
}

class _WishlistProductTileState extends ConsumerState<WishlistProductTile> {
  late WishlistProduct product;

  /// Local provider keys for scoping Riverpod adapters to this widget.
  final wishlistAdapterFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();
  final cartAdapterFamilyKey = GlobalKey();

  /// The original product details (fetched from the backend if available).
  Product? originalProduct;

  @override
  void initState() {
    super.initState();
    product = widget.wishlistProduct;

    // Fetch product details if it still exists and is in stock.
    if (product.productExists && !product.productOutOfStock) {
      CoreUtils.postFrameCall(() {
        ref
            .read(productAdapterProvider(productAdapterFamilyKey).notifier)
            .getProduct(product.productId);
      });
    }

    // Listen for product fetch events.
    ref.listenManual(productAdapterProvider(productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case ProductFetched(:final product)) {
        originalProduct = product;
      }
    });

    // Listen for wishlist state changes.
    ref.listenManual(userWishlistProvider(wishlistAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case WishlistError(:final message)) {
        CoreUtils.showSnackBar(context, message: '$message\nPULL TO REFRESH');
      } else if (next is RemovedFromWishlist) {
        CoreUtils.postFrameCall(() {
          // Refresh the wishlist + user profile when item removed.
          ref
              .read(userWishlistProvider(widget.mainPageFamilyKey).notifier)
              .getWishlist(Cache.instance.userId!);
          ref
              .read(authUserProvider(GlobalKey()).notifier)
              .getUserById(Cache.instance.userId!);
        });
      }
    });
  }

  /// Removes the current product from the wishlist.
  ///
  /// - Calls the [UserWishlist] provider's `removeFromWishlist`.
  /// - Uses the current logged-in user ID from [Cache].
  void removeFromWishlist() {
    ref
        .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
        .removeFromWishlist(
          userId: Cache.instance.userId!,
          productId: product.productId,
        );
  }

  /// Attempts to add the current product to the shopping cart.
  ///
  /// - If the product requires variant selection (colors/sizes), shows a
  ///   [BottomSheetCard] prompting the user to go to the product page.
  /// - If the product has no variants, it is directly added to the cart.
  /// - If the product no longer exists, shows a red [SnackBar] instructing
  ///   the user to remove it from their wishlist.
  Future<void> addToCart() async {
    final router = GoRouter.of(context);

    if (product.productExists && !product.productOutOfStock) {
      if (originalProduct == null ||
          originalProduct!.colours.isNotEmpty ||
          originalProduct!.sizes.isNotEmpty) {
        // Product requires variant selection
        final result = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          elevation: 0,
          isDismissible: false,
          builder: (_) {
            return const BottomSheetCard(
              title:
                  'You can only add this product to cart from the '
                  "product's page",
              positiveButtonText: 'Go',
              negativeButtonText: 'Cancel',
              positiveButtonColour: Colours.lightThemeSecondaryColour,
            );
          },
        );

        if (result ?? false) {
          goToProductPage(router);
        }
      } else {
        // Add directly to cart
        ref
            .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
            .addToCart(
              userId: Cache.instance.userId!,
              cartProduct: const CartProductModel.empty().copyWith(
                productId: product.productId,
                quantity: 1,
              ),
            );
      }
    } else if (!product.productExists) {
      // Product no longer exists
      CoreUtils.showSnackBar(
        context,
        backgroundColour: Colors.red,
        message:
            'Remove this product from your wishlist.'
            '\nIt no longer exists',
      );
    }
  }

  /// Navigates to the product detail page for the current product.
  void goToProductPage(GoRouter router) {
    router.push('/products/${product.productId}');
  }

  @override
  Widget build(BuildContext context) {
    final wishlistAdapter = ref.watch(
      userWishlistProvider(wishlistAdapterFamilyKey),
    );

    final productAdapter = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );

    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          foregroundDecoration: !product.productExists
              ? const BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                )
              : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CoreUtils.adaptiveColour(
              context,
              lightModeColour: Colours.lightThemeWhiteColour,
              darkModeColour: Colours.darkThemeDarkSharpColour,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Product Image + Name + Price
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: product.productExists
                    ? () => goToProductPage(GoRouter.of(context))
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f0f0),
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(product.productImage),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium4.adaptiveColour(
                              context,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            '\$${product.productPrice.toStringAsFixed(2)}',
                            style: TextStyles.headingMedium4.adaptiveColour(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),

              /// Remove & Add-to-Cart buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colours.lightThemeSecondaryColour,
                    ),
                    onPressed: removeFromWishlist,
                    child: const Text(
                      'Remove',
                      style: TextStyles.headingMedium4,
                    ),
                  ).loading(
                    wishlistAdapter is RemovingFromWishlist &&
                        product.productExists,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: product.productOutOfStock
                          ? Colors.grey
                          : Colours.lightThemeSecondaryColour,
                      foregroundColor: Colours.lightThemeWhiteColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: addToCart,
                    child: Text(
                      product.productOutOfStock
                          ? 'OUT OF STOCK'
                          : 'ADD TO CART',
                    ),
                  ).loading(
                    productAdapter is FetchingProduct ||
                        cartAdapter is AddingToCart,
                  ),
                ],
              ),
            ],
          ),
        ),

        /// Special section if product no longer exists
        if (!product.productExists) ...[
          const Gap(10),
          Text(
            'Product no longer exists. Delete it to free up your wishlist.',
            style: TextStyles.paragraphSubTextRegular2.adaptiveColour(context),
          ),
          const Gap(10),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colours.lightThemeSecondaryColour,
              foregroundColor: Colours.lightThemeWhiteColour,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: removeFromWishlist,
            child: const Text('REMOVE'),
          ).loading(wishlistAdapter is RemovingFromWishlist),
        ],
      ],
    );
  }
}
