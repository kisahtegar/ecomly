import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/src/cart/presentation/views/cart_view.dart';
import 'package:ecomly_client/src/explore/presentation/views/explore_view.dart';
import 'package:ecomly_client/src/home/presentation/views/home_view.dart';
import 'package:ecomly_client/src/user/presentation/views/profile_view.dart';
import 'package:ecomly_client/src/wishlist/presentation/views/wishlist_view.dart';

abstract class DashboardUtils {
  static final drawerItems = <({String title, IconData icon})>[
    (title: 'Profile', icon: IconlyBroken.profile),
    (title: 'Payment Profile', icon: IconlyBroken.scan),
    (title: 'Wishlist', icon: IconlyBroken.heart),
    (title: 'My orders', icon: IconlyBroken.time_circle),
    (title: 'Privacy Policy', icon: IconlyBroken.shield_done),
    (title: 'Terms & Conditions', icon: IconlyBroken.document),
  ];

  static final iconList = <({IconData idle, IconData active})>[
    (idle: IconlyBroken.home, active: IconlyBold.home),
    (idle: IconlyBroken.discovery, active: IconlyBold.discovery),
    (idle: IconlyBroken.buy, active: IconlyBold.buy),
    (idle: IconlyBroken.heart, active: IconlyBold.heart),
    (idle: IconlyBroken.profile, active: IconlyBold.profile),
  ];

  static final scaffoldKey = GlobalKey<ScaffoldState>();

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
