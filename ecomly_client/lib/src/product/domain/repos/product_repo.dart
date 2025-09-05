import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/product/domain/entities/category.dart';
import 'package:ecomly_client/src/product/domain/entities/product.dart';
import 'package:ecomly_client/src/product/domain/entities/review.dart';

abstract interface class ProductRepo {
  ResultFuture<List<Product>> getProducts(int page);

  ResultFuture<Product> getProduct(String productId);

  ResultFuture<List<Product>> getProductsByCategory({
    required String categoryId,
    required int page,
  });

  ResultFuture<List<Product>> getNewArrivals({
    required int page,
    String? categoryId,
  });

  ResultFuture<List<Product>> getPopular({
    required int page,
    String? categoryId,
  });

  ResultFuture<List<Product>> searchAllProducts({
    required String query,
    required int page,
  });

  ResultFuture<List<Product>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  });

  ResultFuture<List<Product>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  });

  ResultFuture<List<ProductCategory>> getCategories();

  ResultFuture<ProductCategory> getCategory(String categoryId);

  ResultFuture<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  });

  ResultFuture<List<Review>> getProductReviews({
    required String productId,
    required int page,
  });
}
