import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/presentation/adapter/auth_user_provider.dart';

class UpdateUserButton extends ConsumerStatefulWidget {
  const UpdateUserButton({
    required this.updateData,
    required this.changeNotifier,
    required this.authUserAdapterFamilyKey,
    this.onPressed,
    super.key,
  });

  final ValueNotifier<bool> changeNotifier;
  final DataMap updateData;
  final VoidCallback? onPressed;
  final GlobalKey authUserAdapterFamilyKey;

  @override
  ConsumerState createState() => _UpdateUserButtonState();
}

class _UpdateUserButtonState extends ConsumerState<UpdateUserButton> {
  @override
  Widget build(BuildContext context) {
    final authUserAdapter = ref.watch(
      authUserProvider(widget.authUserAdapterFamilyKey),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RoundedButton(
        height: 50,
        onPressed: () {
          widget.onPressed?.call();
          ref
              .read(authUserProvider(widget.authUserAdapterFamilyKey).notifier)
              .updateUser(
                userId: Cache.instance.userId!,
                updateData: widget.updateData,
              );
        },
        text: 'Save',
      ).loading(authUserAdapter is UpdatingUserData),
    );
  }
}
