import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/features/review/presentation/widgets/product_review_input.dart';
import 'package:ecomly_client/src/product/features/review/presentation/widgets/review_tile.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';

/// A widget that displays a preview of product reviews along with an input
/// field for submitting a new review.
///
/// Features:
/// - Fetches the first page of reviews for the given [product].
/// - Displays a [ProductReviewInput] for posting a new review.
/// - Shows up to 4 reviews in preview mode via [ReviewTile.preview].
/// - If there are more than 4 reviews, a "View All" button is shown,
///   which navigates to the full reviews page.
///
/// Example:
/// ```dart
/// ReviewsPreview(product: product);
/// ```
class ReviewsPreview extends ConsumerStatefulWidget {
  /// Creates a review preview section for a [product].
  const ReviewsPreview({required this.product, super.key});

  /// The product whose reviews are being displayed.
  final Product product;

  @override
  ConsumerState createState() => _ReviewsPreviewState();
}

class _ReviewsPreviewState extends ConsumerState<ReviewsPreview> {
  /// Unique key for managing state of product adapter (fetching and posting reviews).
  final productAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Fetch initial product reviews after widget is mounted.
    CoreUtils.postFrameCall(() {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .getProductReviews(productId: widget.product.id, page: 1);
    });

    // Listen for review-related errors and show a snackbar if they occur.
    ref.listenManual(productAdapterProvider(productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case ProductError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch current state of product adapter (fetching, fetched, error, etc.)
    final productAdapterState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Input field for leaving a review (comment + rating).
        ProductReviewInput(
          widget.product,
          reviewsFamilyKey: productAdapterFamilyKey,
        ),
        const Gap(50),

        /// Preview section for recent reviews.
        Builder(
          builder: (_) {
            if (productAdapterState is FetchingReviews) {
              // Show loader while reviews are being fetched.
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colours.lightThemePrimaryColour,
                ),
              );
            } else if (productAdapterState case ReviewsFetched(
              :final reviews,
            ) when reviews.isNotEmpty) {
              // Show up to 4 reviews in preview mode.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Section header + "View All" button (if > 4 reviews).
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Reviews',
                        style: TextStyles.headingMedium3.adaptiveColour(
                          context,
                        ),
                      ),
                      if (reviews.length > 4)
                        InkWell(
                          onTap: () {
                            // Navigate to full reviews page.
                            context.push(
                              '/products/${widget.product.id}/reviews',
                              extra: widget.product,
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyles.paragraphSubTextRegular1.orange,
                          ),
                        ),
                    ],
                  ),
                  const Gap(20),

                  // Render the first 4 reviews using [ReviewTile.preview].
                  ...reviews.take(4).mapIndexed((index, review) {
                    final lastReviewIndex = reviews.take(4).length - 1;
                    return ReviewTile.preview(
                      review,
                      margin: index == lastReviewIndex
                          ? null
                          : const EdgeInsets.only(bottom: 35),
                    );
                  }),
                ],
              );
            }

            // If no reviews, show nothing.
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
