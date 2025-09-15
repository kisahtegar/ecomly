import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/search_button.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/widgets/paginated_product_grid_view.dart';

/// View displaying **products filtered by a specific [ProductCategory]**.
///
/// This screen is used when a user taps a category and expects to see only
/// products belonging to that category.
///
/// Example usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => CategorizedProductsView(category),
///   ),
/// );
/// ```
class CategorizedProductsView extends ConsumerStatefulWidget {
  const CategorizedProductsView(this.category, {super.key});

  /// The category whose products should be displayed.
  final ProductCategory category;

  @override
  ConsumerState createState() => _CategorizedProductsViewState();
}

class _CategorizedProductsViewState
    extends ConsumerState<CategorizedProductsView> {
  /// Key for isolating the state of this product adapter instance.
  final familyKey = GlobalKey();

  /// Fetches products for the selected [ProductCategory].
  ///
  /// Called by the [PaginatedProductGridView] when scrolling. Uses
  /// [ProductAdapter.getProductsByCategory].
  Future<void> getProducts(int page) async {
    return ref
        .read(productAdapterProvider(familyKey).notifier)
        .getProductsByCategory(categoryId: widget.category.id, page: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name!),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: PaginatedProductGridView(
          productAdapterFamilyKey: familyKey,
          fetchRequest: getProducts,

          /// Disable category filter UI since this view is already scoped
          categorized: false,
        ),
      ),
    );
  }
}
