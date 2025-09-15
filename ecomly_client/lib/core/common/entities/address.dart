import 'package:equatable/equatable.dart';

/// Represents a user's address.
///
/// This entity is designed to encapsulate address-related details such as
/// [street], [apartment], [city], [postalCode], and [country]. It extends
/// [Equatable] to enable value equality, ensuring that two `Address` instances
/// with the same values are treated as equal.
///
/// The [Address] class is typically used in user profiles, shipping details,
/// or any domain feature requiring location information.
class Address extends Equatable {
  const Address({
    this.street,
    this.apartment,
    this.city,
    this.postalCode,
    this.country,
  });

  /// A placeholder `Address` filled with `"Test String"` values.
  /// Useful for mock data or initial states before receiving real input.
  const Address.empty()
    : street = "Test String",
      apartment = "Test String",
      city = "Test String",
      postalCode = "Test String",
      country = "Test String";

  /// Street name and number of the address.
  final String? street;

  /// Apartment, suite, or unit information.
  final String? apartment;

  /// City where the address is located.
  final String? city;

  /// Postal or ZIP code of the address.
  final String? postalCode;

  /// Country where the address resides.
  final String? country;

  /// Returns `true` if all fields are `null`, meaning the address is empty.
  bool get isEmpty =>
      street == null &&
      apartment == null &&
      city == null &&
      postalCode == null &&
      country == null;

  /// Returns `true` if at least one field contains a value.
  bool get isNotEmpty => !isEmpty;

  @override
  List<dynamic> get props => [street, apartment, city, postalCode, country];
}
