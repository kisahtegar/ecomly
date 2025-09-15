import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

/// Use case for initiating a checkout session.
///
/// Delegates to [CartRepo.initiateCheckout] with the given theme and cart items.
class InitiateCheckout
    extends FutureUsecaseWithParams<String, InitiateCheckoutParams> {
  const InitiateCheckout(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<String> call(InitiateCheckoutParams params) =>
      _repo.initiateCheckout(theme: params.theme, cartItems: params.cartItems);
}

/// Parameters for [InitiateCheckout].
///
/// Contains the checkout [theme] and the list of [cartItems].
class InitiateCheckoutParams extends Equatable {
  const InitiateCheckoutParams({required this.theme, required this.cartItems});

  final String theme;
  final List<CartProduct> cartItems;

  @override
  List<Object?> get props => [theme, ...cartItems];
}
