import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/empty_data.dart';
import 'package:ecomly_client/core/common/widgets/menu_icon.dart';
import 'package:ecomly_client/core/common/widgets/search_button.dart';
import 'package:ecomly_client/core/resources/media.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/wishlist/presentation/app/adapter/wishlist_provider.dart';
import 'package:ecomly_client/src/wishlist/presentation/widgets/wishlist_product_tile.dart';

class WishlistView extends ConsumerStatefulWidget {
  const WishlistView({super.key});

  static const path = '/wishlist';

  @override
  ConsumerState<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends ConsumerState<WishlistView> {
  final wishlistAdapterFamilyKey = GlobalKey();

  Future<void> getUserWishlist() async {
    return ref
        .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
        .getWishlist(Cache.instance.userId!);
  }

  @override
  void initState() {
    super.initState();
    CoreUtils.postFrameCall(getUserWishlist);
    ref.listenManual(userWishlistProvider(wishlistAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case WishlistError(:final message)) {
        CoreUtils.showSnackBar(context, message: '$message\nPULL TO REFRESH');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(
      userWishlistProvider(wishlistAdapterFamilyKey),
    );

    return RefreshIndicator.adaptive(
      onRefresh: getUserWishlist,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Saved Items'),
          leading: const MenuIcon(),
          bottom: const AppBarBottom(),
          actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (wishlistState is GettingUserWishlist) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              } else if (wishlistState is FetchedUserWishlist) {
                if (wishlistState.wishlist.isEmpty) {
                  return const EmptyData('No Saved Products');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final product = wishlistState.wishlist[index];
                    return WishlistProductTile(
                      product,
                      mainPageFamilyKey: wishlistAdapterFamilyKey,
                    );
                  },
                  separatorBuilder: (_, __) => const Gap(20),
                  itemCount: wishlistState.wishlist.length,
                );
              } else if (wishlistState is WishlistError) {
                return Center(child: Lottie.asset(Media.error));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
