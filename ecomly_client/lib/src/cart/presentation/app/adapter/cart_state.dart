part of 'cart_provider.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class AddingToCart extends CartState {
  const AddingToCart();
}

final class ChangingCartProductQuantity extends CartState {
  const ChangingCartProductQuantity();
}

final class FetchingCart extends CartState {
  const FetchingCart();
}

final class FetchingCartCount extends CartState {
  const FetchingCartCount();
}

final class FetchingCartProduct extends CartState {
  const FetchingCartProduct();
}

final class RemovingFromCart extends CartState {
  const RemovingFromCart();
}

final class InitiatingCheckout extends CartState {
  const InitiatingCheckout();
}

final class AddedToCart extends CartState {
  const AddedToCart();
}

final class ChangedCartProductQuantity extends CartState {
  const ChangedCartProductQuantity();
}

final class CartFetched extends CartState {
  const CartFetched(this.cart);

  final List<CartProduct> cart;

  @override
  List<Object?> get props => cart;
}

final class CartCountFetched extends CartState {
  const CartCountFetched(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}

final class CartProductFetched extends CartState {
  const CartProductFetched(this.cartProduct);

  final CartProduct cartProduct;

  @override
  List<Object?> get props => [cartProduct];
}

final class RemovedFromCart extends CartState {
  const RemovedFromCart();
}

final class CheckoutInitiated extends CartState {
  const CheckoutInitiated(this.stripeCheckoutSessionUrl);

  final String stripeCheckoutSessionUrl;

  @override
  List<Object?> get props => [stripeCheckoutSessionUrl];
}

final class CartError extends CartState {
  const CartError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
