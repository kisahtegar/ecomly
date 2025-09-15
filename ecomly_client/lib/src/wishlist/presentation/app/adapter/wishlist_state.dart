part of 'wishlist_provider.dart';

/// Base state class for all wishlist-related operations.
///
/// This sealed class defines the different UI and data states
/// that can occur when interacting with the wishlist feature.
sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

/// Initial state before any wishlist action has been performed.
final class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

/// State when a product is being added to the wishlist.
final class AddingToWishlist extends WishlistState {
  const AddingToWishlist();
}

/// State when a product is being removed from the wishlist.
final class RemovingFromWishlist extends WishlistState {
  const RemovingFromWishlist();
}

/// State when the user's wishlist is being fetched from the server.
final class GettingUserWishlist extends WishlistState {
  const GettingUserWishlist();
}

/// State emitted when a product has been successfully added to the wishlist.
final class AddedToWishlist extends WishlistState {
  const AddedToWishlist();
}

/// State emitted when a product has been successfully removed from the wishlist.
final class RemovedFromWishlist extends WishlistState {
  const RemovedFromWishlist();
}

/// State emitted when the user's wishlist has been successfully fetched.
///
/// Contains a list of [WishlistProduct] entities.
final class FetchedUserWishlist extends WishlistState {
  const FetchedUserWishlist(this.wishlist);

  /// The user's wishlist products.
  final List<WishlistProduct> wishlist;

  @override
  List<Object> get props => wishlist;
}

/// Error state emitted when any wishlist-related operation fails.
///
/// Contains an error [message] describing the issue.
final class WishlistError extends WishlistState {
  const WishlistError(this.message);

  /// The error message returned from the operation.
  final String message;

  @override
  List<Object> get props => [message];
}
