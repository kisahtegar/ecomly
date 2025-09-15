import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Represents a product item within a user's shopping cart.
///
/// The [CartProduct] entity encapsulates all product information needed for
/// cart operations, including product details, user selections, cart-specific
/// data, and product availability status.
class CartProduct extends Equatable {
  /// Creates a new [CartProduct] instance with the given details.
  const CartProduct({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    this.selectedSize,
    this.selectedColour,
    required this.productExists,
    required this.productOutOfStock,
  });

  /// Placeholder instance of [CartProduct] with sensible test defaults.
  /// Useful for testing, previews, or initializing empty state.
  const CartProduct.empty()
    : id = "Test String",
      productId = "Test String",
      quantity = 1,
      productName = "Test String",
      productImage = "Test String",
      productPrice = 1,
      selectedSize = null,
      selectedColour = null,
      productExists = true,
      productOutOfStock = true;

  /// Unique identifier for this cart line item.
  final String id;

  /// Identifier of the underlying product this cart item refers to.
  final String productId;

  /// Number of units selected for this product variant in the cart.
  final int quantity;

  /// Human-readable product name at time of adding to cart.
  final String productName;

  /// URL or asset path to the product image thumbnail used in the cart.
  final String productImage;

  /// Unit price of the product when added to cart.
  final double productPrice;

  /// Optional selected size variant (e.g., "M", "42").
  final String? selectedSize;

  /// Optional selected colour variant as a [Color].
  final Color? selectedColour;

  /// Whether the product/variant still exists in catalog.
  final bool productExists;

  /// Whether the product/variant is currently out of stock.
  final bool productOutOfStock;

  @override
  List<dynamic> get props => [
    id,
    productId,
    quantity,
    productName,
    productImage,
    productPrice,
    selectedSize,
    selectedColour,
    productExists,
    productOutOfStock,
  ];
}
