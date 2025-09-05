import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class GetProductsByCategory
    extends
        FutureUsecaseWithParams<List<Product>, GetProductsByCategoryParams> {
  const GetProductsByCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(GetProductsByCategoryParams params) => _repo
      .getProductsByCategory(categoryId: params.categoryId, page: params.page);
}

class GetProductsByCategoryParams extends Equatable {
  const GetProductsByCategoryParams({
    required this.categoryId,
    required this.page,
  });

  final String categoryId;
  final int page;

  @override
  List<Object?> get props => [categoryId, page];
}
