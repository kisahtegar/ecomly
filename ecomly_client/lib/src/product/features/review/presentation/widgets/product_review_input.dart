import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly_client/core/common/widgets/input_field.dart';
import 'package:ecomly_client/core/extensions/double_extensions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';

/// A widget that allows the current user to submit a review for a [Product].
///
/// Includes:
/// - A star rating input (1–5).
/// - A text input field for the review.
/// - A "POST" button that submits the review.
///
/// After submission:
/// - Clears the input fields.
/// - Refreshes the product's reviews via [ProductAdapter].
///
/// Displays the current user's avatar and name at the top,
/// followed by rating stars, a text input, and the submission button.
class ProductReviewInput extends StatefulWidget {
  const ProductReviewInput(
    this.product, {
    required this.reviewsFamilyKey,
    super.key,
  });

  /// The product being reviewed.
  final Product product;

  /// A unique [GlobalKey] used to scope the [ProductAdapter] for refreshing the
  /// reviews list after submission.
  final GlobalKey reviewsFamilyKey;

  @override
  State<ProductReviewInput> createState() => _ProductReviewInputState();
}

class _ProductReviewInputState extends State<ProductReviewInput> {
  /// Stores the selected star rating (0–5).
  final ratingNotifier = ValueNotifier<double>(0);

  /// Controls the review text input.
  final controller = TextEditingController();

  /// Local key for scoping [ProductAdapter] when posting a review.
  final productAdapterFamilyKey = GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    ratingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final user = ref.watch(currentUserProvider);

        /// Watches the state of the [ProductAdapter] tied to [productAdapterFamilyKey].
        final productAdapter = ref.watch(
          productAdapterProvider(productAdapterFamilyKey),
        );

        /// Listens for state changes in the [ProductAdapter].
        ref.listen(productAdapterProvider(productAdapterFamilyKey), (
          previous,
          next,
        ) {
          if (next case ProductError(:final message)) {
            CoreUtils.showSnackBar(context, message: message);
          } else if (next is ProductReviewed) {
            CoreUtils.postFrameCall(() {
              ratingNotifier.value = 0;
              controller.clear();
              ref
                  .read(
                    productAdapterProvider(widget.reviewsFamilyKey).notifier,
                  )
                  .getProductReviews(productId: widget.product.id, page: 1);
            });
          }
        });

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User avatar + name + info text
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colours.lightThemePrimaryColour,
                  child: Center(
                    child: Text(
                      user!.name.initials,
                      style: TextStyles.headingMedium4.white,
                    ),
                  ),
                ),
                const Gap(20),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyles.headingSemiBold1.adaptiveColour(
                          context,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        'Reviews are public and include your account info.',
                        style: TextStyles.paragraphSubTextRegular3
                            .adaptiveColour(context)
                            .copyWith(fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(15),

            /// Star rating input
            ValueListenableBuilder(
              valueListenable: ratingNotifier,
              builder: (_, value, __) {
                return Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: RatingStars(
                    value: value,
                    onValueChanged: (newValue) {
                      ratingNotifier.value = newValue;
                    },
                    starBuilder: (index, color) {
                      if (value.canFill(index + 1)) {
                        return Icon(Icons.star, color: color);
                      }
                      return Icon(Icons.star_outline, color: color);
                    },
                    starCount: 5,
                    starSize: 30,
                    valueLabelColor: const Color(0xff9b9b9b),
                    valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0,
                    ),
                    valueLabelRadius: 10,
                    maxValue: 5,
                    starSpacing: 4,
                    maxValueVisibility: true,
                    valueLabelVisibility: true,
                    animationDuration: const Duration(seconds: 1),
                    valueLabelPadding: const EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 8,
                    ),
                    valueLabelMargin: const EdgeInsets.only(right: 8),
                    starOffColor: Colors.grey,
                    starColor: Colors.amber,
                  ),
                );
              },
            ),
            const Gap(25),

            /// Review text input
            InputField(
              controller: controller,
              expandable: true,
              hintText: 'Describe your experience',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            const Gap(16),

            /// Submit button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colours.lightThemePrimaryColour,
                foregroundColor: Colours.lightThemeWhiteColour,
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (controller.text.trim().isNotEmpty ||
                    ratingNotifier.value >= 1) {
                  ref
                      .read(
                        productAdapterProvider(
                          productAdapterFamilyKey,
                        ).notifier,
                      )
                      .leaveReview(
                        productId: widget.product.id,
                        userId: user.id,
                        comment: controller.text.trim(),
                        rating: ratingNotifier.value < 1
                            ? 1
                            : ratingNotifier.value,
                      );
                }
              },
              child: const Text('POST'),
            ).loading(productAdapter is Reviewing),
          ],
        );
      },
    );
  }
}
