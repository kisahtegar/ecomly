import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:ecomly_client/src/wishlist/presentation/app/adapter/wishlist_provider.dart';

/// A stateful heart icon button for adding/removing products from user's wishlist.
///
/// The `FavouriteIcon` widget provides an interactive heart icon that allows users
/// to toggle a product's favorite status. It integrates with the app's wishlist
/// system using Riverpod for state management and automatically updates the UI
/// based on the current wishlist state.
///
/// Features:
/// - **Interactive Toggle**: Tap to add/remove products from wishlist
/// - **Visual Feedback**: Filled heart (favorite) vs outline heart (not favorite)
/// - **Loading States**: Shows [CupertinoActivityIndicator] during async operations
/// - **Error Handling**: Displays snackbar messages for wishlist operation errors
/// - **Auto Refresh**: Automatically refreshes user data after wishlist changes
/// - **State Persistence**: Integrates with user authentication and cache system
///
/// ### Visual States:
/// - **Not Favorite**: Outline heart icon ([IconlyBroken.heart])
/// - **Favorite**: Filled heart icon ([IconlyBold.heart])
/// - **Loading**: Activity indicator during add/remove operations
/// - **Color**: Uses [Colours.lightThemeSecondaryColour] for consistency
///
/// ### Example usage:
/// ```dart
/// // In a product tile or card
/// Stack(
///   children: [
///     ProductImage(product.imageUrl),
///     Positioned(
///       top: 8,
///       right: 8,
///       child: FavouriteIcon(productId: product.id),
///     ),
///   ],
/// )
/// ```
///
/// ```dart
/// // As standalone widget
/// FavouriteIcon(productId: 'product-123')
/// ```
///
/// ### Dependencies:
/// - Requires user to be authenticated ([Cache.instance.userId] not null)
/// - Uses [currentUserProvider] for wishlist state
/// - Integrates with [userWishlistProvider] for wishlist operations
/// - Uses [authUserProvider] for user data refresh
class FavouriteIcon extends ConsumerStatefulWidget {
  const FavouriteIcon({required this.productId, super.key});

  /// The unique identifier of the product for wishlist operations.
  final String productId;

  @override
  ConsumerState<FavouriteIcon> createState() => _FavouriteIconState();
}

class _FavouriteIconState extends ConsumerState<FavouriteIcon> {
  final wishlistAdapterFamilyKey = GlobalKey();
  final authUserAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    ref.listenManual(userWishlistProvider(wishlistAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case WishlistError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is RemovedFromWishlist || next is AddedToWishlist) {
        CoreUtils.postFrameCall(() {
          ref
              .read(authUserProvider(authUserAdapterFamilyKey).notifier)
              .getUserById(Cache.instance.userId!);
        });
      }
    });
  }

  void toggle({required bool isFavourite, required String userId}) {
    if (isFavourite) {
      ref
          .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
          .removeFromWishlist(userId: userId, productId: widget.productId);
    } else {
      ref
          .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
          .addToWishlist(userId: userId, productId: widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final authAdapter = ref.watch(authUserProvider(authUserAdapterFamilyKey));

    final wishlistAdapter = ref.watch(
      userWishlistProvider(wishlistAdapterFamilyKey),
    );

    final productIsFavourite = user!.wishlist.any(
      (product) => product.productId == widget.productId,
    );

    if (wishlistAdapter is AddingToWishlist ||
        wishlistAdapter is RemovingFromWishlist ||
        authAdapter is GettingUserData) {
      return const Center(child: CupertinoActivityIndicator());
    }
    return IconButton(
      onPressed: () {
        toggle(isFavourite: productIsFavourite, userId: user.id);
      },
      icon: Icon(
        productIsFavourite ? IconlyBold.heart : IconlyBroken.heart,
        color: Colours.lightThemeSecondaryColour,
      ),
    );
  }
}
