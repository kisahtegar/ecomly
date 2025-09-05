import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:ecomly_client/core/common/widgets/classic_product_tile.dart';
import 'package:ecomly_client/core/common/widgets/empty_data.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/constants/network_constants.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/app/category_notifier/category_notifier.dart';

class PaginatedProductGridView extends ConsumerStatefulWidget {
  const PaginatedProductGridView({
    required this.productAdapterFamilyKey,
    this.categoryFamilyKey,
    required this.fetchRequest,
    this.categorized = true,
    super.key,
  }) : assert(
         !categorized || (categorized && categoryFamilyKey != null),
         'Category family key cannot be null in a "Categorized" products view',
       );

  final GlobalKey productAdapterFamilyKey;
  final GlobalKey? categoryFamilyKey;
  final ValueChanged<int> fetchRequest;
  final bool categorized;

  @override
  ConsumerState<PaginatedProductGridView> createState() =>
      _PaginatedProductGridView();
}

class _PaginatedProductGridView
    extends ConsumerState<PaginatedProductGridView> {
  final pageController = PagingController<int, Product>(firstPageKey: 1);
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    pageController.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      CoreUtils.postFrameCall(() => widget.fetchRequest(pageKey));
    });

    ref.listenManual(productAdapterProvider(widget.productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next is ProductError) {
        pageController.error = next.message;
        // redundant
        CoreUtils.showSnackBar(
          context,
          message: '${next.message}\nPULL TO REFRESH',
        );
      } else if (next is ProductsFetched) {
        final products = next.products;
        final isLastPage = products.length < NetworkConstants.pageSize;
        if (isLastPage) {
          pageController.appendLastPage(products);
        } else {
          final nextPage = currentPage + 1;
          pageController.appendPage(products, nextPage);
        }
      }
    });

    ref.listenManual(categoryNotifierProvider(widget.categoryFamilyKey), (
      previous,
      next,
    ) {
      pageController.refresh();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(
      categoryNotifierProvider(widget.categoryFamilyKey),
    );

    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(() => pageController.refresh()),
      child: PagedMasonryGridView<int, Product>.count(
        pagingController: pageController,
        crossAxisCount: 2,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, product, index) =>
              Center(child: ClassicProductTile(product)),
          firstPageProgressIndicatorBuilder: (_) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colours.lightThemePrimaryColour,
              ),
            );
          },
          newPageProgressIndicatorBuilder: (_) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colours.lightThemePrimaryColour,
              ),
            );
          },
          noItemsFoundIndicatorBuilder: (_) {
            final categorySelected =
                widget.categorized && category.name?.toLowerCase() != 'all';
            return Center(
              child: EmptyData(
                categorySelected
                    ? 'No products found for this category'
                    : 'No products found',
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
