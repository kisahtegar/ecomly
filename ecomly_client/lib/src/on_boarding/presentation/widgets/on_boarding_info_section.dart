import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/media.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/src/auth/presentation/views/login_screen.dart';

/// A section widget displayed during the **onboarding flow**, showing
/// promotional text, a background image, and a "Get Started" button.
///
/// There are **two variants**:
/// - [OnBoardingInfoSection.first] → shows female image + "Winter Sale" copy.
/// - [OnBoardingInfoSection.second] → shows male image + "Flash Sale" copy.
///
/// ### Behavior:
/// - The background image changes depending on the variant.
/// - The promotional text differs between the first and second section.
/// - The "Get Started" button:
///   1. Marks onboarding as completed (`cacheFirstTimer()`).
///   2. Redirects the user to the [LoginScreen].
///
/// ### Example:
/// ```dart
/// PageView(
///   children: const [
///     OnBoardingInfoSection.first(),
///     OnBoardingInfoSection.second(),
///   ],
/// )
/// ```
class OnBoardingInfoSection extends StatelessWidget {
  const OnBoardingInfoSection.first({super.key}) : first = true;

  const OnBoardingInfoSection.second({super.key}) : first = false;

  /// Determines which variant of the onboarding section to show.
  final bool first;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        // Background image (different per variant)
        Image.asset(first ? Media.onBoardingFemale : Media.onBoardingMale),

        // Promotional text + CTA button
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title / promotional copy
            switch (first) {
              true => Text.rich(
                textAlign: TextAlign.left,
                TextSpan(
                  text: '${DateTime.now().year}\n',
                  style: TextStyles.headingBold.orange,
                  children: [
                    TextSpan(
                      text: 'Winter Sale is live now.',
                      style: TextStyle(
                        color: Colours.classicAdaptiveTextColour(context),
                      ),
                    ),
                  ],
                ),
              ),
              _ => Text.rich(
                textAlign: TextAlign.left,
                TextSpan(
                  text: 'Flash Sale\n',
                  style: TextStyles.headingBold.adaptiveColour(context),
                  children: [
                    const TextSpan(
                      text: "Men's",
                      style: TextStyle(
                        color: Colours.lightThemeSecondaryTextColour,
                      ),
                    ),
                    TextSpan(
                      text: ' Shirts & Watches',
                      style: TextStyle(
                        color: Colours.classicAdaptiveTextColour(context),
                      ),
                    ),
                  ],
                ),
              ),
            },

            // CTA Button
            RoundedButton(
              text: 'Get Started',
              onPressed: () {
                sl<CacheHelper>().cacheFirstTimer();
                context.go(LoginScreen.path);
              },
            ),
          ],
        ),
      ],
    );
  }
}
