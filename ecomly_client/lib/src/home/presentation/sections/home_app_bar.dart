import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/common/widgets/ecomly_logo.dart';
import 'package:ecomly_client/core/common/widgets/menu_icon.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/home/presentation/widgets/reactive_cart_icon.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final adaptiveColour = Colours.classicAdaptiveTextColour(context);

    return AppBar(
      leading: const MenuIcon(),
      centerTitle: false,
      titleSpacing: 0,
      title: EcomlyLogo(
        style: TextStyles.headingSemiBold.copyWith(
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: Colours.lightThemePrimaryColour,
            darkModeColour: Colours.lightThemePrimaryTint,
          ),
        ),
      ),
      bottom: const AppBarBottom(),
      actions: [
        const ReactiveCartIcon(),
        const Gap(20),
        Icon(IconlyBold.scan, color: adaptiveColour),
        const Gap(20),
      ],
    );
  }
}
