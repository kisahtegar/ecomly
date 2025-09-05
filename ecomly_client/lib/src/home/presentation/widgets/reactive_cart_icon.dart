import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/core/utils/global_keys.dart';
import 'package:ecomly_client/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:ecomly_client/src/cart/presentation/views/cart_view.dart';

class ReactiveCartIcon extends ConsumerStatefulWidget {
  const ReactiveCartIcon({super.key});

  @override
  ConsumerState createState() => _HomeAppBarCartIconState();
}

class _HomeAppBarCartIconState extends ConsumerState<ReactiveCartIcon> {
  final countNotifier = ValueNotifier<int?>(null);
  final cartCountFamilyKey = GlobalKeys.cartCountFamilyKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(cartAdapterProvider(cartCountFamilyKey).notifier)
          .getCartCount(Cache.instance.userId!);
    });
    ref.listenManual(cartAdapterProvider(cartCountFamilyKey), (previous, next) {
      if (next case CartCountFetched(:final count)) {
        CoreUtils.postFrameCall(() {
          countNotifier.value = count;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(CartView.path),
      child: ValueListenableBuilder(
        valueListenable: countNotifier,
        builder: (_, value, __) {
          return Badge.count(
            backgroundColor: Colours.lightThemeSecondaryColour,
            count: value ?? 0,
            textColor: Colors.white,
            isLabelVisible: value != null && value > 0,
            child: Icon(
              IconlyBroken.buy,
              size: 24,
              color: Colours.classicAdaptiveTextColour(context),
            ),
          );
        },
      ),
    );
  }
}
