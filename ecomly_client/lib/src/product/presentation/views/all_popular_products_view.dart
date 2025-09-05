import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/search_button.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:ecomly_client/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly_client/src/product/presentation/widgets/paginated_product_grid_view.dart';

class AllPopularProductsView extends ConsumerStatefulWidget {
  const AllPopularProductsView({super.key});

  static const path = 'popular';

  @override
  ConsumerState createState() => _AllPopularProductsViewState();
}

class _AllPopularProductsViewState
    extends ConsumerState<AllPopularProductsView> {
  final categoryNotifierFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();

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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: CategorySelector(
                categoryNotifierFamilyKey: categoryNotifierFamilyKey,
              ),
            ),
            const Gap(20),
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
