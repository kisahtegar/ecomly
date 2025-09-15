import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/services/router.dart';

/// A widget that allows the user to toggle between app themes.
///
/// - Persists the selected theme using [CacheHelper].
/// - Updates the entire widget tree by forcing a rebuild after theme change.
/// - Animates the transition with a fade + slide effect.
///
/// ### Example:
/// ```dart
/// // Place inside a settings screen or drawer
/// ThemeToggle()
/// ```
class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  late ThemeMode mode;

  @override
  void initState() {
    super.initState();
    mode = Cache.instance.themeModeNotifier.value;
  }

  /// Forces the widget tree to rebuild from the root.
  ///
  /// This is needed after updating the theme so the new mode is applied across
  /// the app.
  void rebuild(Element element) {
    element.markNeedsBuild();
    element.visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            // Animates slightly down as it fades
            position: animation.drive(
              Tween<Offset>(
                begin: Offset.zero,
                end: Offset(0, animation.value),
              ),
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        key: UniqueKey(),
        onTap: () async {
          // Cycle through Dark → Light → System
          setState(() {
            switch (mode) {
              case ThemeMode.dark:
                mode = ThemeMode.light;
              case ThemeMode.light:
                mode = ThemeMode.system;
              case ThemeMode.system:
                mode = ThemeMode.dark;
            }
          });

          // Save to local cache
          await sl<CacheHelper>().cacheThemeMode(mode);

          // Force global rebuild
          (rootNavigatorKey.currentContext! as Element).visitChildren(rebuild);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Displays an icon based on the current theme mode.
              Icon(
                size: 30,
                color: context.isDarkMode
                    ? Colours.lightThemeSecondaryTextColour
                    : Colors.yellow,
                switch (mode) {
                  ThemeMode.light => Icons.light_mode,
                  ThemeMode.dark => Icons.dark_mode,
                  ThemeMode.system => switch (defaultTargetPlatform) {
                    TargetPlatform.iOS => Icons.phone_iphone_rounded,
                    TargetPlatform.android ||
                    TargetPlatform.fuchsia => Icons.phone_android_rounded,
                    TargetPlatform.linux => Icons.laptop_chromebook_rounded,
                    TargetPlatform.macOS => Icons.laptop_mac_rounded,
                    TargetPlatform.windows => Icons.laptop_windows_rounded,
                  },
                },
              ),
              const Gap(3),

              /// Displays the current theme mode as text.
              Text(
                switch (mode) {
                  ThemeMode.dark => 'Dark',
                  ThemeMode.light => 'Light',
                  ThemeMode.system => 'System',
                },
                style: TextStyles.paragraphSubTextRegular2.adaptiveColour(
                  context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
