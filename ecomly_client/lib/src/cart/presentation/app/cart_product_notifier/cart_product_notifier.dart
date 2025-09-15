import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_product_notifier.g.dart';

/// Provider responsible for managing the selection state of cart products.
///
/// This notifier tracks which cart products (by their IDs) are selected,
/// allowing the UI to perform bulk actions such as multi-remove or selective
/// checkout.
///
/// Exposes methods to select, deselect, and reset selections.
@riverpod
class CartProductNotifier extends _$CartProductNotifier {
  /// Initializes the selection state.
  ///
  /// By default, no products are selected, so it returns an empty list.
  @override
  List<String> build() {
    return [];
  }

  /// Marks a single product as selected.
  ///
  /// - [cartProductId]: The ID of the product to select.
  /// - Does nothing if the product is already selected.
  void selectProduct(String cartProductId) {
    if (!state.contains(cartProductId)) {
      state = [...state, cartProductId];
    }
  }

  /// Removes a single product from the selection.
  ///
  /// - [cartProductId]: The ID of the product to deselect.
  void deselectProduct(String cartProductId) {
    state = state.where((id) => id != cartProductId).toList();
  }

  /// Marks all given products as selected.
  ///
  /// - [cartProducts]: An iterable of product IDs to select.
  /// - Duplicates are automatically removed by converting to a [Set].
  void selectAll(Iterable<String> cartProducts) {
    state.addAll(cartProducts);
    state = state.toSet().toList();
  }

  /// Clears the entire selection.
  void deselectAll() => state = [];
}
