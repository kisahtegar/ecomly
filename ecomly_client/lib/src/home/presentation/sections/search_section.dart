import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/core/common/widgets/input_field.dart';
import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';

/// A reusable **search bar widget** used in Home and Search screens.
///
/// It is wrapped in a [Hero] widget with the tag `'/search-section'` to provide
/// a smooth transition when navigating to a dedicated search page.
///
/// ### Example:
/// ```dart
/// SearchSection(
///   readOnly: true,
///   onTap: () => context.push(SearchView.path),
/// )
///
/// SearchSection(
///   controller: myController,
///   onSubmitted: (query) => searchProducts(query),
///   suffixIcon: Icon(Icons.mic),
/// )
/// ```
class SearchSection extends StatefulWidget {
  const SearchSection({
    super.key,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.controller,
    this.onSubmitted,
  });

  /// Optional external [TextEditingController].
  final TextEditingController? controller;

  /// Callback for when the user submits the search.
  final ValueChanged<String>? onSubmitted;

  /// Callback when the field is tapped.
  final VoidCallback? onTap;

  /// If true, disables text input but keeps the tap interaction.
  final bool readOnly;

  /// Custom widget to show at the end of the field.
  final Widget? suffixIcon;

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    focusNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '/search-section',
      flightShuttleBuilder: (context, __, ___, ____, _____) {
        // Smooth Hero animation: transition background to match destination
        return Material(
          color: context.theme.scaffoldBackgroundColor,
          child: const SearchSection(readOnly: true),
        );
      },
      child: InputField(
        controller: controller,
        focusNode: focusNode,
        defaultValidation: false,
        readOnly: widget.readOnly,
        hintText: 'Search for products',
        onTap: widget.onTap,
        prefixIcon: const Icon(IconlyLight.search),
        onTapOutside: (_) => focusNode.unfocus(),
        onSubmitted: widget.onSubmitted,
        suffixIcon: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Divider color adapts to focus state
              ListenableBuilder(
                listenable: focusNode,
                builder: (context, __) {
                  return VerticalDivider(
                    color: focusNode.hasFocus
                        ? Colours.lightThemePrimaryColour
                        : Colours.lightThemeWhiteColour,
                    indent: 10,
                    endIndent: 10,
                    width: 20,
                  );
                },
              ),
              // Show custom suffix icon if provided, else fallback to filter icon
              if (widget.suffixIcon != null)
                widget.suffixIcon!
              else
                const Icon(IconlyLight.filter, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
