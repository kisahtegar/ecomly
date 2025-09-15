import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/core/utils/global_keys.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/cart/presentation/views/checkout_successful_view.dart';

/// A view that displays the Stripe checkout session inside a WebView.
///
/// Features:
/// - Loads the Stripe session URL provided from the backend.
/// - Shows a loading indicator while the page loads.
/// - Handles navigation events:
///   - Redirects to [CheckoutSuccessfulView] when payment succeeds.
///   - Navigates back to the cart when the user cancels.
///   - Displays errors when web resources fail to load.
///
/// This is used only on **mobile platforms** (iOS/Android), since web/desktop
/// directly open the checkout URL in an external browser.
class CheckoutView extends ConsumerStatefulWidget {
  /// Creates a new [CheckoutView] with the given Stripe [sessionUrl].
  const CheckoutView({required this.sessionUrl, super.key});

  /// The URL for the Stripe checkout session.
  final String sessionUrl;

  /// Path for navigation (used by [GoRouter]).
  static const path = '/checkout';

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  late WebViewController controller;

  /// Tracks whether the WebView is still loading.
  final loadingNotifier = ValueNotifier(true);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colours.lightThemeTintStockColour)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Could be used to show a progress bar (currently unused).
            // CoreUtils.postFrameCall(() {
            //   loadingNotifier.value = true;
            // });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            CoreUtils.postFrameCall(() {
              loadingNotifier.value = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            CoreUtils.postFrameCall(() {
              loadingNotifier.value = false;
            });
            CoreUtils.showSnackBar(
              context,
              message: '${error.errorCode} Error: ${error.description}',
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            // Detect successful checkout redirect
            if (request.url.startsWith(
              'https://kisahcode.com/payment-success',
            )) {
              ref
                  .read(
                    cartAdapterProvider(
                      GlobalKeys.cartScreenAdapterFamilyKey,
                    ).notifier,
                  )
                  .getCart(Cache.instance.userId!);
              ref
                  .read(
                    cartAdapterProvider(GlobalKeys.cartCountFamilyKey).notifier,
                  )
                  .getCartCount(Cache.instance.userId!);

              // Navigate to success screen
              context.pushReplacement(CheckoutSuccessfulView.path);
              return NavigationDecision.prevent;
            }
            // Detect navigation back to cart
            else if (request.url.startsWith('https://kisahcode.com/cart')) {
              context.pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.sessionUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (context, isLoading, __) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colours.lightThemePrimaryColour,
                ),
              );
            }
            return WebViewWidget(controller: controller);
          },
        ),
      ),
    );
  }
}
