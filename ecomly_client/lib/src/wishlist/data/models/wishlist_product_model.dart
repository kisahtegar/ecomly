import 'dart:convert';

import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/domain/entities/wishlist_product.dart';

/// Data model for [WishlistProduct].
///
/// This ensures smooth communication between the app and external data sources
/// such as APIs or local storage.
class WishlistProductModel extends WishlistProduct {
  /// Creates a [WishlistProductModel] with the given fields.
  const WishlistProductModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.productExists,
    required super.productOutOfStock,
    required super.productPrice,
  });

  /// Provides a placeholder instance, useful for testing or as default UI data.
  const WishlistProductModel.empty()
    : this(
        productId: "Test String",
        productName: "Test String",
        productImage: "Test String",
        productPrice: 1.0,
        productExists: true,
        productOutOfStock: true,
      );

  /// Creates a [WishlistProductModel] from a JSON string.
  factory WishlistProductModel.fromJson(String source) =>
      WishlistProductModel.fromMap(jsonDecode(source) as DataMap);

  /// Creates a [WishlistProductModel] from a map (decoded JSON).
  WishlistProductModel.fromMap(DataMap map)
    : this(
        productId: map['productId'] as String,
        productName: map['productName'] as String,
        productImage: map['productImage'] as String,
        productPrice: (map['productPrice'] as num).toDouble(),
        productExists: map['productExists'] as bool? ?? true,
        productOutOfStock: map['productOutOfStock'] as bool? ?? false,
      );

  /// Returns a new [WishlistProductModel] with updated values. Any property not
  /// provided will retain its current value.
  WishlistProductModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? productPrice,
    bool? productExists,
    bool? productOutOfStock,
  }) {
    return WishlistProductModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productPrice: productPrice ?? this.productPrice,
      productExists: productExists ?? this.productExists,
      productOutOfStock: productOutOfStock ?? this.productOutOfStock,
    );
  }

  /// Converts the model into a [Map] for JSON encoding or local storage.
  DataMap toMap() {
    return <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productPrice': productPrice,
      'productExists': productExists,
      'productOutOfStock': productOutOfStock,
    };
  }

  /// Converts the model into a JSON string.
  String toJson() => jsonEncode(toMap());
}
