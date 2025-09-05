import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class GetCategory extends FutureUsecaseWithParams<ProductCategory, String> {
  const GetCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<ProductCategory> call(String params) =>
      _repo.getCategory(params);
}
