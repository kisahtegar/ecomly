import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/media.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/src/dashboard/presentation/app/dashboard_state.dart';

/// A view shown after a successful checkout.
///
/// Displays a success animation, a confirmation message, and a button to
/// navigate back to the home screen.
///
/// Used at the end of the checkout flow to assure users that their order
/// has been placed successfully.
class CheckoutSuccessfulView extends ConsumerWidget {
  const CheckoutSuccessfulView({super.key});

  /// Path for navigation (used by [GoRouter]).
  static const path = '/checkout-completed';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Success animation
            Lottie.asset(Media.checkMark, repeat: false),

            /// Confirmation message
            Text(
              'Your order has been placed',
              textAlign: TextAlign.center,
              style: TextStyles.buttonTextHeadingSemiBold.adaptiveColour(
                context,
              ),
            ),

            const Gap(50),

            /// Continue shopping button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedButton(
                height: 50,
                onPressed: () {
                  // Reset dashboard state to home and navigate back
                  DashboardState.instance.changeIndex(0);
                  context.go('/', extra: 'home');
                },
                text: 'Continue Shopping   🛒',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
