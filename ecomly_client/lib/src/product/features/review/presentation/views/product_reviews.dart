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

/// A view that displays all reviews for a given [Product].
///
/// Features:
/// - Fetches reviews from the server page by page.
/// - Supports infinite scrolling using [PagingController].
/// - Shows the product’s average rating and total review count at the top.
/// - Each review is rendered with [ReviewTile].
///
/// Example:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => ProductReviews(product),
///   ),
/// );
/// ```
class ProductReviews extends ConsumerStatefulWidget {
  /// Creates a new reviews page for the given [product].
  const ProductReviews(this.product, {super.key});

  /// The product whose reviews are displayed.
  final Product product;

  @override
  ConsumerState<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends ConsumerState<ProductReviews> {
  /// Handles pagination for fetching [Review] items.
  final pageController = PagingController<int, Review>(firstPageKey: 1);

  /// Unique key for isolating product adapter state.
  final productAdapterFamilyKey = GlobalKey();

  /// Tracks the currently requested page.
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

    // When a new page is requested, fetch reviews for that page.
    pageController.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      CoreUtils.postFrameCall(() {
        ref
            .read(productAdapterProvider(productAdapterFamilyKey).notifier)
            .getProductReviews(productId: widget.product.id, page: pageKey);
      });
    });

    // Listen for product adapter state updates.
    ref.listenManual(productAdapterProvider(productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case ProductError(:final message)) {
        // Display error message and mark page as errored.
        pageController.error = message;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next case ReviewsFetched(:final reviews)) {
        // Determine if this is the last page of results.
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
    // Dispose controller to avoid memory leaks.
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
              /// Header showing review count and average rating.
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

              /// Paginated list of reviews.
              Expanded(
                child: PagedListView<int, Review>.separated(
                  pagingController: pageController,
                  separatorBuilder: (_, __) => const Gap(30),
                  builderDelegate: PagedChildBuilderDelegate<Review>(
                    itemBuilder: (context, item, index) => ReviewTile(item),

                    /// Loader for the first page.
                    firstPageProgressIndicatorBuilder: (_) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colours.lightThemePrimaryColour,
                        ),
                      );
                    },

                    /// Loader for subsequent pages.
                    newPageProgressIndicatorBuilder: (_) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colours.lightThemePrimaryColour,
                        ),
                      );
                    },

                    /// Shown when no reviews exist.
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
