import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';

/// A horizontal list of **product categories** displayed on the Home screen.
///
/// This section fetches categories using [productAdapterProvider] and listens
/// for updates via Riverpod.
///
/// ### Lifecycle:
/// - In `didChangeDependencies()`, triggers fetching categories.
/// - In `initState()`, listens for category updates or errors.
/// - Updates the local `categories` list when [CategoriesFetched] is emitted.
class CategoriesSection extends ConsumerStatefulWidget {
  const CategoriesSection({super.key});

  @override
  ConsumerState<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends ConsumerState<CategoriesSection> {
  /// Local list of categories fetched from the adapter.
  List<ProductCategory> categories = [];

  /// Unique key for this family of providers.
  final familyKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Trigger fetching categories after the first frame is built.
    CoreUtils.postFrameCall(() {
      ref.read(productAdapterProvider(familyKey).notifier).getCategories();
    });
  }

  @override
  void initState() {
    super.initState();
    // Listen for product adapter state changes.
    ref.listenManual(productAdapterProvider(familyKey), (previous, next) {
      if (next is ProductError) {
        final ProductError(:message) = next;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next case CategoriesFetched(:final categories)) {
        setState(() {
          this.categories = categories;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productAdapter = ref.watch(productAdapterProvider(familyKey));

    // Show loading spinner while fetching categories
    if (productAdapter is FetchingCategories) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    } else {
      // If no categories, return empty widget
      if (categories.isEmpty) return const SizedBox.shrink();

      // Horizontal list of categories
      return SizedBox(
        height: 95,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const Gap(20),
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // Navigate to category-specific page
                context.push('/${category.name}', extra: category);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundImage: NetworkImage(category.image!),
                  ),
                  const Gap(3),
                  Text(
                    category.name!,
                    style: TextStyles.paragraphSubTextRegular1.adaptiveColour(
                      context,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
