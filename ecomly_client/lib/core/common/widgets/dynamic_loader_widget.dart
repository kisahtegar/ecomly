import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';

class DynamicLoaderWidget extends StatelessWidget {
  const DynamicLoaderWidget({
    required this.originalWidget,
    required this.isLoading,
    super.key,
    this.loadingWidget,
  });

  final Widget originalWidget;
  final bool isLoading;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colours.lightThemePrimaryColour,
            ),
          );
    }
    return originalWidget;
  }
}
