import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/domain/entities/wishlist_product.dart';

/// Abstract repository defining wishlist data operations.
///
/// This repository follows the Repository Pattern from Clean Architecture,
/// abstracting wishlist-related data operations from their concrete
/// implementations. It defines contracts for retrieving, adding, and
/// removing products from the user's wishlist.
abstract class WishlistRepo {
  /// Retrieves all wishlist items for the specified user.
  ///
  /// Returns a list of [WishlistProduct] entities representing all products
  /// the user has saved in their wishlist, including basic product details.
  ResultFuture<List<WishlistProduct>> getWishlist(String userId);

  /// Adds a product to the user's wishlist.
  ///
  /// Requires both [userId] and [productId] to uniquely identify the
  /// wishlist entry. Useful for letting users save products for later
  /// without adding them to the cart.
  ResultFuture<void> addToWishlist({
    required String userId,
    required String productId,
  });

  /// Removes a product from the user's wishlist.
  ///
  /// Requires both [userId] and [productId] to locate and remove the
  /// corresponding wishlist entry. Typically used when a user un-favorites
  /// a product or decides to no longer save it for later.
  ResultFuture<void> removeFromWishlist({
    required String userId,
    required String productId,
  });
}
