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

class ProductsSection extends ConsumerStatefulWidget {
  const ProductsSection.newArrivals({super.key, this.onViewAll})
    : sectionTitle = 'New Arrivals',
      productsCriteria = 'newArrivals';

  const ProductsSection.popular({super.key, this.onViewAll})
    : sectionTitle = 'Popular Products',
      productsCriteria = 'popular';

  final VoidCallback? onViewAll;
  final String productsCriteria;
  final String sectionTitle;

  @override
  ConsumerState<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends ConsumerState<ProductsSection> {
  final familyKey = GlobalKey();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    if (widget.productsCriteria == 'popular') {
      CoreUtils.postFrameCall(() => getPopular(1));
    } else if (widget.productsCriteria == 'newArrivals') {
      CoreUtils.postFrameCall(() => getNewArrivals(1));
    }

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

  void getPopular(int page) {
    ref.read(productAdapterProvider(familyKey).notifier).getPopular(page: page);
  }

  void getNewArrivals(int page) {
    ref
        .read(productAdapterProvider(familyKey).notifier)
        .getNewArrivals(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(productAdapterProvider(familyKey));

    if (productAdapter is FetchingProducts) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    } else if (products.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
    return const SizedBox.shrink();
  }
}
