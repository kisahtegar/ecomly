import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/search_button.dart';
import 'package:ecomly_client/core/extensions/int_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/media.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/core/utils/global_keys.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/cart/presentation/app/cart_product_notifier/cart_product_notifier.dart';
import 'package:ecomly_client/src/cart/presentation/utils/cart_utils.dart';
import 'package:ecomly_client/src/cart/presentation/widgets/cart_product_tile.dart';
import 'package:ecomly_client/src/cart/presentation/widgets/checkout_all_toggle_button.dart';
import 'package:ecomly_client/src/cart/presentation/widgets/checkout_button.dart';

/// The main screen for viewing and managing the user's shopping cart.
class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  /// Path for navigation (used by [GoRouter]).
  static const path = '/cart';

  @override
  ConsumerState<CartView> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  final cartAdapterFamilyKey = GlobalKeys.cartScreenAdapterFamilyKey;

  /// Tracks whether bulk product removal is in progress.
  bool removingBulkProducts = false;

  @override
  void initState() {
    super.initState();
    CoreUtils.postFrameCall(getCart);

    // Listen to cart state updates and react to errors or removals
    ref.listenManual(cartAdapterProvider(cartAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case CartError(:final message)) {
        CoreUtils.showSnackBar(context, message: '$message\nPULL TO REFRESH');
        if (previous is RemovingFromCart) {
          CoreUtils.postFrameCall(getCart);
        }
      } else if (next is RemovedFromCart) {
        CoreUtils.postFrameCall(getCart);
      }
    });
  }

  /// Fetches the cart items for the current user.
  Future<void> getCart() async {
    return ref
        .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
        .getCart(Cache.instance.userId!);
  }

  @override
  Widget build(BuildContext context) {
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);

    return RefreshIndicator.adaptive(
      onRefresh: getCart,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          bottom: const AppBarBottom(),
          actions: [
            const SearchButton(),
            const Gap(5),

            /// Bulk delete button (only visible if products are selected)
            if (cartProductNotifier.isNotEmpty)
              IconButton(
                onPressed: () async {
                  setState(() {
                    removingBulkProducts = true;
                  });
                  final shouldDelete = await CartUtils.verifyDeletion(
                    context,
                    message: 'Are you sure you want to remove these items?',
                  );

                  if (shouldDelete) {
                    for (final productId in cartProductNotifier) {
                      await ref
                          .read(
                            cartAdapterProvider(cartAdapterFamilyKey).notifier,
                          )
                          .removeFromCart(
                            userId: Cache.instance.userId!,
                            cartProductId: productId,
                          );
                    }
                  }
                  setState(() {
                    removingBulkProducts = false;
                  });
                },
                icon: const Icon(IconlyBroken.delete),
                color: Colours.lightThemeSecondaryColour,
              ),
            const Gap(10),
          ],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              // Loading state (bulk remove, fetching, or removing)
              if (removingBulkProducts ||
                  cartAdapter is FetchingCart ||
                  cartAdapter is RemovingFromCart) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              }

              // Success: cart fetched
              if (cartAdapter case CartFetched(:final cart)) {
                if (cart.isEmpty) {
                  // Empty cart view
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(Media.emptyCart, repeat: false),
                          const Gap(5),
                          Text(
                            'Oh! So empty',
                            style: TextStyles.headingSemiBold.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Cart with items
                return Column(
                  children: [
                    /// Header with item count and toggle
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cartAdapter.cart.length.pluralizeWith('item'),
                            style: TextStyles.buttonTextHeadingSemiBold
                                .adaptiveColour(context),
                          ),
                          if (cartProductNotifier.isNotEmpty)
                            CheckoutAllToggleButton(
                              allProducts: cartAdapter.cart,
                            ),
                        ],
                      ),
                    ),

                    /// List of products
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartAdapter.cart.length,
                        itemBuilder: (context, index) {
                          final product = cartAdapter.cart[index];
                          return CartProductTile(
                            product,
                            mainPageFamilyKey: cartAdapterFamilyKey,
                          );
                        },
                        separatorBuilder: (_, __) => const Gap(20),
                      ),
                    ),

                    /// Checkout button
                    CheckoutButton(products: cart),
                  ],
                );
              }

              // Error state
              if (cartAdapter is CartError) {
                return Center(child: Lottie.asset(Media.error));
              }

              // Default (initial/empty state)
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
