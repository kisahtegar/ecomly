import 'package:equatable/equatable.dart';

/// Represents a product stored in the user's wishlist.
///
/// This is a **domain entity**, meaning it models business data without being
/// tied to any framework or data source. It is used across the application
/// wherever wishlist product details are required.
class WishlistProduct extends Equatable {
  /// Creates a [WishlistProduct] with the given properties.
  const WishlistProduct({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productExists,
    required this.productOutOfStock,
  });

  /// Provides a default placeholder product, useful for testing or initializing
  /// UI with mock data.
  const WishlistProduct.empty()
    : productId = "Test String",
      productName = "Test String",
      productImage = "Test String",
      productPrice = 1.0,
      productExists = true,
      productOutOfStock = true;

  /// Unique identifier for the product.
  final String productId;

  /// The human-readable name of the product.
  final String productName;

  /// A URL pointing to the product image.
  final String productImage;

  /// The price of the product in the default currency.
  final double productPrice;

  /// Whether the product still exists in the system (not deleted/removed).
  final bool productExists;

  /// Whether the product is currently out of stock.
  final bool productOutOfStock;

  @override
  List<dynamic> get props => [
    productId,
    productName,
    productImage,
    productPrice,
    productExists,
    productOutOfStock,
  ];
}
