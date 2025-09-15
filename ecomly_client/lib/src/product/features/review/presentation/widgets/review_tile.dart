import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:ecomly_client/core/common/widgets/expandable_text.dart';
import 'package:ecomly_client/core/common/widgets/rating_stars.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/src/product/domain/entities/review.dart';

/// A UI tile for displaying a [Review].
///
/// Can be shown in two modes:
/// - **Full mode** (`previewMode = false`): Displays the reviewer's name,
///   star rating, optional comment, and review date.
/// - **Preview mode** (`previewMode = true`): Displays a condensed format
///   with the reviewer's name inline with the date.
///
/// Use the named constructors:
/// - [ReviewTile]: Creates a tile in **full mode**.
/// - [ReviewTile.preview]: Creates a tile in **preview mode**.
///
/// Example:
/// ```dart
/// ReviewTile(review);               // Full mode
/// ReviewTile.preview(review);       // Preview mode
/// ```
class ReviewTile extends StatelessWidget {
  /// Creates a [ReviewTile] in preview mode.
  const ReviewTile.preview(this.review, {super.key, this.margin})
    : previewMode = true;

  /// Creates a [ReviewTile] in full mode.
  const ReviewTile(this.review, {super.key, this.margin}) : previewMode = false;

  /// The review data to display.
  final Review review;

  /// Whether the tile is shown in condensed preview mode.
  final bool previewMode;

  /// Optional margin to wrap the tile.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    // Format review date into "Month dd, yyyy"
    final date = DateFormat('MMMM dd, yyyy').format(review.date);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Show reviewer's name only in full mode.
          if (!previewMode) ...[
            Text(
              review.userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.headingMedium3.adaptiveColour(context),
            ),
            const Gap(8),
          ],

          /// Star rating
          RatingStars(review.rating),

          /// Optional review comment
          if (review.comment.trim().isNotEmpty) ...[
            const Gap(8),
            ExpandableText(
              context,
              text: review.comment.trim(),
              style: TextStyles.paragraphRegular.grey,
            ),
          ],
          const Gap(8),

          /// Footer: date only (full mode) OR user + date (preview mode).
          if (!previewMode)
            Text(date, style: TextStyles.paragraphSubTextRegular2.grey)
          else
            RichText(
              text: TextSpan(
                text: '${review.userName}: ',
                style: TextStyles.paragraphSubTextRegular2.adaptiveColour(
                  context,
                ),
                children: [
                  TextSpan(
                    text: date,
                    style: const TextStyle(
                      color: Colours.lightThemeSecondaryTextColour,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
