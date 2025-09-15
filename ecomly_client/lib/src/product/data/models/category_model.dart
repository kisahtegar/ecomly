import 'package:ecomly_client/src/product/domain/entities/category.dart';

/// Data model representing a product category in the data layer.
///
/// Extends the [ProductCategory] entity and provides utilities for JSON
/// serialization and deserialization. This bridges the gap between API
/// responses and the domain layer entity.
class ProductCategoryModel extends ProductCategory {
  /// Creates a [ProductCategoryModel] with the provided fields.
  const ProductCategoryModel({
    required super.id,
    super.name,
    super.colour,
    super.image,
  });

  /// Provides an empty [ProductCategoryModel] for testing or placeholders.
  const ProductCategoryModel.empty() : super(id: 'Test String');

  /// Converts the [ProductCategoryModel] into a JSON-compatible [Map].
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'colour': colour, 'image': image};
  }

  /// Creates a [ProductCategoryModel] instance from a JSON [Map].
  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id'] as String,
      name: map['name'] as String?,
      colour: map['colour'] as String?,
      image: map['image'] as String?,
    );
  }

  /// Creates a new [ProductCategoryModel] by copying the current instance
  /// and overriding selected fields.
  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? colour,
    String? image,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colour: colour ?? this.colour,
      image: image ?? this.image,
    );
  }
}
