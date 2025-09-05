import 'package:flutter/cupertino.dart';

class DashboardState {
  DashboardState._internal();

  static final instance = DashboardState._internal();

  final _indexNotifier = ValueNotifier<int>(0);

  ValueNotifier<int> get indexNotifier => _indexNotifier;

  void changeIndex(int index) {
    if (_indexNotifier.value != index) _indexNotifier.value = index;
  }
}
