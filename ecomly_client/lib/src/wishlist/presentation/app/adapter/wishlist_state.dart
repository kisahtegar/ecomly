part of 'wishlist_provider.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

final class AddingToWishlist extends WishlistState {
  const AddingToWishlist();
}

final class RemovingFromWishlist extends WishlistState {
  const RemovingFromWishlist();
}

final class GettingUserWishlist extends WishlistState {
  const GettingUserWishlist();
}

final class AddedToWishlist extends WishlistState {
  const AddedToWishlist();
}

final class RemovedFromWishlist extends WishlistState {
  const RemovedFromWishlist();
}

final class FetchedUserWishlist extends WishlistState {
  const FetchedUserWishlist(this.wishlist);

  final List<WishlistProduct> wishlist;

  @override
  List<Object> get props => wishlist;
}

final class WishlistError extends WishlistState {
  const WishlistError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
