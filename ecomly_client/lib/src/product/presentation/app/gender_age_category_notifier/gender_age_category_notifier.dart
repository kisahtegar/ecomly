import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/core/utils/enums/gender_age_category.dart';

part 'gender_age_category_notifier.g.dart';

/// A Riverpod state notifier that manages the currently selected [GenderAgeCategory].
///
/// This provider is responsible for:
/// - Tracking the active gender/age category (e.g., men, women, kids, all).
/// - Updating the state when the user changes the category.
///
/// By default, the initial category is set to [GenderAgeCategory.all].
@riverpod
class GenderAgeCategoryNotifier extends _$GenderAgeCategoryNotifier {
  /// Initializes the [GenderAgeCategoryNotifier] with the default value.
  ///
  /// The optional [familyKey] parameter enables scoping different instances
  /// of this notifier to specific widget subtrees (not actively used here).
  @override
  GenderAgeCategory build([GlobalKey? familyKey]) {
    return GenderAgeCategory.all;
  }

  /// Changes the selected gender/age category.
  ///
  /// - [category]: The new [GenderAgeCategory] to set as the current state.
  ///
  /// If the provided category is the same as the current one, the state remains unchanged.
  void changeCategory(GenderAgeCategory category) {
    if (state != category) state = category;
  }
}
