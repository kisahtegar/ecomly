import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

/// A screen that loads and displays the user's payment profile in a WebView.
///
/// This view is typically used for managing billing information through an
/// external service (like Stripe). It listens to WebView events and provides
/// appropriate UI feedback while loading or when errors occur.
///
/// ### Parameters:
/// - [sessionUrl] → the URL of the payment profile session to load.
///
/// ### Navigation:
/// - Pops the current route if the navigation request URL starts with
///   `https://kisahcode.com/ecomly`.
///
/// ### Example:
/// ```dart
/// context.push(PaymentProfileView.path, extra: paymentProfileUrl);
/// ```
class PaymentProfileView extends StatefulWidget {
  const PaymentProfileView({required this.sessionUrl, super.key});

  /// The session URL for the payment profile page (provided by backend/Stripe).
  final String sessionUrl;

  /// Navigation path used with GoRouter.
  static const path = '/payment-profile';

  @override
  State<PaymentProfileView> createState() => _PaymentProfileViewState();
}

class _PaymentProfileViewState extends State<PaymentProfileView> {
  late WebViewController controller;

  /// Controls loading state to show/hide a progress indicator.
  final loadingNotifier = ValueNotifier(false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colours.lightThemeTintStockColour)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (_) {
            // Mark as loading while progress updates.
            loadingNotifier.value = true;
          },
          onPageFinished: (_) {
            // Hide loader when page finishes rendering.
            loadingNotifier.value = false;
          },
          onWebResourceError: (error) {
            CoreUtils.showSnackBar(
              context,
              message: '${error.errorCode} Error: ${error.description}',
            );
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith('https://kisahcode.com/ecomly')) {
              // Close this screen when returning to app's success callback URL.
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
          builder: (_, loading, __) {
            if (loading) {
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
