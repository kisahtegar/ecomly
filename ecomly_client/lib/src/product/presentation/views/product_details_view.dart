import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/expandable_text.dart';
import 'package:ecomly_client/core/common/widgets/favourite_icon.dart';
import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/int_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/cart/data/models/cart_product_model.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/home/presentation/widgets/reactive_cart_icon.dart';
import 'package:ecomly_client/src/product/features/review/presentation/widgets/reviews_preview.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/widgets/colour_palette.dart';
import 'package:ecomly_client/src/product/presentation/widgets/size_picker.dart';

/// A detailed view of a single product.
///
/// Displays:
/// - Product images (carousel).
/// - Name, price, rating, and reviews count.
/// - Available colours and sizes for selection.
/// - Expandable description text.
/// - Preview of customer reviews.
/// - Add to Cart button (validates required options).
///
/// Also integrates:
/// - Favourite button (wishlist).
/// - Reactive cart icon (updates with cart changes).
class ProductDetailsView extends ConsumerStatefulWidget {
  const ProductDetailsView(this.productId, {super.key});

  /// The unique product identifier to fetch details for.
  final String productId;

  @override
  ConsumerState<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends ConsumerState<ProductDetailsView> {
  /// State family key for product adapter.
  final productAdapterFamilyKey = GlobalKey();

  /// State family key for cart adapter.
  final cartAdapterFamilyKey = GlobalKey();

  /// The size selected by the user (if applicable).
  String? selectedSize;

  /// The colour selected by the user (if applicable).
  Color? selectedColour;

  @override
  void initState() {
    super.initState();

    /// Fetch product details when the view initializes.
    CoreUtils.postFrameCall(() {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .getProduct(widget.productId);
    });

    /// Listen for product fetching errors.
    ref.listenManual(productAdapterProvider(productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case ProductError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
        CoreUtils.postFrameCall(() {
          // This is done because the network_utils.dart calls pop when
          // there's 401 token revocation. If that happens while someone is
          // opening this page, it'll already have popped and this pop will
          // throw a "nothing to pop" error.
          if (context.canPop()) context.pop();
        });
      }
    });

    /// Listen for cart operations (errors/success).
    ref.listenManual(cartAdapterProvider(cartAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case CartError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
      }
      if (next is AddedToCart) {
        CoreUtils.showSnackBar(
          context,
          message: 'Product added to cart',
          backgroundColour: Colors.green,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    final cartState = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        bottom: const AppBarBottom(),
        actions: [
          if (productState is ProductFetched)
            FavouriteIcon(productId: productState.product.id),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: ReactiveCartIcon(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          /// Show loading spinner while fetching product
          if (productState is FetchingProduct) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colours.lightThemePrimaryColour,
              ),
            );
          }
          /// Render product details once fetched
          else if (productState case ProductFetched(:final product)) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      /// Product image carousel
                      Builder(
                        builder: (context) {
                          var images = product.images;
                          if (images.isEmpty) images = [product.image];
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: context.height * .4,
                              autoPlay: images.length > 1,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                            ),
                            items: images.map((image) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: context.width,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff0f0f0),
                                      image: DecorationImage(
                                        image: NetworkImage(image),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),

                      /// Product name, price, rating
                      Padding(
                        padding: const EdgeInsets.all(20).copyWith(bottom: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: TextStyles.headingMedium4
                                        .adaptiveColour(context),
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyles.headingMedium1.orange,
                                ),
                              ],
                            ),
                            const Gap(5),
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
                                Text(
                                  ' (${product.numberOfReviews.pluralizeReviews})',
                                  style: const TextStyle(
                                    color:
                                        Colours.lightThemeSecondaryTextColour,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Divider
                      Divider(
                        color: CoreUtils.adaptiveColour(
                          context,
                          darkModeColour: Colours.darkThemeDarkSharpColour,
                          lightModeColour: Colors.white,
                        ),
                      ),
                      const Gap(10),

                      /// Colours, sizes, description, reviews preview
                      Padding(
                        padding: const EdgeInsets.all(20).copyWith(top: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Colour palette
                            if (product.colours.isNotEmpty)
                              ColourPalette(
                                colours: product.colours,
                                canScroll: true,
                                radius: 15,
                                spacing: 10,
                                padding: const EdgeInsets.all(5),
                                onSelect: (colour) {
                                  selectedColour = colour;
                                },
                              ),

                            /// Size picker
                            if (product.sizes.isNotEmpty) ...[
                              const Gap(15),
                              SizePicker(
                                sizes: product.sizes,
                                radius: 28,
                                canScroll: true,
                                spacing: 8,
                                onSelect: (size) {
                                  selectedSize = size;
                                },
                              ),
                            ],
                            const Gap(20),

                            /// Description
                            Text(
                              'Description',
                              style: TextStyles.headingMedium3.adaptiveColour(
                                context,
                              ),
                            ),
                            const Gap(5),
                            ExpandableText(
                              context,
                              text: product.description,
                              style: TextStyles.paragraphRegular.grey,
                            ),
                            const Gap(20),

                            /// Reviews preview
                            ReviewsPreview(product: product),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Add to Cart button
                Padding(
                  padding: const EdgeInsets.all(20).copyWith(bottom: 40),
                  child: RoundedButton(
                    height: 50,
                    onPressed: () {
                      /// Validate required selections
                      if (product.colours.isNotEmpty &&
                          selectedColour == null) {
                        CoreUtils.showSnackBar(
                          context,
                          message: 'Pick a colour',
                          backgroundColour: Colors.red.withOpacity(.8),
                        );
                        return;
                      } else if (product.sizes.isNotEmpty &&
                          selectedSize == null) {
                        CoreUtils.showSnackBar(
                          context,
                          message: 'Pick a size',
                          backgroundColour: Colors.red.withOpacity(.8),
                        );
                        return;
                      }

                      /// Add to cart request
                      ref
                          .read(
                            cartAdapterProvider(cartAdapterFamilyKey).notifier,
                          )
                          .addToCart(
                            userId: Cache.instance.userId!,
                            cartProduct: const CartProductModel.empty()
                                .copyWith(
                                  productId: product.id,
                                  quantity: 1,
                                  selectedSize: selectedSize,
                                  selectedColour: selectedColour,
                                ),
                          );
                    },
                    text: 'Add to Cart',
                    textStyle: TextStyles.buttonTextHeadingSemiBold
                        .copyWith(fontSize: 16)
                        .white,
                  ).loading(cartState is AddingToCart),
                ),
              ],
            );
          }

          /// Default: render nothing
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
