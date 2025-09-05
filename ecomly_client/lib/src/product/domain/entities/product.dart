import 'dart:ui';

import 'package:equatable/equatable.dart';

import 'package:ecomly_client/src/product/domain/entities/category.dart';

class Product extends Equatable {
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

  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final List<Color> colours;
  final String image;
  final List<String> images;
  final List<String> reviewIds;
  final int numberOfReviews;
  final List<String> sizes;
  final ProductCategory category;
  final String? genderAgeCategory;
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
