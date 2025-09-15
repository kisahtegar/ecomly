import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/domain/repos/wishlist_repo.dart';

class AddToWishlist extends FutureUsecaseWithParams<void, AddToWishlistParams> {
  const AddToWishlist(this._repo);

  final WishlistRepo _repo;

  @override
  ResultFuture<void> call(AddToWishlistParams params) =>
      _repo.addToWishlist(userId: params.userId, productId: params.productId);
}

class AddToWishlistParams extends Equatable {
  const AddToWishlistParams({required this.userId, required this.productId});

  final String userId;
  final String productId;

  @override
  List<dynamic> get props => [userId, productId];
}
