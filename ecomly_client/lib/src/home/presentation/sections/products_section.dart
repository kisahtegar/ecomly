import 'package:collection/collection.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/home/presentation/widgets/home_product_tile.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

/// A reusable **products section** for the Home screen.
///
/// Can represent either:
/// - **New Arrivals** (`productsCriteria = "newArrivals"`)
/// - **Popular Products** (`productsCriteria = "popular"`)
///
/// ### Features:
/// - Fetches data through [productAdapterProvider] using Riverpod.
/// - Displays a **section title** and up to 10 products.
/// - If there are more than 9 products, shows a **"View All" arrow button**.
/// - Shows a **loading spinner** while products are being fetched.
/// - Tapping a product opens its **details page** via [HomeProductTile].
///
/// ### Usage:
/// ```dart
/// ProductsSection.popular(
///   onViewAll: () => context.go('/home/popular'),
/// )
///
/// ProductsSection.newArrivals(
///   onViewAll: () => context.go('/home/new-arrivals'),
/// )
/// ```
class ProductsSection extends ConsumerStatefulWidget {
  const ProductsSection.newArrivals({super.key, this.onViewAll})
    : sectionTitle = 'New Arrivals',
      productsCriteria = 'newArrivals';

  const ProductsSection.popular({super.key, this.onViewAll})
    : sectionTitle = 'Popular Products',
      productsCriteria = 'popular';

  /// Callback triggered when the **View All** button is pressed.
  final VoidCallback? onViewAll;

  /// Criteria used to fetch products ("popular" or "newArrivals").
  final String productsCriteria;

  /// The title shown above the section (e.g., "Popular Products").
  final String sectionTitle;

  @override
  ConsumerState<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends ConsumerState<ProductsSection> {
  /// Key to identify this family of product adapters.
  final familyKey = GlobalKey();

  /// Local list of products fetched from API.
  List<Product> products = [];

  @override
  void initState() {
    super.initState();

    // Fetch products depending on the section type.
    if (widget.productsCriteria == 'popular') {
      CoreUtils.postFrameCall(() => getPopular(1));
    } else if (widget.productsCriteria == 'newArrivals') {
      CoreUtils.postFrameCall(() => getNewArrivals(1));
    }

    // Listen for state changes in the product adapter.
    ref.listenManual(productAdapterProvider(familyKey), (previous, next) {
      if (next case ProductError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
      } else if (next case ProductsFetched(:final products)) {
        setState(() {
          this.products = products;
        });
      }
    });
  }

  /// Fetches popular products from the backend.
  void getPopular(int page) {
    ref.read(productAdapterProvider(familyKey).notifier).getPopular(page: page);
  }

  /// Fetches new arrivals from the backend.
  void getNewArrivals(int page) {
    ref
        .read(productAdapterProvider(familyKey).notifier)
        .getNewArrivals(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(productAdapterProvider(familyKey));

    // Show loading state
    if (productAdapter is FetchingProducts) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    }
    // Show product list if available
    else if (products.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.sectionTitle,
                style: TextStyles.buttonTextHeadingSemiBold.adaptiveColour(
                  context,
                ),
              ),
              if (products.length > 9)
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colours.lightThemeSecondaryTextColour
                        .withOpacity(.2),
                  ),
                  onPressed: widget.onViewAll,
                  icon: const Icon(
                    IconlyBroken.arrow_right,
                    color: Colours.lightThemeSecondaryColour,
                  ),
                ),
            ],
          ),
          const Gap(20),

          // Horizontal product scroller
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: products.take(10).mapIndexed((index, product) {
                return HomeProductTile(
                  product,
                  margin: index == 9 ? null : const EdgeInsets.only(right: 10),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }

    // Empty fallback
    return const SizedBox.shrink();
  }
}
