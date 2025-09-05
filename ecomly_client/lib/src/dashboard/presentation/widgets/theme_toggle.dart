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

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  late ThemeMode mode;

  void rebuild(Element element) {
    element.markNeedsBuild();
    element.visitChildren(rebuild);
  }

  @override
  void initState() {
    super.initState();
    mode = Cache.instance.themeModeNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
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

          await sl<CacheHelper>().cacheThemeMode(mode);
          (rootNavigatorKey.currentContext! as Element).visitChildren(rebuild);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
