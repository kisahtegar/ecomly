import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/src/home/presentation/sections/categories_section.dart';
import 'package:ecomly_client/src/home/presentation/sections/home_app_bar.dart';
import 'package:ecomly_client/src/home/presentation/sections/products_section.dart';
import 'package:ecomly_client/src/home/presentation/sections/search_section.dart';
import 'package:ecomly_client/src/home/presentation/widgets/promo_banner.dart';
import 'package:ecomly_client/src/product/presentation/views/all_new_arrivals_view.dart';
import 'package:ecomly_client/src/product/presentation/views/all_popular_products_view.dart';
import 'package:ecomly_client/src/product/presentation/views/search_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Gap(40),
            SearchSection(
              readOnly: true,
              onTap: () => context.push(SearchView.path),
            ),
            const Gap(20),
            Expanded(
              child: ListView(
                children: [
                  const PromoBanner(),
                  const Gap(20),
                  const CategoriesSection(),
                  const Gap(20),
                  ProductsSection.popular(
                    onViewAll: () {
                      context.go(
                        '${HomeView.path}/${AllPopularProductsView.path}',
                      );
                    },
                  ),
                  const Gap(20),
                  ProductsSection.newArrivals(
                    onViewAll: () {
                      context.go('${HomeView.path}/${AllNewArrivalsView.path}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
