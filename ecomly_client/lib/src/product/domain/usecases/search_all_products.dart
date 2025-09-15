import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class SearchAllProducts
    extends FutureUsecaseWithParams<List<Product>, SearchAllProductsParams> {
  const SearchAllProducts(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(SearchAllProductsParams params) =>
      _repo.searchAllProducts(query: params.query, page: params.page);
}

class SearchAllProductsParams extends Equatable {
  const SearchAllProductsParams({required this.query, required this.page});

  final String query;
  final int page;

  @override
  List<dynamic> get props => [query, page];
}
