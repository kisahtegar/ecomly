import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class GetProducts extends FutureUsecaseWithParams<List<Product>, int> {
  const GetProducts(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(int params) => _repo.getProducts(params);
}
