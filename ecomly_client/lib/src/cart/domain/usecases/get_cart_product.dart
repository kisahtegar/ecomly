import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

class GetCartProduct
    extends FutureUsecaseWithParams<CartProduct, GetCartProductParams> {
  const GetCartProduct(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<CartProduct> call(GetCartProductParams params) =>
      _repo.getCartProduct(
        userId: params.userId,
        cartProductId: params.cartProductId,
      );
}

class GetCartProductParams extends Equatable {
  const GetCartProductParams({
    required this.userId,
    required this.cartProductId,
  });

  final String userId;
  final String cartProductId;

  @override
  List<dynamic> get props => [userId, cartProductId];
}
