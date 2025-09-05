import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly_client/src/cart/domain/repos/cart_repo.dart';

class GetCart extends FutureUsecaseWithParams<List<CartProduct>, String> {
  const GetCart(this._repo);

  final CartRepo _repo;

  @override
  ResultFuture<List<CartProduct>> call(String params) => _repo.getCart(params);
}
