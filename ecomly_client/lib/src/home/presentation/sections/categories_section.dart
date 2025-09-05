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

class CategoriesSection extends ConsumerStatefulWidget {
  const CategoriesSection({super.key});

  @override
  ConsumerState<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends ConsumerState<CategoriesSection> {
  List<ProductCategory> categories = [];
  final familyKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CoreUtils.postFrameCall(() {
      ref.read(productAdapterProvider(familyKey).notifier).getCategories();
    });
  }

  @override
  void initState() {
    super.initState();
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

    if (productAdapter is FetchingCategories) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    } else {
      if (categories.isEmpty) return const SizedBox.shrink();
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
