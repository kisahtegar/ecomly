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

class CategorySelector extends ConsumerStatefulWidget {
  const CategorySelector({required this.categoryNotifierFamilyKey, super.key});

  final GlobalKey categoryNotifierFamilyKey;

  @override
  ConsumerState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  final productAdapterFamilyKey = GlobalKey();

  void selectCategory(ProductCategory category) {
    ref
        .read(
          categoryNotifierProvider(widget.categoryNotifierFamilyKey).notifier,
        )
        .changeCategory(category);
  }

  @override
  void initState() {
    super.initState();
    CoreUtils.postFrameCall(
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .getCategories,
    );
  }

  @override
  Widget build(BuildContext context) {
    final adapterState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    final selectedCategory = ref.watch(
      categoryNotifierProvider(widget.categoryNotifierFamilyKey),
    );

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

    if (adapterState is FetchingCategories) {
      return const LinearProgressIndicator();
    } else if (adapterState case CategoriesFetched(:final categories)) {
      return SizedBox(
        height: 40,
        child: Theme(
          data: context.theme.copyWith(canvasColor: Colors.transparent),
          child: ListView.separated(
            controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            itemCount: adapterState.categories.length + 1,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              if (index == 0) {
                final selected = selectedCategory.name!.toLowerCase() == 'all';
                return ChoiceChip(
                  label: const Text('All'),
                  labelStyle: selected
                      ? TextStyles.headingSemiBold1.white
                      : TextStyles.paragraphSubTextRegular1.grey,
                  selected: selected,
                  selectedColor: Colours.lightThemePrimaryColour,
                  showCheckmark: false,
                  backgroundColor: Colors.transparent,
                  onSelected: (_) {
                    selectCategory(const ProductCategory.all());
                  },
                );
              }
              final category = categories[index - 1];
              final selected = selectedCategory == category;
              return ChoiceChip(
                label: Text(category.name!),
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
    return const SizedBox.shrink();
  }
}
