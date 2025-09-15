import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/search_button.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:ecomly_client/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly_client/src/product/presentation/widgets/paginated_product_grid_view.dart';

/// View displaying **all popular products** with category filtering.
///
/// This screen uses [CategorySelector] to let users filter products by category
/// and [PaginatedProductGridView] to handle infinite scrolling. It will Displays
/// only "Popular" products and Supports category-based filtering (defaults to "All").
class AllPopularProductsView extends ConsumerStatefulWidget {
  const AllPopularProductsView({super.key});

  /// Static route path for navigation.
  static const path = 'popular';

  @override
  ConsumerState createState() => _AllPopularProductsViewState();
}

class _AllPopularProductsViewState
    extends ConsumerState<AllPopularProductsView> {
  /// Family key for category state (used by [CategoryNotifier]).
  final categoryNotifierFamilyKey = GlobalKey();

  /// Family key for product adapter state (used by [ProductAdapter]).
  final productAdapterFamilyKey = GlobalKey();

  /// Fetches popular products for the given [page].
  ///
  /// If a category is selected (other than "All"), its [id] is passed. Otherwise,
  /// all popular products are fetched without filtering.
  Future<void> getProducts(int page) async {
    final category = ref.watch(
      categoryNotifierProvider(categoryNotifierFamilyKey),
    );

    String? categoryId;
    if (category.name?.toLowerCase() != 'all') {
      categoryId = category.id;
    }

    ref
        .read(productAdapterProvider(productAdapterFamilyKey).notifier)
        .getPopular(page: page, categoryId: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Products'),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Category selection bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: CategorySelector(
                categoryNotifierFamilyKey: categoryNotifierFamilyKey,
              ),
            ),
            const Gap(20),

            /// Paginated grid displaying products
            Expanded(
              child: PaginatedProductGridView(
                productAdapterFamilyKey: productAdapterFamilyKey,
                categoryFamilyKey: categoryNotifierFamilyKey,
                fetchRequest: getProducts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
