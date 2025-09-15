import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:ecomly_client/src/wishlist/domain/repos/wishlist_repo.dart';

class GetWishlist
    extends FutureUsecaseWithParams<List<WishlistProduct>, String> {
  const GetWishlist(this._repo);

  final WishlistRepo _repo;

  @override
  ResultFuture<List<WishlistProduct>> call(String params) =>
      _repo.getWishlist(params);
}
