import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/extensions/int_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/cart/presentation/widgets/cart_product_quantity_stepper_icon.dart';

/// A quantity stepper widget for cart products.
///
/// Displays decrement and increment buttons along with the current quantity.
/// Integrates with [CartAdapter] to handle updates, fetch fresh values, and
/// display errors when necessary.
///
/// Typically used inside the cart screen for each product.
class CartProductQuantityStepper extends ConsumerStatefulWidget {
  /// Creates a quantity stepper with an initial quantity and callbacks.
  const CartProductQuantityStepper(
    this.initialQuantity, {
    required this.counterKey,
    required this.cartProductId,
    required this.onStep,
    super.key,
  });

  /// The ID of the cart product this stepper is tied to.
  final String cartProductId;

  /// A unique [GlobalKey] to scope the `CartAdapter` provider.
  final GlobalKey counterKey;

  /// The quantity value shown at widget initialization.
  final int initialQuantity;

  /// Triggered whenever the quantity changes.
  ///
  /// - If the quantity is updated, passes the new value.
  /// - If no update is needed, passes `null`.
  final void Function(int? newQuantity) onStep;

  @override
  ConsumerState createState() => _CartProductQuantityStepperState();
}

class _CartProductQuantityStepperState
    extends ConsumerState<CartProductQuantityStepper> {
  late int initialQuantity;
  late ValueNotifier<int> quantityNotifier;

  @override
  void initState() {
    super.initState();
    initialQuantity = widget.initialQuantity;

    // Tracks the quantity value and invokes [onStep] whenever it changes.
    quantityNotifier = ValueNotifier(widget.initialQuantity)
      ..addListener(() {
        if (quantityNotifier.value != initialQuantity) {
          widget.onStep(quantityNotifier.value);
        } else {
          widget.onStep(null);
        }
      });
  }

  /// Fetches the latest value of this cart product from the backend using the [CartAdapter].
  void getCartProduct() {
    ref
        .read(cartAdapterProvider(widget.counterKey).notifier)
        .getCartProduct(
          userId: Cache.instance.userId!,
          cartProductId: widget.cartProductId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final cartAdapter = ref.watch(cartAdapterProvider(widget.counterKey));

    // Listen for cart state changes and react accordingly.
    ref.listen(cartAdapterProvider(widget.counterKey), (previous, next) {
      if (next is ChangedCartProductQuantity) {
        CoreUtils.postFrameCall(getCartProduct);
      } else if (next is CartError) {
        CoreUtils.showSnackBar(context, message: next.message);
        CoreUtils.postFrameCall(getCartProduct);
      } else if (next is CartProductFetched) {
        CoreUtils.postFrameCall(() {
          // I have to onStep here because when we fetch the fresh quantity
          // here and we update quantityNotifier.value, it doesn't trigger
          // it as at that point, they're essentially the same value

          // Now you might ask why do we need to do a re-fetch since it's
          // the same anyways both here and on the server after the update,
          // well, what if there's an error, when there's an error, we will
          // need this to be reset to whatever is the value on the server.

          // THIS MIGHT LEAD TO A RETRY LOOP THOUGH SO< BE CAREFUL HOW YOU
          // USE IT
          widget.onStep(null);
          initialQuantity = next.cartProduct.quantity;
          quantityNotifier.value = initialQuantity;
        });
      }
    });

    // Show a loading spinner while the quantity update is in progress.
    if (cartAdapter is ChangingCartProductQuantity) {
      return const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colours.lightThemePrimaryColour,
        ),
      );
    }

    // UI layout for the quantity stepper.
    return SizedBox(
      width: 127,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: ColoredBox(
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: const Color(0xffEEEFF2),
            darkModeColour: Colours.darkThemeDarkSharpColour,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CartProductQuantityStepperIcon.decrement(
                onTap: () {
                  if (quantityNotifier.value > 1) {
                    quantityNotifier.value--;
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: quantityNotifier,
                builder: (_, value, __) {
                  return Text(
                    value.pumpNumber,
                    style: TextStyles.paragraphSubTextRegular1.adaptiveColour(
                      context,
                    ),
                  );
                },
              ),
              CartProductQuantityStepperIcon.increment(
                onTap: () {
                  quantityNotifier.value++;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
