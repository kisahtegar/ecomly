import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class GetCategories extends FutureUsecaseWithoutParams<List<ProductCategory>> {
  const GetCategories(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<ProductCategory>> call() => _repo.getCategories();
}
