import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';

/// A circular stepper icon used to increase or decrease the quantity of a cart product.
///
/// This widget renders a circular button with either a `+` or `–` icon,
/// depending on the constructor used. It is typically displayed next to the
/// cart product quantity field in the cart screen.
class CartProductQuantityStepperIcon extends StatelessWidget {
  /// Creates a decrement button (with `–` icon).
  const CartProductQuantityStepperIcon.decrement({super.key, this.onTap})
    : increase = false;

  /// Creates an increment button (with `+` icon).
  const CartProductQuantityStepperIcon.increment({super.key, this.onTap})
    : increase = true;

  /// Whether this button represents an increment (`+`) or decrement (`–`).
  final bool increase;

  /// Callback executed when the button is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: Colours.lightThemeWhiteColour,
            darkModeColour: Colours.darkThemeDarkNavBarColour,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            increase ? Icons.add : Icons.remove,
            size: 14,
            color: Colours.classicAdaptiveTextColour(context),
          ),
        ),
      ),
    );
  }
}
