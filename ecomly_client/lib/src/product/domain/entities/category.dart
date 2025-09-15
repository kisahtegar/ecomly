import 'package:equatable/equatable.dart';

/// Represents a category to which a product belongs.
///
/// A [ProductCategory] helps organize products into meaningful groups such as
/// "Shoes", "Electronics", or "Clothing". Categories may also include metadata
/// like a display name, colour theme, or an image thumbnail to enhance UI
/// presentation.
class ProductCategory extends Equatable {
  /// Creates a new [ProductCategory] instance.
  const ProductCategory({required this.id, this.name, this.colour, this.image});

  /// Creates a placeholder [ProductCategory] with test/default values.
  ///
  /// Useful for testing, placeholders, or initializing state.
  const ProductCategory.empty() : this(id: 'Test String');

  /// Creates a special "All" category representing all products.
  ///
  /// Used for filtering or displaying unfiltered product lists.
  const ProductCategory.all() : this(id: '', name: 'All');

  /// Unique identifier of the category.
  final String id;

  /// Optional human-readable name of the category.
  final String? name;

  /// Optional hex colour code or theme colour for the category.
  final String? colour;

  /// Optional image URL representing the category.
  final String? image;

  @override
  List<Object?> get props => [id, name, colour, image];
}
