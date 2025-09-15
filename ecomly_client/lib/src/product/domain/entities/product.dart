import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'package:ecomly_client/src/product/domain/entities/category.dart';

/// Represents a product available in the store.
///
/// This is a domain-level entity used throughout the app to define the core
/// attributes of a product such as its name, price, stock, images, available
/// variants, and category.
class Product extends Equatable {
  /// Creates a new [Product] instance.
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.colours,
    required this.image,
    required this.images,
    required this.reviewIds,
    required this.numberOfReviews,
    required this.sizes,
    required this.category,
    this.genderAgeCategory,
    required this.countInStock,
  });

  /// Creates an empty [Product] instance with test/default values.
  ///
  /// Useful for testing, placeholders, or initializing state.
  const Product.empty()
    : id = "Test String",
      name = "Test String",
      description = "Test String",
      price = 1,
      rating = 1,
      colours = const [],
      image = "Test String",
      images = const [],
      reviewIds = const [],
      numberOfReviews = 1,
      sizes = const [],
      category = const ProductCategory.empty(),
      genderAgeCategory = "Test String",
      countInStock = 1;

  /// Unique identifier of the product.
  final String id;

  /// Human-readable name of the product.
  final String name;

  /// Detailed description of the product.
  final String description;

  /// Price of the product in USD.
  final double price;

  /// Average rating from user reviews (0.0–5.0).
  final double rating;

  /// List of available colour options for the product.
  final List<Color> colours;

  /// Main image URL representing the product.
  final String image;

  /// Additional image URLs for gallery previews.
  final List<String> images;

  /// List of IDs referencing the product's reviews.
  final List<String> reviewIds;

  /// Total count of reviews.
  final int numberOfReviews;

  /// List of available size options.
  final List<String> sizes;

  /// The [ProductCategory] this product belongs to.
  final ProductCategory category;

  /// Optional target demographic (e.g., "Men", "Women", "Kids").
  final String? genderAgeCategory;

  /// Number of units currently in stock.
  final int countInStock;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    rating,
    image,
    numberOfReviews,
    category,
    genderAgeCategory,
    countInStock,
  ];
}
