/// Product categorization enum based on gender and age demographics.
///
/// The [GenderAgeCategory] enum is used throughout the Ecomly app to filter
/// and categorize products based on their target audience. This helps users
/// find relevant products more efficiently and provides better search/browse
/// functionality.
///
/// ### Usage:
/// - **Product Filtering**: Used in search and category views to narrow results
/// - **UI Components**: Powers category selector widgets
/// - **API Integration**: Sent to backend as search parameters
/// - **State Management**: Managed by Riverpod providers for reactive UI updates
///
/// ### Example:
/// ```dart
/// // In search functionality
/// final category = GenderAgeCategory.women;
/// productAdapter.searchByCategory(
///   categoryId: selectedCategory.id,
///   genderAgeCategory: category.title.toLowerCase(),
/// );
///
/// // In UI components
/// Text(GenderAgeCategory.kids.title); // Displays "Kids"
/// ```
enum GenderAgeCategory {
  /// Shows products for all demographics (no filtering applied).
  ///
  /// This is typically the default option that displays all available
  /// products regardless of their target audience.
  all('All'),

  /// Products specifically targeted for men.
  ///
  /// Includes men's clothing, accessories, and gender-specific items.
  men('Men'),

  /// Products specifically targeted for women.
  ///
  /// Includes women's clothing, accessories, and gender-specific items.
  women('Women'),

  /// Products suitable for all genders.
  ///
  /// Includes items that are not gender-specific, such as certain
  /// accessories, home goods, or general merchandise.
  unisex('Unisex'),

  /// Products specifically designed for children.
  ///
  /// Includes kids' clothing, toys, and age-appropriate items
  /// regardless of gender.
  kids('Kids');

  /// Creates a [GenderAgeCategory] with the given display [title].
  const GenderAgeCategory(this.title);

  /// The human-readable title for this category.
  ///
  /// Used for display purposes in UI components and as a parameter
  /// for API calls (typically converted to lowercase).
  ///
  /// Examples: "All", "Men", "Women", "Unisex", "Kids"
  final String title;
}
