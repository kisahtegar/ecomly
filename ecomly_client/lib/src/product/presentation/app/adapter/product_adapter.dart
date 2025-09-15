import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/entities/review.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_categories.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_category.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_new_arrivals.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_popular.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_product.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_product_reviews.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_products.dart';
import 'package:ecomly_client/src/product/domain/usecases/get_products_by_category.dart';
import 'package:ecomly_client/src/product/domain/usecases/leave_review.dart';
import 'package:ecomly_client/src/product/domain/usecases/search_all_products.dart';
import 'package:ecomly_client/src/product/domain/usecases/search_by_category.dart';
import 'package:ecomly_client/src/product/domain/usecases/search_by_category_and_gender_age_category.dart';

part 'product_adapter.g.dart';
part 'product_state.dart';

/// Provider responsible for managing product-related operations.
///
/// It connects domain use cases with the UI layer by exposing methods that
/// update the [ProductState]. Each method sets a "loading" state before the
/// async call, then transitions to either a success state (e.g., [ProductsFetched],
/// [ProductFetched], etc.) or [ProductError] on failure.
@riverpod
class ProductAdapter extends _$ProductAdapter {
  /// Initializes dependencies and sets the initial state.
  ///
  /// The optional [familyKey] allows scoping multiple instances of this provider
  /// for different parts of the app, but is unused in this implementation.
  @override
  ProductState build([GlobalKey? familyKey]) {
    _getCategories = sl<GetCategories>();
    _getCategory = sl<GetCategory>();
    _getNewArrivals = sl<GetNewArrivals>();
    _getPopular = sl<GetPopular>();
    _getProduct = sl<GetProduct>();
    _getProductReviews = sl<GetProductReviews>();
    _getProducts = sl<GetProducts>();
    _getProductsByCategory = sl<GetProductsByCategory>();
    _leaveReview = sl<LeaveReview>();
    _searchAllProducts = sl<SearchAllProducts>();
    _searchByCategory = sl<SearchByCategory>();
    _searchByCategoryAndGenderAgeCategory =
        sl<SearchByCategoryAndGenderAgeCategory>();
    return const ProductInitial();
  }

  late GetCategories _getCategories;
  late GetCategory _getCategory;
  late GetNewArrivals _getNewArrivals;
  late GetPopular _getPopular;
  late GetProduct _getProduct;
  late GetProductReviews _getProductReviews;
  late GetProducts _getProducts;
  late GetProductsByCategory _getProductsByCategory;
  late LeaveReview _leaveReview;
  late SearchAllProducts _searchAllProducts;
  late SearchByCategory _searchByCategory;
  late SearchByCategoryAndGenderAgeCategory
  _searchByCategoryAndGenderAgeCategory;

  /// Fetches all product categories.
  ///
  /// - Sets state to [FetchingCategories] while loading.
  /// - On success: emits [CategoriesFetched].
  /// - On failure: emits [ProductError].
  Future<void> getCategories() async {
    state = const FetchingCategories();
    final result = await _getCategories();

    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (categories) => state = CategoriesFetched(categories),
    );
  }

  /// Fetches a single product category by [categoryId].
  ///
  /// - Sets state to [FetchingCategory] while loading.
  /// - On success: emits [CategoryFetched].
  /// - On failure: emits [ProductError].
  Future<void> getCategory(String categoryId) async {
    state = const FetchingCategory();
    final result = await _getCategory(categoryId);
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (category) => state = CategoryFetched(category),
    );
  }

  /// Fetches new arrival products.
  ///
  /// - [page]: The page number for pagination.
  /// - [categoryId]: Optional category filter.
  /// - Sets state to [FetchingProducts] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> getNewArrivals({required int page, String? categoryId}) async {
    state = const FetchingProducts();
    final result = await _getNewArrivals(
      GetNewArrivalsParams(page: page, categoryId: categoryId),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  /// Fetches popular products.
  ///
  /// - [page]: The page number for pagination.
  /// - [categoryId]: Optional category filter.
  /// - Sets state to [FetchingProducts] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> getPopular({required int page, String? categoryId}) async {
    state = const FetchingProducts();
    final result = await _getPopular(
      GetPopularParams(page: page, categoryId: categoryId),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  /// Fetches a single product by its [productId].
  ///
  /// - Sets state to [FetchingProduct] while loading.
  /// - On success: emits [ProductFetched].
  /// - On failure: emits [ProductError].
  Future<void> getProduct(String productId) async {
    state = const FetchingProduct();
    final result = await _getProduct(productId);
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (product) => state = ProductFetched(product),
    );
  }

  /// Fetches reviews for a product.
  ///
  /// - [productId]: The product ID.
  /// - [page]: The page number for pagination.
  /// - Sets state to [FetchingReviews] while loading.
  /// - On success: emits [ReviewsFetched].
  /// - On failure: emits [ProductError].
  Future<void> getProductReviews({
    required String productId,
    required int page,
  }) async {
    state = const FetchingReviews();
    final result = await _getProductReviews(
      GetProductReviewsParams(productId: productId, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (reviews) => state = ReviewsFetched(reviews),
    );
  }

  /// Fetches all products with pagination.
  ///
  /// - [page]: The page number.
  /// - Sets state to [FetchingProducts] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> getProducts(int page) async {
    state = const FetchingProducts();
    final result = await _getProducts(page);
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  /// Fetches products filtered by [categoryId].
  ///
  /// - [page]: The page number for pagination.
  /// - Sets state to [FetchingProducts] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> getProductsByCategory({
    required String categoryId,
    required int page,
  }) async {
    state = const FetchingProducts();
    final result = await _getProductsByCategory(
      GetProductsByCategoryParams(categoryId: categoryId, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  /// Submits a review for a product.
  ///
  /// - [productId]: The product being reviewed.
  /// - [userId]: The user submitting the review.
  /// - [comment]: The review content.
  /// - [rating]: The numerical rating (e.g., 1–5).
  /// - Sets state to [Reviewing] while loading.
  /// - On success: emits [ProductReviewed].
  /// - On failure: emits [ProductError].
  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  }) async {
    state = const Reviewing();
    final result = await _leaveReview(
      LeaveReviewParams(
        productId: productId,
        userId: userId,
        comment: comment,
        rating: rating,
      ),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (_) => state = const ProductReviewed(),
    );
  }

  /// Searches all products by a query string.
  ///
  /// - [query]: The search keyword.
  /// - [page]: The page number.
  /// - Sets state to [Searching] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> searchAllProducts({
    required String query,
    required int page,
  }) async {
    state = const Searching();
    final result = await _searchAllProducts(
      SearchAllProductsParams(query: query, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  /// Searches products by category.
  ///
  /// - [query]: The search keyword.
  /// - [categoryId]: The category ID to filter by.
  /// - [page]: The page number.
  /// - Sets state to [Searching] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  }) async {
    state = const Searching();
    final result = await _searchByCategory(
      SearchByCategoryParams(query: query, categoryId: categoryId, page: page),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }

  /// Searches products by category and gender/age group.
  ///
  /// - [query]: The search keyword.
  /// - [categoryId]: The category ID to filter by.
  /// - [genderAgeCategory]: A gender/age filter (e.g., "Men", "Women", "Kids").
  /// - [page]: The page number.
  /// - Sets state to [Searching] while loading.
  /// - On success: emits [ProductsFetched].
  /// - On failure: emits [ProductError].
  Future<void> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  }) async {
    state = const Searching();
    final result = await _searchByCategoryAndGenderAgeCategory(
      SearchByCategoryAndGenderAgeCategoryParams(
        query: query,
        categoryId: categoryId,
        genderAgeCategory: genderAgeCategory,
        page: page,
      ),
    );
    result.fold(
      (failure) => state = ProductError(failure.errorMessage),
      (products) => state = ProductsFetched(products),
    );
  }
}
