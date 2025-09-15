import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/enums/gender_age_category.dart';
import 'package:ecomly_client/src/product/presentation/app/gender_age_category_notifier/gender_age_category_notifier.dart';

/// A horizontal selector for choosing a [GenderAgeCategory].
///
/// Displays all values of the [GenderAgeCategory] enum as [ChoiceChip] widgets
/// and highlights the currently selected category. Selection state is managed
/// by [GenderAgeCategoryNotifier] using Riverpod.
///
/// ### Example
/// ```dart
/// GenderAgeCategorySelector(
///   genderAgeCategoryNotifierFamilyKey: GlobalKey(),
/// )
/// ```
///
/// Typically used in product listing or filtering UIs to allow users
/// to switch between categories like **Men, Women, Kids, All**.
class GenderAgeCategorySelector extends ConsumerWidget {
  const GenderAgeCategorySelector({
    required this.genderAgeCategoryNotifierFamilyKey,
    super.key,
  });

  /// A unique key to scope the associated [GenderAgeCategoryNotifier] provider instance.
  final GlobalKey genderAgeCategoryNotifierFamilyKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGenderAgeCategory = ref.watch(
      genderAgeCategoryNotifierProvider(genderAgeCategoryNotifierFamilyKey),
    );

    return SizedBox(
      height: 40,
      child: Theme(
        data: context.theme.copyWith(canvasColor: Colors.transparent),
        child: ListView.separated(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: GenderAgeCategory.values.length,
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final category = GenderAgeCategory.values[index];
            final selected = selectedGenderAgeCategory == category;

            return ChoiceChip(
              label: Text(category.title),
              labelStyle: selected
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
              selected: selected,
              selectedColor: Colours.lightThemePrimaryColour,
              showCheckmark: false,
              backgroundColor: Colors.transparent,
              onSelected: (_) {
                ref
                    .read(
                      genderAgeCategoryNotifierProvider(
                        genderAgeCategoryNotifierFamilyKey,
                      ).notifier,
                    )
                    .changeCategory(category);
              },
            );
          },
        ),
      ),
    );
  }
}
