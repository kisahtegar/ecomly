import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

class PaymentProfileView extends StatefulWidget {
  const PaymentProfileView({required this.sessionUrl, super.key});

  final String sessionUrl;

  static const path = '/payment-profile';

  @override
  State<PaymentProfileView> createState() => _PaymentProfileViewState();
}

class _PaymentProfileViewState extends State<PaymentProfileView> {
  late WebViewController controller;
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
            loadingNotifier.value = true;
          },
          onPageFinished: (_) {
            loadingNotifier.value = false;
          },
          onWebResourceError: (error) {
            CoreUtils.showSnackBar(
              context,
              message: '${error.errorCode} Error: ${error.description}',
            );
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith('https://dbestech.biz/ecomly')) {
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
