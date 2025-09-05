import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/majesticons.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/enums/gender_age_category.dart';
import 'package:ecomly_client/src/home/presentation/sections/search_section.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:ecomly_client/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:ecomly_client/src/product/presentation/app/gender_age_category_notifier/gender_age_category_notifier.dart';
import 'package:ecomly_client/src/product/presentation/widgets/category_selector.dart';
import 'package:ecomly_client/src/product/presentation/widgets/gender_age_category_selector.dart';
import 'package:ecomly_client/src/product/presentation/widgets/search_view_body.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  static const path = '/search';

  @override
  ConsumerState createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final categoryFamilyKey = GlobalKey();
  final genderAgeCategoryFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();
  final searchController = TextEditingController();

  int page = 1;

  void search({
    required ProductCategory category,
    required GenderAgeCategory genderAgeCategory,
  }) {
    final productAdapter = ref.read(
      productAdapterProvider(productAdapterFamilyKey).notifier,
    );
    if (category.name!.toLowerCase() != 'all') {
      // means that the genderAgeCategory is considered
      if (genderAgeCategory.title.toLowerCase() != 'all') {
        // means we have a specification and they are
        // both not [all]
        productAdapter.searchByCategoryAndGenderAgeCategory(
          query: searchController.text.trim(),
          categoryId: category.id,
          genderAgeCategory: genderAgeCategory.title.toLowerCase(),
          page: page,
        );
      } else {
        // means we have only category specified
        productAdapter.searchByCategory(
          query: searchController.text.trim(),
          categoryId: category.id,
          page: page,
        );
      }
    } else {
      productAdapter.searchAllProducts(
        query: searchController.text.trim(),
        page: page,
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));
    final genderAgeCategory = ref.watch(
      genderAgeCategoryNotifierProvider(genderAgeCategoryFamilyKey),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), bottom: const AppBarBottom()),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchSection(
                    controller: searchController,
                    onSubmitted: (_) => search(
                      category: category,
                      genderAgeCategory: genderAgeCategory,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => search(
                        category: category,
                        genderAgeCategory: genderAgeCategory,
                      ),
                      icon: const Iconify(
                        Majesticons.send,
                        color: Colours.lightThemePrimaryColour,
                      ),
                    ),
                  ),
                  const Gap(20),
                  CategorySelector(
                    categoryNotifierFamilyKey: categoryFamilyKey,
                  ),
                  const Gap(10),
                  if (category.name!.toLowerCase() != 'all') ...[
                    GenderAgeCategorySelector(
                      genderAgeCategoryNotifierFamilyKey:
                          genderAgeCategoryFamilyKey,
                    ),
                    const Gap(10),
                  ],
                ],
              ),
            ),
            Expanded(
              child: SearchViewBody(
                productAdapterFamilyKey: productAdapterFamilyKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
