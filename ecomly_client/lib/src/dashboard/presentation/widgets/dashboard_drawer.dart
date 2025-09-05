import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/bottom_sheet_card.dart';
import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/dashboard/presentation/app/dashboard_state.dart';
import 'package:ecomly_client/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:ecomly_client/src/dashboard/presentation/widgets/theme_toggle.dart';
import 'package:ecomly_client/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:ecomly_client/src/user/presentation/views/payment_profile_view.dart';
import 'package:ecomly_client/src/user/presentation/views/profile_view.dart';
import 'package:ecomly_client/src/wishlist/presentation/views/wishlist_view.dart';

class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  final signingOutNotifier = ValueNotifier(false);
  final authUserFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.listenManual(authUserProvider(authUserFamilyKey), (previous, next) {
      if (next is AuthUserError) {
        final AuthUserError(:message) = next;
        Scaffold.of(context).closeDrawer();
        CoreUtils.showSnackBar(context, message: message);
      } else if (next case FetchedUserPaymentProfile(
        :final paymentProfileUrl,
      )) {
        context.push(PaymentProfileView.path, extra: paymentProfileUrl);
      }
    });
  }

  @override
  void dispose() {
    signingOutNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    final authUserAdapter = ref.watch(authUserProvider(authUserFamilyKey));

    return Drawer(
      backgroundColor: CoreUtils.adaptiveColour(
        context,
        lightModeColour: Colours.lightThemeWhiteColour,
        darkModeColour: Colours.darkThemeDarkSharpColour,
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colours.lightThemePrimaryColour,
                    child: Center(
                      child: Text(
                        user!.name.initials,
                        style: TextStyles.headingMedium.white,
                      ),
                    ),
                  ),
                  const Gap(15),
                  Text(
                    user.name,
                    style: TextStyles.headingMedium.adaptiveColour(context),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                color: CoreUtils.adaptiveColour(
                  context,
                  lightModeColour: Colours.lightThemeWhiteColour,
                  darkModeColour: Colours.darkThemeDarkNavBarColour,
                ),
              ),
              itemCount: DashboardUtils.drawerItems.length,
              itemBuilder: (_, index) {
                final drawerItem = DashboardUtils.drawerItems[index];
                return ListTile(
                  leading: Icon(
                    drawerItem.icon,
                    color: Colours.classicAdaptiveTextColour(context),
                  ),
                  title:
                      Text(
                        drawerItem.title,
                        style: TextStyles.headingMedium3.adaptiveColour(
                          context,
                        ),
                      ).loading(
                        index == 1 &&
                            authUserAdapter is GettingUserPaymentProfile,
                      ),
                  onTap: () {
                    if (index != 1) Scaffold.of(context).closeDrawer();
                    switch (index) {
                      case 0:
                        context.push(ProfileView.path);
                      case 1:
                        ref
                            .read(authUserProvider(authUserFamilyKey).notifier)
                            .getUserPaymentProfile(Cache.instance.userId!);
                      case 2:
                        DashboardState.instance.changeIndex(3);
                        context.go(WishlistView.path);
                      case 3:
                      // TODO(Nav): Go to OrdersPage
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(bottom: 20, top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ThemeToggle(),
                const Gap(10),
                ValueListenableBuilder(
                  valueListenable: signingOutNotifier,
                  builder: (_, value, __) {
                    return RoundedButton(
                      height: 50,
                      text: 'Sign Out',
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          isDismissible: false,
                          builder: (_) {
                            return const BottomSheetCard(
                              title: 'Are you sure you want to Sign out?',
                              positiveButtonText: 'Yes',
                              negativeButtonText: 'Cancel',
                              positiveButtonColour:
                                  Colours.lightThemeSecondaryColour,
                            );
                          },
                        );

                        if (result ?? false) {
                          signingOutNotifier.value = true;
                          await sl<CacheHelper>().resetSession();
                          router.go('/');
                        }
                      },
                    ).loading(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
