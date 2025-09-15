import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

/// Use case for retrieving the total item count in a user's cart.
///
/// Delegates to [CartRepo.getCartCount] with the given user ID.
class GetCartCount extends FutureUsecaseWithParams<int, String> {
  const GetCartCount(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<int> call(String params) => _repo.getCartCount(params);
}
