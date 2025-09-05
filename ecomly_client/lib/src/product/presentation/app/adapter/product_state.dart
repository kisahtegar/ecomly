part of 'product_adapter.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class FetchingProducts extends ProductState {
  const FetchingProducts();
}

final class Searching extends ProductState {
  const Searching();
}

final class FetchingReviews extends ProductState {
  const FetchingReviews();
}

final class FetchingCategories extends ProductState {
  const FetchingCategories();
}

final class FetchingCategory extends ProductState {
  const FetchingCategory();
}

final class FetchingProduct extends ProductState {
  const FetchingProduct();
}

final class Reviewing extends ProductState {
  const Reviewing();
}

final class ProductsFetched extends ProductState {
  const ProductsFetched(this.products);

  final List<Product> products;

  @override
  List<Object> get props => products;
}

final class CategoriesFetched extends ProductState {
  const CategoriesFetched(this.categories);

  final List<ProductCategory> categories;

  @override
  List<Object> get props => categories;
}

final class ReviewsFetched extends ProductState {
  const ReviewsFetched(this.reviews);

  final List<Review> reviews;

  @override
  List<Object> get props => reviews;
}

final class CategoryFetched extends ProductState {
  const CategoryFetched(this.category);

  final ProductCategory category;

  @override
  List<Object> get props => [category];
}

final class ProductFetched extends ProductState {
  const ProductFetched(this.product);

  final Product product;

  @override
  List<Object> get props => [product];
}

final class ProductReviewed extends ProductState {
  const ProductReviewed();
}

final class ProductError extends ProductState {
  const ProductError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
