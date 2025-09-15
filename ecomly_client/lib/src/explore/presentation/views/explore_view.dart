import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/menu_icon.dart';
import 'package:ecomly_client/core/common/widgets/search_button.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:ecomly_client/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly_client/src/product/presentation/widgets/paginated_product_grid_view.dart';

/// The **ExploreView** allows users to browse products by category.
///
/// It consists of:
/// - An app bar with a menu button, search button, and bottom divider.
/// - A [CategorySelector] to filter products by category.
/// - A [PaginatedProductGridView] to display products with infinite scroll.
///
/// Product fetching is managed by [ProductAdapter], while [CategoryNotifier]
/// provides the currently selected category.
class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  /// The route path used in [GoRouter].
  static const path = '/explore';

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  /// Family keys allow multiple instances of the same provider
  /// to be scoped independently (one for category, one for products).
  final categoryFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();

  /// Fetches products depending on the selected category.
  ///
  /// - If the category is "All", it fetches all products using [ProductAdapter.getProducts].
  /// - Otherwise, it fetches products filtered by the selected category
  ///   using [ProductAdapter.getProductsByCategory].
  ///
  /// ### Params:
  /// - [page]: The current page for paginated requests.
  ///
  /// ### Example:
  /// ```dart
  /// await getProducts(1); // fetch first page of products
  /// ```
  Future<void> getProducts(int page) async {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));
    final productAdapterNotifier = ref.read(
      productAdapterProvider(productAdapterFamilyKey).notifier,
    );
    if (category.name?.toLowerCase() == 'all') {
      return productAdapterNotifier.getProducts(page);
    }
    return productAdapterNotifier.getProductsByCategory(
      page: page,
      categoryId: category.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        leading: const MenuIcon(),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category filter UI
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: CategorySelector(
                categoryNotifierFamilyKey: categoryFamilyKey,
              ),
            ),
            const Gap(20),

            // Infinite scroll product grid
            Expanded(
              child: PaginatedProductGridView(
                productAdapterFamilyKey: productAdapterFamilyKey,
                categoryFamilyKey: categoryFamilyKey,
                fetchRequest: getProducts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
