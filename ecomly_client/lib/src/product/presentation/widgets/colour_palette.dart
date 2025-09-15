import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A horizontal palette of selectable colours represented as circular swatches.
///
/// The [ColourPalette] widget:
/// - Displays each colour in [colours] as a circular chip.
/// - Allows selecting a single colour, highlighting it with a border.
/// - Invokes [onSelect] with the selected colour (or `null` if deselected).
/// - Can optionally scroll if [canScroll] is `true`.
///
/// ### Example
/// ```dart
/// ColourPalette(
///   colours: [Colors.red, Colors.green, Colors.blue],
///   radius: 16,
///   onSelect: (color) {
///     print('Selected: $color');
///   },
///   spacing: 8,
///   padding: EdgeInsets.symmetric(horizontal: 12),
/// )
/// ```
class ColourPalette extends StatefulWidget {
  const ColourPalette({
    super.key,
    required this.colours,
    required this.radius,
    this.onSelect,
    this.canScroll = false,
    this.spacing,
    this.padding,
  });

  /// The list of [Color]s to display as selectable swatches.
  final List<Color> colours;

  /// Callback invoked when a swatch is tapped. Passes the selected [Color] or `null` if deselected.
  final ValueChanged<Color?>? onSelect;

  /// Radius of each colour swatch (chip size will be `radius * 2`).
  final double radius;

  /// Enables horizontal scrolling if `true`. Defaults to `false` (all colours fit in one row).
  final bool canScroll;

  /// Optional gap between swatches. Defaults to `2.0`.
  final double? spacing;

  /// Optional padding around the palette container.
  final EdgeInsetsGeometry? padding;

  @override
  State<ColourPalette> createState() => _ColourPaletteState();
}

class _ColourPaletteState extends State<ColourPalette> {
  /// Currently selected colour (or `null` if none).
  Color? selectedColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        gradient: const LinearGradient(
          colors: [Color(0x50aa4b6b), Color(0x506b6b83), Color(0x503b8d99)],
        ),
      ),
      child: SizedBox(
        height: widget.radius * 2,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.all(2),
          physics: widget.canScroll
              ? null
              : const NeverScrollableScrollPhysics(),
          itemCount: widget.colours.length,
          separatorBuilder: (_, __) => Gap(widget.spacing ?? 2),
          itemBuilder: (context, index) {
            final colour = widget.colours[index];
            final isActive = selectedColour == colour;

            final swatch = Container(
              height: widget.radius * 2,
              width: widget.radius * 2,
              decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
            );

            return GestureDetector(
              onTap: widget.onSelect == null
                  ? null
                  : () {
                      Color? activeColour = colour;
                      // Toggle selection if the same swatch is tapped again
                      if (selectedColour == activeColour) activeColour = null;
                      widget.onSelect!(activeColour);
                      setState(() {
                        selectedColour = activeColour;
                      });
                    },
              child: isActive
                  ? Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: colour),
                      ),
                      child: swatch,
                    )
                  : swatch,
            );
          },
        ),
      ),
    );
  }
}
