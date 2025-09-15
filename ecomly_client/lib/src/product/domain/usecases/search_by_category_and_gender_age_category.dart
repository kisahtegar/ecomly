import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/usecase/usecase.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/repos/product_repo.dart';

class SearchByCategoryAndGenderAgeCategory
    extends
        FutureUsecaseWithParams<
          List<Product>,
          SearchByCategoryAndGenderAgeCategoryParams
        > {
  const SearchByCategoryAndGenderAgeCategory(this._repo);

  final ProductRepo _repo;

  @override
  ResultFuture<List<Product>> call(
    SearchByCategoryAndGenderAgeCategoryParams params,
  ) => _repo.searchByCategoryAndGenderAgeCategory(
    query: params.query,
    categoryId: params.categoryId,
    genderAgeCategory: params.genderAgeCategory,
    page: params.page,
  );
}

class SearchByCategoryAndGenderAgeCategoryParams extends Equatable {
  const SearchByCategoryAndGenderAgeCategoryParams({
    required this.query,
    required this.categoryId,
    required this.genderAgeCategory,
    required this.page,
  });

  final String query;
  final String categoryId;
  final String genderAgeCategory;
  final int page;

  @override
  List<dynamic> get props => [query, categoryId, genderAgeCategory, page];
}
