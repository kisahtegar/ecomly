import 'package:flutter/cupertino.dart';

/// A singleton class that manages the state of the dashboard's current tab index.
///
/// This class uses a [ValueNotifier] to track the currently selected dashboard
/// index, allowing widgets to listen and react to tab changes in real time.
///
/// ### Usage:
/// ```dart
/// // Access the global instance
/// final dashboardState = DashboardState.instance;
///
/// // Listen for changes
/// ValueListenableBuilder<int>(
///   valueListenable: dashboardState.indexNotifier,
///   builder: (_, index, __) {
///     return Text('Current tab: $index');
///   },
/// );
///
/// // Update index
/// dashboardState.changeIndex(2); // Switch to tab at index 2
/// ```
class DashboardState {
  DashboardState._internal();

  /// The global singleton instance of [DashboardState].
  static final instance = DashboardState._internal();

  /// Internal [ValueNotifier] that holds the current tab index.
  final _indexNotifier = ValueNotifier<int>(0);

  /// Exposes the [ValueNotifier] to allow widgets to listen for tab changes.
  ValueNotifier<int> get indexNotifier => _indexNotifier;

  /// Changes the current dashboard index to the given [index].
  ///
  /// Only updates the value if [index] is different from the current one
  /// to prevent unnecessary rebuilds.
  void changeIndex(int index) {
    if (_indexNotifier.value != index) _indexNotifier.value = index;
  }
}
