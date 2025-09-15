import 'package:flutter/widgets.dart';

/// A centralized collection of global keys used throughout the Ecomly app.
///
/// This abstract class serves as a single source of truth for [GlobalKey]
/// instances that need to be shared across different parts of the application.
/// These keys are primarily used for state management with Riverpod family
/// providers to maintain separate provider instances.
///
/// ### Purpose:
/// - **State Isolation**: Ensures different instances of family providers
///   don't interfere with each other
/// - **Widget Identification**: Allows widgets to be uniquely identified
///   for testing and state management purposes
/// - **Provider Management**: Enables proper cleanup and management of
///   Riverpod family providers
///
/// ### Usage Pattern:
/// These keys are typically used with Riverpod family providers like:
/// ```dart
/// ref.watch(cartProvider(GlobalKeys.cartCountFamilyKey))
/// ref.read(cartScreenAdapter(GlobalKeys.cartScreenAdapterFamilyKey).notifier)
/// ```
///
/// ### Architecture Note:
/// Declared as `abstract` to prevent instantiation - this is a utility class
/// that only provides static key instances.
abstract class GlobalKeys {
  /// Global key for cart count family providers.
  ///
  /// Used to maintain separate instances of cart count-related providers
  /// across different parts of the app. This ensures that cart count updates
  /// in one location don't interfere with cart functionality in other areas.
  ///
  /// ### Common usage:
  /// ```dart
  /// // In widgets that display cart count
  /// final cartCount = ref.watch(
  ///   cartCountProvider(GlobalKeys.cartCountFamilyKey)
  /// );
  /// ```
  static final cartCountFamilyKey = GlobalKey();

  /// Global key for cart screen adapter family providers.
  ///
  /// Used to manage separate instances of cart screen-specific providers,
  /// ensuring proper state isolation between different cart-related screens
  /// and components. This is particularly important for cart operations like
  /// add/remove items, quantity updates, and checkout processes.
  ///
  /// ### Common usage:
  /// ```dart
  /// // In cart-related screens and widgets
  /// final cartAdapter = ref.watch(
  ///   cartScreenAdapterProvider(GlobalKeys.cartScreenAdapterFamilyKey)
  /// );
  /// ```
  static final cartScreenAdapterFamilyKey = GlobalKey();
}
