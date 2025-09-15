import 'package:flutter/widgets.dart';

import 'package:ecomly_client/core/common/widgets/dynamic_loader_widget.dart';

/// A collection of helpful extensions on [Widget] to improve readability and
/// reduce boilerplate in UI development.
///
/// This extension can be expanded with more utility methods for commonly used
/// widget patterns.
extension WidgetExt on Widget {
  /// Wraps the current widget in a [DynamicLoaderWidget] to show a loading
  /// indicator when [isLoading] is `true`. If [isLoading] is `false`, the
  /// original widget is displayed instead.
  ///
  /// Example:
  /// ```dart
  /// ElevatedButton(
  ///   onPressed: () {},
  ///   child: const Text('Submit'),
  /// ).loading(isSubmitting);
  /// ```
  Widget loading(bool isLoading) {
    return DynamicLoaderWidget(originalWidget: this, isLoading: isLoading);
  }
}
