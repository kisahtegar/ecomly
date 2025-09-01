import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

/// A thin line (1px height) placed at the bottom of an [AppBar].
///
/// This widget is meant to act as a subtle **divider** between the [AppBar] and
/// the main content of the screen, adapting its color depending on the current
/// theme (light/dark mode).
///
/// - In light mode → `Colors.white`.
/// - In dark mode → [Colours.darkThemeDarkSharpColour].
///
/// Example usage:
/// ```dart
/// Scaffold(
///   appBar: AppBar(
///     title: const Text("Home"),
///     bottom: const AppBarBottom(),
///   ),
///   body: ...
/// )
/// ```
class AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ColoredBox(
        color: CoreUtils.adaptiveColour(
          context,
          lightModeColour: Colors.white,
          darkModeColour: Colours.darkThemeDarkSharpColour,
        ),
        child: const SizedBox(height: 1, width: double.maxFinite),
      ),
    );
  }

  /// Defines the size of the widget when placed in an [AppBar].
  ///
  /// Since this acts as a horizontal divider, its height is `0`
  /// here but effectively controlled by the `SizedBox` inside [build].
  @override
  Size get preferredSize => Size.zero;
}
