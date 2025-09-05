import 'dart:ui';

extension ColourExtensions on Color {
  String get hex {
    return toString().substring(8, 16).toLowerCase().replaceFirst('ff', '#');
  }
}
