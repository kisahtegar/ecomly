import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';

import 'package:ecomly_client/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly_client/core/common/widgets/app_bar_bottom.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:ecomly_client/src/user/presentation/widgets/profile_form.dart';
import 'package:ecomly_client/src/user/presentation/widgets/update_user_button.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  static const path = '/profile';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final nameFocusNode = FocusNode();
  final nameNotifier = ValueNotifier('');
  final changeNotifier = ValueNotifier(false);
  final updateContainer = <String, dynamic>{};
  final authUserAdapterFamilyKey = GlobalKey();

  /// Whether this page is locked for editing
  final lockNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    ref.listenManual(authUserProvider(authUserAdapterFamilyKey), (
      previous,
      next,
    ) {
      if (next case AuthUserError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is UserUpdated) {
        CoreUtils.showSnackBar(context, message: 'Update Successful');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: const AppBarBottom(),
        actions: [
          ValueListenableBuilder(
            valueListenable: lockNotifier,
            builder: (_, isLocked, __) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    lockNotifier.value = !lockNotifier.value;
                    if (!lockNotifier.value) {
                      nameFocusNode.requestFocus();
                    } else {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    final message = lockNotifier.value
                        ? 'Profile Locked'
                        : 'Profile Unlocked';
                    CoreUtils.showSnackBar(context, message: message);
                  },
                  icon: Icon(isLocked ? IconlyBroken.edit : IconlyBroken.lock),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: nameNotifier,
                  builder: (_, nameFromController, __) {
                    final name =
                        lockNotifier.value && nameFromController.isEmpty
                        ? currentUser!.name
                        : nameFromController;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colours.lightThemePrimaryColour,
                          child: Center(
                            child: Text(
                              name.initials,
                              textAlign: TextAlign.center,
                              style: TextStyles.headingMedium.white,
                            ),
                          ),
                        ),
                        const Gap(15),
                        Center(
                          child: Text(
                            name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium.adaptiveColour(
                              context,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Gap(20),
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder(
                    valueListenable: lockNotifier,
                    builder: (_, isLocked, __) {
                      return AbsorbPointer(
                        absorbing: isLocked,
                        child: ProfileForm(
                          nameFocusNode: nameFocusNode,
                          nameNotifier: nameNotifier,
                          changeNotifier: changeNotifier,
                          updateContainer: updateContainer,
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: changeNotifier,
                  builder: (_, versionConflict, __) {
                    if (versionConflict) {
                      return UpdateUserButton(
                        updateData: updateContainer,
                        changeNotifier: changeNotifier,
                        authUserAdapterFamilyKey: authUserAdapterFamilyKey,
                        onPressed: () => lockNotifier.value = true,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
