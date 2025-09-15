import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class GetProduct extends FutureUsecaseWithParams<Product, String> {
  const GetProduct(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<Product> call(String params) => _repo.getProduct(params);
}
