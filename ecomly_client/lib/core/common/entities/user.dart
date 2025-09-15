import 'package:equatable/equatable.dart';

import 'package:ecomly_client/core/common/entities/address.dart';
import 'package:ecomly_client/src/wishlist/domain/entities/wishlist_product.dart';

/// Represents a user in the application.
///
/// The [User] entity contains core information such as identity details
/// ([id], [name], [email]), role ([isAdmin]), contact info ([address], [phone]),
/// and domain-specific data like the [wishlist].
///
/// Equality uses [id], [name], [email], [isAdmin], and **wishlist length only**.
/// This keeps comparison lightweight while still detecting meaningful changes
/// (e.g., item added/removed) without checking every wishlist item.
class User extends Equatable {
  /// Creates a new [User] instance with the given details.
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.wishlist,
    this.address,
    this.phone,
  });

  /// A placeholder user instance pre-filled with `"Test String"` values.
  /// Useful for testing, mocks, or representing an uninitialized user.
  const User.empty()
    : id = "Test String",
      name = "Test String",
      email = "Test String",
      isAdmin = true,
      wishlist = const [],
      address = null,
      phone = null;

  /// Unique identifier for the user (e.g., UUID or database ID).
  final String id;

  /// Full name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  /// Whether the user has administrator privileges.
  final bool isAdmin;

  /// List of products the user has added to their wishlist.
  final List<WishlistProduct> wishlist;

  /// Optional physical address of the user.
  final Address? address;

  /// Optional phone number of the user.
  final String? phone;

  @override
  List<Object?> get props => [id, name, email, isAdmin, wishlist.length];
}
