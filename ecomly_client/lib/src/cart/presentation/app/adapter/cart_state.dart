part of 'cart_provider.dart';

/// Represents all possible states for the cart flow.
///
/// These states are used by the `CartProvider` to reflect the current
/// operation (loading, success, error, etc.) in the cart process.
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any cart action begins.
final class CartInitial extends CartState {
  const CartInitial();
}

/// Indicates a product is being added to the cart.
final class AddingToCart extends CartState {
  const AddingToCart();
}

/// Indicates a cart product quantity is being updated.
final class ChangingCartProductQuantity extends CartState {
  const ChangingCartProductQuantity();
}

/// Indicates all cart products are being fetched.
final class FetchingCart extends CartState {
  const FetchingCart();
}

/// Indicates the cart item count is being fetched.
final class FetchingCartCount extends CartState {
  const FetchingCartCount();
}

/// Indicates a specific cart product is being fetched.
final class FetchingCartProduct extends CartState {
  const FetchingCartProduct();
}

/// Indicates a product is being removed from the cart.
final class RemovingFromCart extends CartState {
  const RemovingFromCart();
}

/// Indicates checkout is being initiated.
final class InitiatingCheckout extends CartState {
  const InitiatingCheckout();
}

/// Represents the state when a product has been successfully added to the cart.
final class AddedToCart extends CartState {
  const AddedToCart();
}

/// Represents the state when a cart product's quantity has been successfully updated.
final class ChangedCartProductQuantity extends CartState {
  const ChangedCartProductQuantity();
}

/// Represents the state when all cart products have been successfully fetched.
final class CartFetched extends CartState {
  const CartFetched(this.cart);

  final List<CartProduct> cart;

  @override
  List<Object?> get props => cart;
}

/// Represents the state when the cart item count has been successfully fetched.
final class CartCountFetched extends CartState {
  const CartCountFetched(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

/// Represents the state when a specific cart product has been successfully fetched.
final class CartProductFetched extends CartState {
  const CartProductFetched(this.cartProduct);

  final CartProduct cartProduct;

  @override
  List<Object?> get props => [cartProduct];
}

/// Represents the state when a product has been successfully removed from the cart.
final class RemovedFromCart extends CartState {
  const RemovedFromCart();
}

/// Represents the state when checkout has been successfully initiated.
final class CheckoutInitiated extends CartState {
  const CheckoutInitiated(this.stripeCheckoutSessionUrl);

  final String stripeCheckoutSessionUrl;

  @override
  List<Object?> get props => [stripeCheckoutSessionUrl];
}

/// Represents an error state in any cart-related operation.
final class CartError extends CartState {
  const CartError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
