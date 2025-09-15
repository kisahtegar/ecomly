import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

/// Use case for adding a product to the user's shopping cart.
///
/// This use case handles the business logic of adding a [CartProduct] to a
/// specific user's cart. It coordinates with the [CartRepo] to persist the
/// cart item and handles any business rules around cart operations.
class AddToCart extends FutureUsecaseWithParams<void, AddToCartParams> {
  const AddToCart(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<void> call(AddToCartParams params) =>
      _repo.addToCart(userId: params.userId, cartProduct: params.cartProduct);
}

/// Parameters required for the [AddToCart] use case.
class AddToCartParams extends Equatable {
  const AddToCartParams({required this.userId, required this.cartProduct});

  final String userId;
  final CartProduct cartProduct;

  @override
  List<dynamic> get props => [userId, cartProduct];
}
