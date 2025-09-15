import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/src/product/domain/entities/category.dart';

part 'category_notifier.g.dart';

/// A Riverpod state notifier that manages the currently selected [ProductCategory].
///
/// This provider allows the UI to:
/// - Keep track of which category is selected.
/// - Change the active category when the user selects a different one.
///
/// By default, the initial category is set to [ProductCategory.all].
@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  /// Initializes the [CategoryNotifier] with the default category.
  ///
  /// The optional [familyKey] allows scoping different instances of this notifier
  /// to separate widget subtrees (currently unused in this implementation).
  @override
  ProductCategory build([GlobalKey? familyKey]) {
    return const ProductCategory.all();
  }

  /// Updates the selected category.
  ///
  /// - [category]: The new [ProductCategory] to set as the active category.
  ///
  /// If the new category is the same as the current one, no state change occurs.
  void changeCategory(ProductCategory category) {
    if (state != category) state = category;
  }
}
