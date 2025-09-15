import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/domain/repos/wishlist_repo.dart';

class RemoveFromWishlist
    extends FutureUsecaseWithParams<void, RemoveFromWishlistParams> {
  const RemoveFromWishlist(this._repo);

  final WishlistRepo _repo;

  @override
  ResultFuture<void> call(RemoveFromWishlistParams params) => _repo
      .removeFromWishlist(userId: params.userId, productId: params.productId);
}

class RemoveFromWishlistParams extends Equatable {
  const RemoveFromWishlistParams({
    required this.userId,
    required this.productId,
  });

  final String userId;
  final String productId;

  @override
  List<dynamic> get props => [userId, productId];
}
