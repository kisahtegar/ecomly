import 'dart:convert';

import 'package:ecomly_client/core/common/entities/address.dart';
import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/common/models/address_model.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/data/models/wishlist_product_model.dart';
import 'package:ecomly_client/src/wishlist/domain/entities/wishlist_product.dart';

/// Data model for [User], extending the domain entity with:
/// - JSON/Map serialization and deserialization.
/// - A [copyWith] method for immutability support.
/// - Transformation of nested models like [AddressModel] and [WishlistProductModel].
///
/// Unlike [User] (pure entity), this model is tied to the **data layer**.
class UserModel extends User {
  /// Creates a [UserModel] with all required fields.
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isAdmin,
    required super.wishlist,
    super.address,
    super.phone,
  });

  /// Placeholder instance with `"Test String"` values. Useful for testing,
  /// mocking, or representing empty user state.
  const UserModel.empty()
    : this(
        id: "Test String",
        name: "Test String",
        email: "Test String",
        isAdmin: true,
        wishlist: const [],
        address: null,
        phone: null,
      );

  /// Returns a new [User] entity with updated fields.
  ///
  /// Note: This returns a base [User] (entity) instead of [UserModel],
  /// which keeps separation between **domain** and **data** layers.
  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    List<WishlistProduct>? wishlist,
    Address? address,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      wishlist: wishlist ?? this.wishlist,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  /// Converts this model into a key-value [Map].
  /// Includes nested conversions for:
  /// - [WishlistProduct] → [WishlistProductModel].
  /// - [Address] → [AddressModel] (only if not null).
  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'wishlist': wishlist
          .map((product) => (product as WishlistProductModel).toMap())
          .toList(),
      if (address != null) 'address': (address as AddressModel).toMap(),
      if (phone != null) 'phone': phone,
    };
  }

  /// Creates a [UserModel] from a JSON string.
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  /// Creates a [UserModel] from a key-value [map].
  ///
  /// - Handles both `id` and `_id` keys for flexibility with backend responses.
  /// - Builds nested [AddressModel] safely, treating an empty address as `null`.
  /// - Converts wishlist maps into [WishlistProductModel] instances.
  factory UserModel.fromMap(DataMap map) {
    final address = AddressModel.fromMap({
      if (map case {'street': String street}) 'street': street,
      if (map case {'apartment': String apartment}) 'apartment': apartment,
      if (map case {'city': String city}) 'city': city,
      if (map case {'postalCode': String postalCode}) 'postalCode': postalCode,
      if (map case {'country': String country}) 'country': country,
    });

    return UserModel(
      id: map['id'] as String? ?? map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      wishlist: List<DataMap>.from(
        map['wishlist'] as List,
      ).map(WishlistProductModel.fromMap).toList(),
      address: address.isEmpty ? null : address,
      phone: map['phone'] as String?,
    );
  }

  /// Converts this model into a JSON string.
  String toJson() => jsonEncode(toMap());
}
