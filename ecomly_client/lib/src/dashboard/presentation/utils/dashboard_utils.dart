import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/src/cart/presentation/views/cart_view.dart';
import 'package:ecomly_client/src/explore/presentation/views/explore_view.dart';
import 'package:ecomly_client/src/home/presentation/views/home_view.dart';
import 'package:ecomly_client/src/user/presentation/views/profile_view.dart';
import 'package:ecomly_client/src/wishlist/presentation/views/wishlist_view.dart';

/// Utility class that provides constants and helpers for the dashboard.
///
/// Includes definitions for drawer items, bottom navigation icons,
/// a global [ScaffoldState] key, and logic to determine the active
/// navigation index based on the current route.
abstract class DashboardUtils {
  /// List of items shown in the navigation drawer.
  ///
  /// Each item contains a `title` and an `icon`.
  static final drawerItems = <({String title, IconData icon})>[
    (title: 'Profile', icon: IconlyBroken.profile),
    (title: 'Payment Profile', icon: IconlyBroken.scan),
    (title: 'Wishlist', icon: IconlyBroken.heart),
    (title: 'My orders', icon: IconlyBroken.time_circle),
    (title: 'Privacy Policy', icon: IconlyBroken.shield_done),
    (title: 'Terms & Conditions', icon: IconlyBroken.document),
  ];

  /// Icons used for the bottom navigation bar.
  ///
  /// Each entry contains an `idle` (inactive) icon and an `active` icon.
  static final iconList = <({IconData idle, IconData active})>[
    (idle: IconlyBroken.home, active: IconlyBold.home),
    (idle: IconlyBroken.discovery, active: IconlyBold.discovery),
    (idle: IconlyBroken.buy, active: IconlyBold.buy),
    (idle: IconlyBroken.heart, active: IconlyBold.heart),
    (idle: IconlyBroken.profile, active: IconlyBold.profile),
  ];

  /// Global key used to access the root [ScaffoldState] of the dashboard.
  ///
  /// Useful for opening/closing the drawer programmatically.
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Determines the currently active navigation index based on [GoRouterState].
  ///
  /// This is used to keep the bottom navigation bar in sync with the active route.
  ///
  /// - Returns `0` for [HomeView].
  /// - Returns `1` for [ExploreView].
  /// - Returns `2` for [CartView].
  /// - Returns `3` for [WishlistView].
  /// - Returns `4` for [ProfileView].
  /// - Defaults to `0` if no match is found.
  ///
  /// ### Example:
  /// ```dart
  /// final index = DashboardUtils.activeIndex(routerState);
  /// ```
  static int activeIndex(GoRouterState state) {
    return switch (state.fullPath) {
      HomeView.path => 0,
      ExploreView.path => 1,
      CartView.path => 2,
      WishlistView.path => 3,
      ProfileView.path => 4,
      _ => 0,
    };
  }
}
