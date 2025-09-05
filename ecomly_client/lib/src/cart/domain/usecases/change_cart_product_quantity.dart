import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

class ChangeCartProductQuantity
    extends FutureUsecaseWithParams<void, ChangeCartProductQuantityParams> {
  const ChangeCartProductQuantity(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<void> call(ChangeCartProductQuantityParams params) =>
      _repo.changeCartProductQuantity(
        userId: params.userId,
        cartProductId: params.cartProductId,
        newQuantity: params.newQuantity,
      );
}

class ChangeCartProductQuantityParams extends Equatable {
  const ChangeCartProductQuantityParams({
    required this.userId,
    required this.cartProductId,
    required this.newQuantity,
  });

  final String userId;
  final String cartProductId;
  final int newQuantity;

  @override
  List<dynamic> get props => [userId, cartProductId, newQuantity];
}
