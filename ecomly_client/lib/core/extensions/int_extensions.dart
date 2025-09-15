/// Utility extensions on [int] for text formatting and pluralization.
///
/// The [IntExtensions] extension provides additional functionality for the `int`
/// class, focusing on user-friendly text formatting, pluralization rules, and
/// display formatting. These extensions help create more readable and
/// grammatically correct user interface text.
extension IntExtensions on int {
  /// Returns a properly pluralized review count string.
  ///
  /// Applies standard English pluralization rules:
  /// - 0 reviews → "0 Reviews"
  /// - 1 review → "1 Review"
  /// - 2+ reviews → "N Reviews"
  ///
  /// ### Example usage:
  /// ```dart
  /// 0.pluralizeReviews; // "0 Reviews"
  /// 1.pluralizeReviews; // "1 Review"
  /// 5.pluralizeReviews; // "5 Reviews"
  /// ```
  String get pluralizeReviews {
    if (this > 1 || this == 0) return '$this Reviews';
    return '$this Review';
  }

  /// Returns a properly pluralized string with a custom word.
  ///
  /// This generic method handles pluralization for any word, with optional
  /// custom plural form. If no [pluralForm] is provided, it defaults to
  /// adding "s" to the singular word.
  ///
  /// Pluralization rules:
  /// - 0 items → plural form
  /// - 1 item → singular form
  /// - 2+ items → plural form
  ///
  /// ### Example usage:
  /// ```dart
  /// // Default pluralization (adds "s")
  /// 1.pluralizeWith('item'); // "1 item"
  /// 3.pluralizeWith('item'); // "3 items"
  ///
  /// // Custom plural form
  /// 1.pluralizeWith('child', pluralForm: 'children'); // "1 child"
  /// 2.pluralizeWith('child', pluralForm: 'children'); // "2 children"
  ///
  /// 0.pluralizeWith('category', pluralForm: 'categories'); // "0 categories"
  /// ```
  ///
  /// ### Parameters:
  /// - [singularWord]: The singular form of the word
  /// - [pluralForm]: Optional custom plural form. Defaults to `{singularWord}s`
  String pluralizeWith(String singularWord, {String? pluralForm}) {
    var pluralFormOfWord = pluralForm ?? '${singularWord}s';
    if (this > 1 || this == 0) return '$this $pluralFormOfWord';
    return '$this $singularWord';
  }

  /// Returns a zero-padded two-digit string representation.
  ///
  /// Useful for displaying numbers in a consistent format, such as times,
  /// counters, or ordered lists where single digits should be prefixed
  /// with a zero.
  ///
  /// ### Example usage:
  /// ```dart
  /// 5.pumpNumber;  // "05"
  /// 12.pumpNumber; // "12"
  /// 0.pumpNumber;  // "00"
  /// 7.pumpNumber;  // "07"
  /// ```
  ///
  /// ### Common use cases:
  /// - Time display: "05:30" instead of "5:30"
  /// - Item numbering: "Item 01", "Item 02"
  /// - Counters: "Page 09 of 15"
  String get pumpNumber {
    if (toString().length == 1) return '0$this';
    return toString();
  }
}
