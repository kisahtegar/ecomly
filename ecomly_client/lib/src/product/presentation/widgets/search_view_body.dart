import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'package:ecomly_client/core/common/widgets/classic_product_tile.dart';
import 'package:ecomly_client/core/common/widgets/empty_data.dart';
import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/media.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';

/// A widget that displays the search results for products.
///
/// This widget reacts to the [ProductAdapter] state and updates the UI based
/// on the current state of a search operation. Renders the resulting list of
/// products as [ClassicProductTile]s in a responsive wrap layout. Shows a
/// "No Products Found" message if the list is empty.
class SearchViewBody extends ConsumerWidget {
  const SearchViewBody({required this.productAdapterFamilyKey, super.key});

  /// Key used for scoping the product adapter provider.
  final GlobalKey productAdapterFamilyKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAdapter = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );

    // Show loading animation while searching
    if (productAdapter is Searching) {
      return Center(child: Lottie.asset(Media.searching));
    }
    // Show search results
    else if (productAdapter case ProductsFetched(:final products)) {
      if (products.isEmpty) {
        return const Center(child: EmptyData('No Products Found'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              runSpacing: 10,
              runAlignment: WrapAlignment.center,
              spacing: 10,
              children: products.map(ClassicProductTile.new).toList(),
            ),
          ),
        ),
      );
    }
    // Show error state
    else if (productAdapter is ProductError) {
      return const EmptyData('No Products Found');
    }

    // Show placeholder when idle (before any search)
    return Center(
      child: Lottie.asset(
        context.isDarkMode ? Media.search : Media.searchLight,
      ),
    );
  }
}
