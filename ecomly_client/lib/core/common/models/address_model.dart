import 'dart:convert';

import 'package:ecomly_client/core/common/entities/address.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

/// Data model for [Address], extending the entity with serialization/deserialization
/// capabilities.
///
/// Unlike [Address], this model is tailored for data layer usage:
/// - Converting between JSON/Map and domain entities.
/// - Providing a [copyWith] method for immutability-friendly updates.
class AddressModel extends Address {
  /// Creates an [AddressModel] with optional address details.
  const AddressModel({
    super.street,
    super.apartment,
    super.city,
    super.postalCode,
    super.country,
  });

  /// Placeholder model with `"Test String"` values.
  /// Useful for tests, mocks, or representing an uninitialized state.
  const AddressModel.empty()
    : this(
        street: "Test String",
        apartment: "Test String",
        city: "Test String",
        postalCode: "Test String",
        country: "Test String",
      );

  /// Creates an [AddressModel] from a JSON string.
  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(jsonDecode(source) as DataMap);

  /// Creates an [AddressModel] from a key-value [map].
  AddressModel.fromMap(DataMap map)
    : this(
        street: map['street'] as String?,
        apartment: map['apartment'] as String?,
        city: map['city'] as String?,
        postalCode: map['postalCode'] as String?,
        country: map['country'] as String?,
      );

  /// Returns a copy of this [AddressModel] with overridden fields.
  AddressModel copyWith({
    String? street,
    String? apartment,
    String? city,
    String? postalCode,
    String? country,
  }) {
    return AddressModel(
      street: street ?? this.street,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  /// Converts this model into a [Map].
  DataMap toMap() {
    return <String, dynamic>{
      'street': street,
      'apartment': apartment,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }

  /// Converts this model into a JSON string.
  String toJson() => jsonEncode(toMap());
}
