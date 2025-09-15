import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/app/category_notifier/category_notifier.dart';

/// A horizontal list of product categories represented as [ChoiceChip]s.
class CategorySelector extends ConsumerStatefulWidget {
  const CategorySelector({required this.categoryNotifierFamilyKey, super.key});

  /// Key that identifies the [CategoryNotifier] family provider.
  final GlobalKey categoryNotifierFamilyKey;

  @override
  ConsumerState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  /// Key used to scope the [ProductAdapter] instance for fetching categories.
  final productAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Fetch categories right after the first frame is built.
    CoreUtils.postFrameCall(
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .getCategories,
    );
  }

  /// Updates the selected category in the [CategoryNotifier].
  void selectCategory(ProductCategory category) {
    ref
        .read(
          categoryNotifierProvider(widget.categoryNotifierFamilyKey).notifier,
        )
        .changeCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final adapterState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    final selectedCategory = ref.watch(
      categoryNotifierProvider(widget.categoryNotifierFamilyKey),
    );

    // Listen for adapter state changes (errors or empty categories).
    ref.listen(productAdapterProvider(productAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next is ProductError) {
        CoreUtils.showSnackBar(context, message: next.message);
        CoreUtils.postFrameCall(context.pop);
      } else if (next case CategoriesFetched(
        :final categories,
      ) when categories.isEmpty) {
        CoreUtils.showSnackBar(
          context,
          message: 'No categories found.\nContact admin',
        );
        CoreUtils.postFrameCall(context.pop);
      }
    });

    // Show loader while fetching
    if (adapterState is FetchingCategories) {
      return const LinearProgressIndicator();
    }
    // Show category chips once fetched
    else if (adapterState case CategoriesFetched(:final categories)) {
      return SizedBox(
        height: 40,
        child: Theme(
          data: context.theme.copyWith(canvasColor: Colors.transparent),
          child: ListView.separated(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1, // +1 for the "All" option
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              // Special "All" category
              if (index == 0) {
                final selected = selectedCategory.name?.toLowerCase() == 'all';
                return ChoiceChip(
                  label: const Text('All'),
                  labelStyle: selected
                      ? TextStyles.headingSemiBold1.white
                      : TextStyles.paragraphSubTextRegular1.grey,
                  selected: selected,
                  selectedColor: Colours.lightThemePrimaryColour,
                  showCheckmark: false,
                  backgroundColor: Colors.transparent,
                  onSelected: (_) =>
                      selectCategory(const ProductCategory.all()),
                );
              }

              // Normal categories
              final category = categories[index - 1];
              final selected = selectedCategory == category;
              return ChoiceChip(
                label: Text(category.name ?? ''),
                labelStyle: selected
                    ? TextStyles.headingSemiBold1.white
                    : TextStyles.paragraphSubTextRegular1.grey,
                selected: selected,
                selectedColor: Colours.lightThemePrimaryColour,
                showCheckmark: false,
                backgroundColor: Colors.transparent,
                onSelected: (_) => selectCategory(category),
              );
            },
          ),
        ),
      );
    }

    // Fallback if no state applies
    return const SizedBox.shrink();
  }
}
