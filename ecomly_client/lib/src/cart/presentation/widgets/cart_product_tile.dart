import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/cart/presentation/app/cart_product_notifier/cart_product_notifier.dart';
import 'package:ecomly_client/src/cart/presentation/utils/cart_utils.dart';
import 'package:ecomly_client/src/cart/presentation/widgets/cart_product_quantity_stepper.dart';
import 'package:ecomly_client/src/product/presentation/widgets/colour_palette.dart';

/// A tile widget that displays a product inside the cart.
///
/// This widget shows product details such as image, name ,price, etc. It
/// integrates with [CartAdapter] for cart operations (update quantity, remove
/// from cart) and with [CartProductNotifier] for selection states (multi-select
/// support).
///
/// Long-pressing the tile allows product selection.
/// Buttons are provided for removing the product or updating its quantity.
class CartProductTile extends ConsumerStatefulWidget {
  const CartProductTile(
    this.product, {
    required this.mainPageFamilyKey,
    super.key,
  });

  /// The product entity to display.
  final CartProduct product;

  /// A provider family key used to refresh the cart list after actions like removal.
  final GlobalKey mainPageFamilyKey;

  @override
  ConsumerState createState() => _CartProductTileState();
}

class _CartProductTileState extends ConsumerState<CartProductTile> {
  final cartAdapterFamilyKey = GlobalKey();
  final productQuantityCounterFamilyKey = GlobalKey();
  late CartProduct product;
  final quantityUpdateNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  /// Navigates to the product details screen if the product still exists.
  void goToProductDetails() {
    if (product.productExists) {
      context.push('/products/${product.productId}');
    }
  }

  /// Updates the product quantity on the server using [CartAdapter].
  ///
  /// Triggered when the user presses the "UPDATE" button after changing the
  /// stepper quantity.
  void updateQuantity() {
    ref
        .read(cartAdapterProvider(productQuantityCounterFamilyKey).notifier)
        .changeCartProductQuantity(
          userId: Cache.instance.userId!,
          cartProductId: product.id,
          newQuantity: quantityUpdateNotifier.value!,
        );
    quantityUpdateNotifier.value = null;
  }

  /// Marks this product as selected in [CartProductNotifier].
  void selectProduct() {
    ref.read(cartProductNotifierProvider.notifier).selectProduct(product.id);
  }

  /// Removes this product from the selected list in [CartProductNotifier].
  void deselectProduct() {
    ref.read(cartProductNotifierProvider.notifier).deselectProduct(product.id);
  }

  /// Asks for deletion confirmation and removes the product if confirmed.
  Future<void> removeFromCart() async {
    final shouldDelete = await CartUtils.verifyDeletion(context);

    if (shouldDelete) {
      ref
          .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
          .removeFromCart(
            userId: Cache.instance.userId!,
            cartProductId: product.id,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final isSelected = cartProductNotifier.contains(product.id);
    final isAnySelected = cartProductNotifier.isNotEmpty;
    bool isDisabled = !product.productExists || product.productOutOfStock;

    // Handle state changes from cart operations
    ref.listen(cartAdapterProvider(cartAdapterFamilyKey), (previous, next) {
      if (next is CartError) {
        CoreUtils.showSnackBar(context, message: next.message);
      } else if (next is RemovedFromCart) {
        CoreUtils.postFrameCall(() {
          ref
              .read(cartAdapterProvider(widget.mainPageFamilyKey).notifier)
              .getCart(Cache.instance.userId!);
        });
      }
    });

    // Show loading indicator during operations
    if (cartAdapter is ChangingCartProductQuantity ||
        cartAdapter is RemovingFromCart) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    }

    return AbsorbPointer(
      absorbing: isDisabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: selectProduct,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Product card
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                isDisabled ? Colors.grey : Colors.transparent,
                BlendMode.saturation,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product image
                    GestureDetector(
                      onTap: goToProductDetails,
                      child: Container(
                        height: 152,
                        width: 130,
                        decoration: BoxDecoration(
                          color: const Color(0xfff0f0f0),
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(product.productImage),
                          ),
                        ),
                      ),
                    ),

                    const Gap(16),

                    /// Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Product name
                          GestureDetector(
                            onTap: goToProductDetails,
                            child: Text(
                              product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.buttonTextHeadingSemiBold
                                  .adaptiveColour(context),
                            ),
                          ),

                          /// Price and colour
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${product.productPrice.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.headingMedium4.orange,
                              ),
                              if (product.selectedColour != null) ...[
                                const Gap(5),
                                Flexible(
                                  child: ColourPalette(
                                    colours: [product.selectedColour!],
                                    radius: 5,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          /// Size (if selected)
                          if (product.selectedSize != null)
                            Text(
                              'Size: ${product.selectedSize}',
                              style: TextStyles.paragraphSubTextRegular1
                                  .adaptiveColour(context),
                            ),

                          /// Quantity stepper + action button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CartProductQuantityStepper(
                                product.quantity,
                                counterKey: productQuantityCounterFamilyKey,
                                cartProductId: product.id,
                                onStep: (newQuantity) {
                                  quantityUpdateNotifier.value = newQuantity;
                                },
                              ),
                              if (isAnySelected)
                                IconButton(
                                  onPressed: isSelected
                                      ? deselectProduct
                                      : selectProduct,
                                  icon: Icon(
                                    IconlyLight.tick_square,
                                    color: isSelected
                                        ? Colours.lightThemeSecondaryColour
                                        : Colours.lightThemeSecondaryTextColour,
                                  ),
                                )
                              else
                                IconButton(
                                  onPressed: removeFromCart,
                                  icon: const Icon(IconlyBroken.delete),
                                  color: Colours.lightThemeSecondaryColour,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Disabled product messages
            if (isDisabled) ...[
              const Gap(10),
              Builder(
                builder: (context) {
                  final message = product.productOutOfStock
                      ? 'This product is out of stock'
                      : 'This product no longer exists, Delete it to free up your cart';

                  return Text(
                    message,
                    style: TextStyles.paragraphSubTextRegular2.adaptiveColour(
                      context,
                    ),
                  );
                },
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
                onPressed: removeFromCart,
                child: const Text('REMOVE'),
              ).loading(cartAdapter is RemovingFromCart),
            ],

            /// Update prompt (appears when quantity changes locally)
            ValueListenableBuilder(
              valueListenable: quantityUpdateNotifier,
              builder: (_, value, __) {
                if (value == null) return const SizedBox.shrink();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(10),
                    Text(
                      'Tap to update',
                      style: TextStyles.paragraphSubTextRegular2.adaptiveColour(
                        context,
                      ),
                    ),
                    const Gap(10),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colours.lightThemePrimaryColour,
                        foregroundColor: Colours.lightThemeWhiteColour,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: updateQuantity,
                      child: const Text('UPDATE'),
                    ).loading(cartAdapter is RemovingFromCart),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
