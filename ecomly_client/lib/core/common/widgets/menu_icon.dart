import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/heroicons_outline.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/src/dashboard/presentation/utils/dashboard_utils.dart';

/// A reusable hamburger menu icon widget for opening the dashboard drawer.
///
/// The `MenuIcon` displays a hamburger menu icon that, when tapped, opens
/// the navigation drawer using the global scaffold key from [DashboardUtils].
/// The icon adapts its color based on the current theme for optimal visibility.
///
/// Features:
/// - **Adaptive Theming**: Icon color automatically adjusts for light/dark themes
/// - **Drawer Integration**: Directly opens the dashboard drawer when tapped
/// - **Heroicons Styling**: Uses `HeroiconsOutline.menu_alt_2` for consistent iconography
/// - **Touch Target**: Wrapped in [GestureDetector] for proper tap handling
/// - **Centered Layout**: Icon is centered within its container
///
/// ### Example usage:
/// ```dart
/// AppBar(
///   leading: const MenuIcon(),
///   title: const Text('Dashboard'),
/// )
/// ```
///
/// ```dart
/// // As a standalone widget
/// const MenuIcon()
/// ```
///
/// ### Dependencies:
/// Requires [DashboardUtils.scaffoldKey] to be properly initialized for
/// drawer functionality to work correctly.
class MenuIcon extends StatelessWidget {
  const MenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          DashboardUtils.scaffoldKey.currentState?.openDrawer();
        },
        child: Iconify(
          HeroiconsOutline.menu_alt_2,
          size: 24,
          color: Colours.classicAdaptiveTextColour(context),
        ),
      ),
    );
  }
}
