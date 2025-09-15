/// Utility extensions on [double] for rating and numeric calculations.
///
/// The [DoubleExtensions] extension provides additional functionality for the
/// `double` class.
extension DoubleExtensions on double {
  /// Determines if this double value can "fill" the specified number of units.
  ///
  /// This method is particularly useful for star rating systems where you need
  /// to determine if a fractional rating (e.g., 4.3) should display a filled
  /// star at a given position.
  ///
  /// The logic:
  /// - If the truncated value is >= [number], it can definitely fill
  /// - If adding 0.5 and truncating is >= [number], it's considered "half-fillable"
  ///
  /// ### Example usage:
  /// ```dart
  /// final rating = 4.3;
  ///
  /// rating.canFill(1); // true (4.3 >= 1)
  /// rating.canFill(4); // true (4.3 >= 4)
  /// rating.canFill(5); // false (4.3 < 5, and 4.8 truncated < 5)
  ///
  /// final rating2 = 4.6;
  /// rating2.canFill(5); // true (4.6 + 0.5 = 5.1, truncated = 5)
  /// ```
  ///
  /// ### Parameters:
  /// - [number]: The target number to check if this double can fill
  ///
  /// ### Returns:
  /// `true` if the double value can fill the specified number, `false` otherwise.
  bool canFill(int number) {
    return truncate() >= number || (this + .5).truncate() >= number;
  }
}
