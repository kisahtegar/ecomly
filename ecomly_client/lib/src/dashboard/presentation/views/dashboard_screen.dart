import 'package:collection/collection.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/cart/presentation/views/cart_view.dart';
import 'package:ecomly_client/src/dashboard/presentation/app/dashboard_state.dart';
import 'package:ecomly_client/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:ecomly_client/src/dashboard/presentation/widgets/dashboard_drawer.dart';
import 'package:ecomly_client/src/explore/presentation/views/explore_view.dart';
import 'package:ecomly_client/src/home/presentation/views/home_view.dart';
import 'package:ecomly_client/src/user/presentation/views/profile_view.dart';
import 'package:ecomly_client/src/wishlist/presentation/views/wishlist_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.state, required this.child, super.key});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeIndex = DashboardUtils.activeIndex(state);

    return Scaffold(
      key: DashboardUtils.scaffoldKey,
      body: child,
      drawer: const DashboardDrawer(),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: DashboardState.instance.indexNotifier,
        builder: (_, currentIndex, __) {
          return CurvedNavigationBar(
            index: currentIndex,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            color: CoreUtils.adaptiveColour(
              context,
              lightModeColour: Colours.lightThemeWhiteColour,
              darkModeColour: Colours.darkThemeDarkSharpColour,
            ),
            buttonBackgroundColor: Colours.lightThemePrimaryColour,
            items: DashboardUtils.iconList.mapIndexed((index, icon) {
              final isActive = activeIndex == index;
              return Icon(
                isActive ? icon.active : icon.idle,
                size: 30,
                color: isActive
                    ? Colours.lightThemeWhiteColour
                    : Colours.lightThemeSecondaryTextColour,
              );
            }).toList(),
            onTap: (index) async {
              final currentIndex = activeIndex;
              DashboardState.instance.changeIndex(index);
              switch (index) {
                case 0:
                  context.go(HomeView.path);
                case 1:
                  context.go(ExploreView.path);
                case 2:
                  await context.push(CartView.path);
                  DashboardState.instance.changeIndex(currentIndex);
                case 3:
                  context.go(WishlistView.path);
                case 4:
                  await context.push(ProfileView.path);
                  DashboardState.instance.changeIndex(currentIndex);
              }
            },
          );
        },
      ),
    );
  }
}
