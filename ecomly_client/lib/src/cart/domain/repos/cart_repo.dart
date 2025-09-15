import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';

/// Abstract repository defining cart data operations.
///
/// This repository follows the Repository Pattern from Clean Architecture,
/// abstracting cart-related data operations from their concrete implementations.
/// It defines contracts for managing cart items, quantities, and checkout processes.
abstract class CartRepo {
  /// Retrieves all cart items for the specified user.
  ///
  /// Returns a list of [CartProduct] entities representing all items
  /// currently in the user's cart, including product details, quantities,
  /// and selected variants.
  ResultFuture<List<CartProduct>> getCart(String userId);

  /// Gets the total count of items in the user's cart.
  ///
  /// Returns the sum of all product quantities in the cart, useful for
  /// displaying cart badges or quick counts in the UI.
  ResultFuture<int> getCartCount(String userId);

  /// Retrieves a specific cart product by its cart item ID.
  ///
  /// Used to fetch detailed information about a single cart line item,
  /// typically for editing or detailed views.
  ResultFuture<CartProduct> getCartProduct({
    required String userId,
    required String cartProductId,
  });

  /// Adds a new product to the user's cart.
  ///
  /// If the same product with identical variants already exists, the
  /// implementation should handle quantity merging or replacement
  /// based on business rules.
  ResultFuture<void> addToCart({
    required String userId,
    required CartProduct cartProduct,
  });

  /// Removes a specific cart item completely.
  ///
  /// Deletes the cart line item identified by [cartProductId] regardless of its
  /// current quantity.
  ResultFuture<void> removeFromCart({
    required String userId,
    required String cartProductId,
  });

  /// Updates the quantity of an existing cart item.
  ///
  /// Changes the quantity of the specified cart product to [newQuantity].
  /// If [newQuantity] is 0 or negative, the implementation may choose
  /// to remove the item entirely.
  ResultFuture<void> changeCartProductQuantity({
    required String userId,
    required String cartProductId,
    required int newQuantity,
  });

  /// Initiates the checkout process for the given cart items.
  ///
  /// Creates a checkout session and returns a checkout URL or session ID
  /// that can be used to redirect the user to the payment flow. The [theme]
  /// parameter may influence the checkout UI appearance.
  ResultFuture<String> initiateCheckout({
    required String theme,
    required List<CartProduct> cartItems,
  });
}
