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

class ReviewsPreview extends ConsumerStatefulWidget {
  const ReviewsPreview({required this.product, super.key});

  final Product product;

  @override
  ConsumerState createState() => _ReviewsPreviewState();
}

class _ReviewsPreviewState extends ConsumerState<ReviewsPreview> {
  final productAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    CoreUtils.postFrameCall(() {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .getProductReviews(productId: widget.product.id, page: 1);
    });

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
    final productAdapterState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProductReviewInput(
          widget.product,
          reviewsFamilyKey: productAdapterFamilyKey,
        ),
        const Gap(50),
        Builder(
          builder: (_) {
            if (productAdapterState is FetchingReviews) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colours.lightThemePrimaryColour,
                ),
              );
            } else if (productAdapterState case ReviewsFetched(
              :final reviews,
            ) when reviews.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
