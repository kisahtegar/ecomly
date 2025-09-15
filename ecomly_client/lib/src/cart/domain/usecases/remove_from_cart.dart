import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

/// Use case for removing a product from the cart.
///
/// Delegates to [CartRepo.removeFromCart] with the provided user and product IDs.
class RemoveFromCart
    extends FutureUsecaseWithParams<void, RemoveFromCartParams> {
  const RemoveFromCart(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<void> call(RemoveFromCartParams params) => _repo.removeFromCart(
    userId: params.userId,
    cartProductId: params.cartProductId,
  );
}

/// Parameters for [RemoveFromCart].
///
/// Contains [userId] and [cartProductId] to identify the cart item to remove.
class RemoveFromCartParams extends Equatable {
  const RemoveFromCartParams({
    required this.userId,
    required this.cartProductId,
  });

  final String userId;
  final String cartProductId;

  @override
  List<dynamic> get props => [userId, cartProductId];
}
