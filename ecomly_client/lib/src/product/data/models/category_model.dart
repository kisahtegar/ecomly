import 'package:ecomly_client/src/product/domain/entities/category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    super.name,
    super.colour,
    super.image,
  });

  const ProductCategoryModel.empty() : super(id: 'Test String');

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'colour': colour, 'image': image};
  }

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      id: map['id'] as String,
      name: map['name'] as String?,
      colour: map['colour'] as String?,
      image: map['image'] as String?,
    );
  }

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
