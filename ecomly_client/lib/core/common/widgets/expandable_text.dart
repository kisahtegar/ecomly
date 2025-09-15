import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';

/// A text widget that automatically truncates long content and provides
/// a "More"/"Less" toggle for expanding/collapsing the full text.
///
/// The `ExpandableText` is useful for displaying long descriptions, reviews,
/// or content where screen space is limited. It initially shows only the first
/// 2 lines of text, and if the content exceeds this limit, it adds a "More"
/// link that users can tap to view the full text.
///
/// Features:
/// - **Automatic Truncation**: Shows first 2 lines by default
/// - **Smart Detection**: Only shows expand/collapse if text actually exceeds 2 lines
/// - **Toggle Interaction**: "More" expands, "Less" collapses the text
/// - **Custom Styling**: Accepts optional [TextStyle] override
/// - **Responsive Width**: Uses 90% of the available screen width for layout calculation
/// - **Accessible**: Uses [TapGestureRecognizer] for proper touch handling
///
/// ### Example usage:
/// ```dart
/// ExpandableText(
///   context,
///   text: 'This is a very long product description that will be truncated...'
///       'and users can tap More to see the full content.',
///   style: TextStyle(fontSize: 14, color: Colors.grey),
/// )
/// ```
///
/// ```dart
/// // With default styling
/// ExpandableText(
///   context,
///   text: longProductDescription,
/// )
/// ```
///
/// ### Behavior:
/// - If text fits in 2 lines or less: Shows full text without "More" link
/// - If text exceeds 2 lines: Shows truncated text with "More" link
/// - When expanded: Shows full text with "Less" link
/// - Toggle state is preserved during widget rebuilds
class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.context, {
    required this.text,
    super.key,
    this.style,
  });

  /// The [BuildContext] used for responsive width calculations.
  ///
  /// This is required to determine the available screen width for text layout
  /// measurement. The widget uses 90% of the screen width for calculations.
  final BuildContext context;

  /// The text content to display.
  ///
  /// This string will be automatically truncated if it exceeds 2 lines
  /// when rendered with the specified [style] and available width.
  final String text;

  /// Optional custom text styling.
  final TextStyle? style;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;
  late TextSpan textSpan;
  late TextPainter textPainter;

  @override
  void initState() {
    textSpan = TextSpan(text: widget.text);

    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: expanded ? null : 2,
    )..layout(maxWidth: widget.context.width * .9);
    super.initState();
  }

  @override
  void dispose() {
    textPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const defaultStyle = TextStyle(
      height: 1.8,
      fontSize: 16,
      color: Colours.lightThemeSecondaryTextColour,
    );
    return Container(
      child: textPainter.didExceedMaxLines
          ? RichText(
              text: TextSpan(
                text: expanded
                    ? widget.text
                    : '${widget.text.substring(0, textPainter.getPositionForOffset(Offset(widget.context.width, widget.context.height)).offset)}...',
                style: widget.style ?? defaultStyle,
                children: [
                  TextSpan(
                    text: expanded ? ' Less' : 'More',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          expanded = !expanded;
                        });
                      },
                    style: const TextStyle(
                      color: Colours.lightThemeSecondaryColour,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Text(widget.text, style: widget.style ?? defaultStyle),
    );
  }
}
