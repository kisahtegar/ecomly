import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/cart/presentation/app/cart_product_notifier/cart_product_notifier.dart';
import 'package:ecomly_client/src/cart/presentation/views/checkout_view.dart';

/// A button that initiates the checkout process.
///
/// - Displays the total price of either all cart products or only the selected
///   products (if any are selected).
/// - Initiates checkout through the [CartAdapter].
/// - Listens for checkout events:
///   - On success: navigates to the [CheckoutView] (mobile)
///     or opens a Stripe checkout URL (web/desktop).
///   - On error: shows a snackbar with an error message.
class CheckoutButton extends ConsumerStatefulWidget {
  const CheckoutButton({required this.products, super.key});

  final List<CartProduct> products;

  @override
  ConsumerState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends ConsumerState<CheckoutButton> {
  final cartAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Manually listen to checkout state changes.
    ref.listenManual(cartAdapterProvider(cartAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case CheckoutInitiated(:final stripeCheckoutSessionUrl)) {
        debugPrint('-------------INITIATING CHECKOUT-----------------');

        // Handle checkout redirection depending on platform.
        CoreUtils.postFrameCall(() async {
          if (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS) {
            // Navigate to CheckoutView inside the app
            context.push(CheckoutView.path, extra: stripeCheckoutSessionUrl);
          } else {
            // Open checkout URL in browser (web/desktop)
            if (!await launchUrl(Uri.parse(stripeCheckoutSessionUrl))) {
              debugPrint('ERROR: Could not launch Stripe checkout url');
              if (!mounted) return;
              CoreUtils.showSnackBar(
                context,
                message:
                    'Error Occurred, Please try again.\n'
                    'If issue persists, contact support.',
              );
            }
          }
        });
      } else if (next case CartError(:final message)) {
        // Show error messages when checkout fails
        CoreUtils.showSnackBar(context, message: message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));

    // Determine whether to use all products or only selected ones
    final selectedProducts = widget.products.where(
      (product) => cartProductNotifier.contains(product.id),
    );

    // Calculate the total amount
    double total = 0;
    if (cartProductNotifier.isEmpty) {
      total = widget.products.fold<double>(
        0,
        (value, product) => value + (product.productPrice * product.quantity),
      );
    } else {
      total = selectedProducts.fold<double>(
        0,
        (value, product) => value + (product.productPrice * product.quantity),
      );
    }

    // Checkout button with dynamic total
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 40),
      child: RoundedButton(
        height: 50,
        onPressed: () {
          ref
              .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
              .initiateCheckout(
                theme: context.isDarkMode ? 'dark' : 'light',
                cartItems: selectedProducts.isEmpty
                    ? widget.products
                    : selectedProducts.toList(),
              );
        },
        text: 'Checkout (\$${total.toStringAsFixed(2)})',
        textStyle: TextStyles.buttonTextHeadingSemiBold
            .copyWith(fontSize: 16)
            .white,
      ).loading(cartAdapter is InitiatingCheckout),
    );
  }
}
