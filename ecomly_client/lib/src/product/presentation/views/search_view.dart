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

/// Screen for searching products with optional filters:
/// - **Search query** (text-based).
/// - **Category filter**.
/// - **Gender/Age filter** (only applied if category ≠ "All").
///
/// ### How it works:
/// - If category = "All": performs [ProductAdapter.searchAllProducts].
/// - If category ≠ "All" and genderAgeCategory = "All":
///   performs [ProductAdapter.searchByCategory].
/// - If both category and genderAgeCategory ≠ "All":
///   performs [ProductAdapter.searchByCategoryAndGenderAgeCategory].
///
/// Results are displayed inside [SearchViewBody].
class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  /// The router path for this view.
  static const path = '/search';

  @override
  ConsumerState createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  /// Family key for managing the selected category.
  final categoryFamilyKey = GlobalKey();

  /// Family key for managing the selected gender/age category.
  final genderAgeCategoryFamilyKey = GlobalKey();

  /// Family key for the product adapter handling search requests.
  final productAdapterFamilyKey = GlobalKey();

  /// Controller for the search text field.
  final searchController = TextEditingController();

  /// Current pagination page for search requests.
  int page = 1;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Executes a product search using the appropriate adapter method.
  ///
  /// - If [category] = "All" → search across all products.
  /// - If [category] != "All" but [genderAgeCategory] = "All", search within the category only.
  /// - If both != "All" → filter by both category and gender/age.
  void search({
    required ProductCategory category,
    required GenderAgeCategory genderAgeCategory,
  }) {
    final productAdapter = ref.read(
      productAdapterProvider(productAdapterFamilyKey).notifier,
    );

    if (category.name!.toLowerCase() != 'all') {
      if (genderAgeCategory.title.toLowerCase() != 'all') {
        // Category + Gender/Age filter
        productAdapter.searchByCategoryAndGenderAgeCategory(
          query: searchController.text.trim(),
          categoryId: category.id,
          genderAgeCategory: genderAgeCategory.title.toLowerCase(),
          page: page,
        );
      } else {
        // Category only
        productAdapter.searchByCategory(
          query: searchController.text.trim(),
          categoryId: category.id,
          page: page,
        );
      }
    } else {
      // Search across all products
      productAdapter.searchAllProducts(
        query: searchController.text.trim(),
        page: page,
      );
    }
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
            /// Search input + filters
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Search bar
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

                  /// Category selector
                  CategorySelector(
                    categoryNotifierFamilyKey: categoryFamilyKey,
                  ),
                  const Gap(10),

                  /// Gender/Age selector (only if category ≠ "All")
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

            /// Search results
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
