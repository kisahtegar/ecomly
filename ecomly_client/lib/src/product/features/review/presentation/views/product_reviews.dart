import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/empty_data.dart';
import 'package:ecomly_client/core/common/widgets/rating_stars.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/constants/network_constants.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/entities/review.dart';
import 'package:ecomly_client/src/product/features/review/presentation/widgets/review_tile.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';

class ProductReviews extends ConsumerStatefulWidget {
  const ProductReviews(this.product, {super.key});

  final Product product;

  @override
  ConsumerState<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends ConsumerState<ProductReviews> {
  final pageController = PagingController<int, Review>(firstPageKey: 1);
  final productAdapterFamilyKey = GlobalKey();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    pageController.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      CoreUtils.postFrameCall(() {
        ref
            .read(productAdapterProvider(productAdapterFamilyKey).notifier)
            .getProductReviews(productId: widget.product.id, page: pageKey);
      });
    });

    ref.listenManual(productAdapterProvider(productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case ProductError(:final message)) {
        pageController.error = message;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next case ReviewsFetched(:final reviews)) {
        final isLastPage = reviews.length < NetworkConstants.pageSize;
        if (isLastPage) {
          pageController.appendLastPage(reviews);
        } else {
          final nextPage = currentPage + 1;
          pageController.appendPage(reviews, nextPage);
        }
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        bottom: const AppBarBottom(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reviews (${widget.product.numberOfReviews})',
                    style: TextStyles.buttonTextHeadingSemiBold.adaptiveColour(
                      context,
                    ),
                  ),
                  RatingStars(widget.product.rating),
                ],
              ),
              const Gap(30),
              Expanded(
                child: PagedListView<int, Review>.separated(
                  pagingController: pageController,
                  separatorBuilder: (_, __) => const Gap(30),
                  builderDelegate: PagedChildBuilderDelegate<Review>(
                    itemBuilder: (context, item, index) => ReviewTile(item),
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
                      return const Center(
                        child: EmptyData(
                          'No reviews for this product.',
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
