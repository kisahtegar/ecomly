import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/src/product/domain/entities/category.dart';

part 'category_notifier.g.dart';

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  ProductCategory build([GlobalKey? familyKey]) {
    return const ProductCategory.all();
  }

  void changeCategory(ProductCategory category) {
    if (state != category) state = category;
  }
}
