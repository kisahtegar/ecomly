import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';

/// A utility widget that dynamically switches between a loading indicator
/// and the provided [originalWidget].
///
/// This is useful when you want to show a **loading spinner** while data
/// is being fetched or an async operation is running, and then display
/// the real content once loading is done.
///
/// - If [isLoading] is `true`, it shows:
///   - [loadingWidget], if provided.
///   - Otherwise, a default [CircularProgressIndicator.adaptive].
///
/// - If [isLoading] is `false`, it shows [originalWidget].
///
/// Example usage:
/// ```dart
/// DynamicLoaderWidget(
///   isLoading: state is LoadingState,
///   originalWidget: ListView.builder(...),
///   loadingWidget: const Center(child: Text("Loading...")),
/// )
/// ```
class DynamicLoaderWidget extends StatelessWidget {
  const DynamicLoaderWidget({
    required this.originalWidget,
    required this.isLoading,
    super.key,
    this.loadingWidget,
  });

  /// The main widget that should be shown when [isLoading] is `false`.
  final Widget originalWidget;

  /// Whether the widget should display the loading state.
  final bool isLoading;

  /// Optional custom widget to display when loading.
  ///
  /// If `null`, falls back to a default [CircularProgressIndicator.adaptive].
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
