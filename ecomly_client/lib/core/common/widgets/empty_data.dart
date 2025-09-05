import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';

class EmptyData extends StatelessWidget {
  const EmptyData(this.data, {super.key, this.padding});

  final String data;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyles.headingBold.copyWith(
            color: Colours.lightThemeSecondaryTextColour.withOpacity(.6),
          ),
        ),
      ),
    );
  }
}
