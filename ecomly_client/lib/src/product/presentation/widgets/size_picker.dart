import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

/// A horizontal circular picker for selecting a clothing size.
///
/// Displays available product sizes (e.g., **S, M, L, XL**) as circular buttons.
/// Highlights the currently selected size and calls [onSelect] whenever the user
/// selects or deselects a size.
///
/// ### Example
/// ```dart
/// SizePicker(
///   sizes: ['S', 'M', 'L', 'XL'],
///   radius: 24,
///   onSelect: (size) {
///     debugPrint('Selected size: $size');
///   },
/// )
/// ```
///
/// Useful in product detail pages to let users pick their preferred size before
/// adding an item to the cart.
class SizePicker extends StatefulWidget {
  const SizePicker({
    required this.sizes,
    required this.radius,
    this.onSelect,
    this.canScroll = false,
    this.spacing,
    this.padding,
    super.key,
  });

  /// The list of available sizes (e.g., `['S', 'M', 'L', 'XL']`).
  final List<String> sizes;

  /// Callback invoked with the selected size, or `null` if deselected.
  final ValueChanged<String?>? onSelect;

  /// The radius of each circular size button.
  final double radius;

  /// Whether the list should be horizontally scrollable.
  final bool canScroll;

  /// Optional spacing between size buttons.
  final double? spacing;

  /// Optional padding around the list of sizes.
  final EdgeInsetsGeometry? padding;

  @override
  State<SizePicker> createState() => _SizePickerState();
}

class _SizePickerState extends State<SizePicker> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(2),
        physics: widget.canScroll ? null : const NeverScrollableScrollPhysics(),
        itemCount: widget.sizes.length,
        separatorBuilder: (_, __) => Gap(widget.spacing ?? 2),
        itemBuilder: (context, index) {
          final size = widget.sizes[index];
          final isActive = selectedSize?.toLowerCase() == size.toLowerCase();

          return GestureDetector(
            onTap: () {
              String? activeSize = size;
              if (widget.onSelect != null) {
                if (selectedSize?.toLowerCase() == activeSize.toLowerCase()) {
                  // Deselect if already selected
                  activeSize = null;
                }
                widget.onSelect!(activeSize);
                setState(() {
                  selectedSize = activeSize;
                });
              }
            },
            child: Container(
              height: widget.radius * 2,
              width: widget.radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colours.lightThemePrimaryColour : null,
                border: Border.all(
                  color: context.isDarkMode
                      ? Colours.lightThemeTintStockColour
                      : Colours.lightThemeSecondaryTextColour,
                ),
              ),
              child: Center(
                child: Text(
                  size.toUpperCase(),
                  style: TextStyles.headingSemiBold.copyWith(
                    fontSize: 20,
                    color: isActive
                        ? Colours.lightThemeWhiteColour
                        : Colours.lightThemeSecondaryTextColour,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
