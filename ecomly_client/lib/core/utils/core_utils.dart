import 'package:flutter/material.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

/// A collection of core utility methods used throughout the Ecomly app.
///
/// The [CoreUtils] class provides static helper functions for common tasks such
/// as showing snack bars, deferring callback execution until after the widget
/// build phase, and resolving adaptive colors based on theme context.
abstract class CoreUtils {
  const CoreUtils();

  /// Displays a [SnackBar] with the given [message].
  ///
  /// Internally, this method calls [postFrameCall] to ensure the snack bar is
  /// shown after the current widget tree build is completed.
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColour,
  }) {
    postFrameCall(() {
      final snackBar = SnackBar(
        backgroundColor: backgroundColour ?? Colours.lightThemePrimaryColour,
        content: Text(message, style: TextStyles.paragraphSubTextRegular1),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }

  /// Executes the given [callback] after the current frame is rendered.
  ///
  /// This is useful when you need to run logic that depends on the widget tree
  /// being fully built, such as showing dialogs, snack bars, or performing
  /// layout-dependent operations.
  ///
  /// ### Example:
  /// ```dart
  /// CoreUtils.postFrameCall(() {
  ///   // Safe to interact with context here
  /// });
  /// ```
  static void postFrameCall(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  /// Returns a color that adapts based on the current theme (light or dark).
  ///
  /// - If the app is in light mode, returns [lightModeColour].
  /// - If the app is in dark mode, returns [darkModeColour].
  ///
  /// Requires [context] which uses [context.isDarkMode] from
  /// `context_extensions.dart`.
  static Color adaptiveColour(
    BuildContext context, {
    required Color lightModeColour,
    required Color darkModeColour,
  }) {
    return context.isDarkMode ? darkModeColour : lightModeColour;
  }
}
