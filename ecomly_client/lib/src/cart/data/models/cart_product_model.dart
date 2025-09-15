import 'dart:convert';
import 'dart:ui';

import 'package:ecomly_client/core/extensions/colour_extensions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';

/// Data model for cart products.
///
/// Extends the [CartProduct] entity by adding serialization and
/// deserialization logic for API and local storage operations.
/// Used in the data layer to bridge raw data (JSON/maps) with
/// domain entities.
class CartProductModel extends CartProduct {
  /// Creates a new [CartProductModel] with the given details.
  const CartProductModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.productName,
    required super.productImage,
    required super.productPrice,
    required super.productExists,
    required super.productOutOfStock,
    super.selectedSize,
    super.selectedColour,
  });

  /// Placeholder instance with default values.
  ///
  /// Useful for testing, mocking, or representing an empty cart product.
  const CartProductModel.empty()
    : this(
        id: "Test String",
        productId: "Test String",
        quantity: 1,
        productName: "Test String",
        productImage: "Test String",
        productPrice: 1,
        selectedSize: null,
        selectedColour: null,
        productExists: true,
        productOutOfStock: true,
      );

  /// Creates a [CartProductModel] from a JSON string.
  factory CartProductModel.fromJson(String source) =>
      CartProductModel.fromMap(jsonDecode(source) as DataMap);

  /// Creates a [CartProductModel] from a [Map].
  ///
  /// Handles optional fields like `selectedSize`, `selectedColour`,
  /// and fallback values for `productExists` and `productOutOfStock`.
  CartProductModel.fromMap(DataMap map)
    : this(
        id: map['id'] as String? ?? map['_id'] as String,
        productId: map['product'] as String,
        quantity: (map['quantity'] as num).toInt(),
        productName: map['productName'] as String,
        productImage: map['productImage'] as String,
        productPrice: (map['productPrice'] as num).toDouble(),
        selectedSize: map['selectedSize'] as String?,
        selectedColour: (map['selectedColour'] as String?)?.colour,
        productExists: map['productExists'] as bool? ?? true,
        productOutOfStock: map['productOutOfStock'] as bool? ?? false,
      );

  /// Returns a copy of this model with overridden values.
  CartProductModel copyWith({
    String? id,
    String? productId,
    int? quantity,
    String? productName,
    String? productImage,
    double? productPrice,
    String? selectedSize,
    Color? selectedColour,
    bool? productExists,
    bool? productOutOfStock,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColour: selectedColour ?? this.selectedColour,
      productExists: productExists ?? this.productExists,
      productOutOfStock: productOutOfStock ?? this.productOutOfStock,
    );
  }

  /// Converts this model into a [Map] for APIs or persistence.
  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'product': productId,
      'quantity': quantity,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      if (selectedSize != null) 'selectedSize': selectedSize,
      if (selectedColour != null) 'selectedColour': selectedColour!.hex,
    };
  }

  /// Encodes this model into a JSON string.
  String toJson() => jsonEncode(toMap());
}
