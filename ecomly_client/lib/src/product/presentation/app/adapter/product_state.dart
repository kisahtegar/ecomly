part of 'product_adapter.dart';

/// Base class for all product-related states.
///
/// This sealed class is extended by specific states that represent the
/// current status of product, category, or review operations in the
/// presentation layer.
sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// The initial state before any product-related operation begins.
final class ProductInitial extends ProductState {
  const ProductInitial();
}

/// State when products are being fetched from the repository.
final class FetchingProducts extends ProductState {
  const FetchingProducts();
}

/// State when a search operation is in progress.
final class Searching extends ProductState {
  const Searching();
}

/// State when reviews for a product are being fetched.
final class FetchingReviews extends ProductState {
  const FetchingReviews();
}

/// State when all categories are being fetched.
final class FetchingCategories extends ProductState {
  const FetchingCategories();
}

/// State when a specific category is being fetched by ID.
final class FetchingCategory extends ProductState {
  const FetchingCategory();
}

/// State when a single product is being fetched by ID.
final class FetchingProduct extends ProductState {
  const FetchingProduct();
}

/// State when a review is being submitted for a product.
final class Reviewing extends ProductState {
  const Reviewing();
}

/// State when a list of products has been successfully fetched.
///
/// Contains a list of [Product] entities.
final class ProductsFetched extends ProductState {
  const ProductsFetched(this.products);

  final List<Product> products;

  @override
  List<Object> get props => products;
}

/// State when product categories have been successfully fetched.
///
/// Contains a list of [ProductCategory] entities.
final class CategoriesFetched extends ProductState {
  const CategoriesFetched(this.categories);

  final List<ProductCategory> categories;

  @override
  List<Object> get props => categories;
}

/// State when reviews for a product have been successfully fetched.
///
/// Contains a list of [Review] entities.
final class ReviewsFetched extends ProductState {
  const ReviewsFetched(this.reviews);

  final List<Review> reviews;

  @override
  List<Object> get props => reviews;
}

/// State when a single category has been successfully fetched.
///
/// Contains the [ProductCategory] entity.
final class CategoryFetched extends ProductState {
  const CategoryFetched(this.category);

  final ProductCategory category;

  @override
  List<Object> get props => [category];
}

/// State when a single product has been successfully fetched.
///
/// Contains the [Product] entity.
final class ProductFetched extends ProductState {
  const ProductFetched(this.product);

  final Product product;

  @override
  List<Object> get props => [product];
}

/// State when a review has been successfully submitted for a product.
final class ProductReviewed extends ProductState {
  const ProductReviewed();
}

/// State representing an error during any product-related operation.
///
/// Contains an error [message] describing what went wrong.
final class ProductError extends ProductState {
  const ProductError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
