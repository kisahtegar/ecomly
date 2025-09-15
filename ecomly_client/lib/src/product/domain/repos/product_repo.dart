import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/entities/review.dart';

/// Abstract repository defining product data operations.
///
/// This repository follows the Repository Pattern from Clean Architecture,
/// abstracting product-related data operations from their concrete implementations.
/// It defines contracts for retrieving products, categories, search functionality,
/// and managing customer reviews.
abstract interface class ProductRepo {
  /// Retrieves a paginated list of all products.
  ///
  /// - [page]: The page number to fetch (for pagination).
  ///
  /// Returns a list of [Product] entities containing product details
  /// such as name, description, price, stock, and category.
  ResultFuture<List<Product>> getProducts(int page);

  /// Retrieves detailed information about a single product.
  ///
  /// - [productId]: The unique identifier of the product.
  ///
  /// Returns a [Product] entity with full product details.
  ResultFuture<Product> getProduct(String productId);

  /// Retrieves products belonging to a specific category.
  ///
  /// - [categoryId]: The ID of the category to filter products by.
  /// - [page]: The page number to fetch (for pagination).
  ///
  /// Returns a list of [Product] entities filtered by category.
  ResultFuture<List<Product>> getProductsByCategory({
    required String categoryId,
    required int page,
  });

  /// Retrieves the latest arrival products.
  ///
  /// - [page]: The page number to fetch (for pagination).
  /// - [categoryId]: Optional. If provided, results are filtered by category.
  ///
  /// Returns a paginated list of [Product] entities that were
  /// recently added to the catalog.
  ResultFuture<List<Product>> getNewArrivals({
    required int page,
    String? categoryId,
  });

  /// Retrieves popular or trending products.
  ///
  /// - [page]: The page number to fetch (for pagination).
  /// - [categoryId]: Optional. If provided, results are filtered by category.
  ///
  /// Returns a paginated list of [Product] entities marked as
  /// popular or best-selling.
  ResultFuture<List<Product>> getPopular({
    required int page,
    String? categoryId,
  });

  /// Searches for products across all categories.
  ///
  /// - [query]: The search keyword or phrase.
  /// - [page]: The page number to fetch (for pagination).
  ///
  /// Returns a paginated list of [Product] entities that match the query.
  ResultFuture<List<Product>> searchAllProducts({
    required String query,
    required int page,
  });

  /// Searches for products within a specific category.
  ///
  /// - [query]: The search keyword or phrase.
  /// - [categoryId]: The ID of the category to filter results by.
  /// - [page]: The page number to fetch (for pagination).
  ///
  /// Returns a paginated list of [Product] entities matching the query
  /// within the specified category.
  ResultFuture<List<Product>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  });

  /// Searches for products within a category and gender/age category.
  ///
  /// - [query]: The search keyword or phrase.
  /// - [categoryId]: The ID of the category to filter results by.
  /// - [genderAgeCategory]: Additional filter by gender/age group
  ///   (e.g., "Men", "Women", "Kids").
  /// - [page]: The page number to fetch (for pagination).
  ///
  /// Returns a paginated list of [Product] entities matching the filters.
  ResultFuture<List<Product>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  });

  /// Retrieves all available product categories.
  ///
  /// Returns a list of [ProductCategory] entities, which include
  /// category IDs, names, colours, and optional images.
  ResultFuture<List<ProductCategory>> getCategories();

  /// Retrieves details of a specific category.
  ///
  /// - [categoryId]: The ID of the category to fetch.
  ///
  /// Returns a [ProductCategory] entity with detailed information.
  ResultFuture<ProductCategory> getCategory(String categoryId);

  /// Submits a product review.
  ///
  /// - [productId]: The ID of the product being reviewed.
  /// - [userId]: The ID of the user leaving the review.
  /// - [comment]: The review text content.
  /// - [rating]: The rating given by the user (typically 1–5).
  ///
  /// Allows a user to leave a review on a product.
  ResultFuture<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  });

  /// Retrieves reviews for a specific product.
  ///
  /// - [productId]: The ID of the product whose reviews should be fetched.
  /// - [page]: The page number to fetch (for pagination).
  ///
  /// Returns a paginated list of [Review] entities associated with the product.
  ResultFuture<List<Review>> getProductReviews({
    required String productId,
    required int page,
  });
}
