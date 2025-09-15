import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/presentation/adapter/auth_user_provider.dart';

/// A **Save button** used in user-related forms (e.g., updating profile info).
///
/// It interacts with [authUserProvider] to trigger the `updateUser` action
/// and shows a loading state while the update is in progress.
///
/// ### Example:
/// ```dart
/// UpdateUserButton(
///   updateData: {'name': 'John Doe', 'email': 'john@example.com'},
///   changeNotifier: ValueNotifier(true),
///   authUserAdapterFamilyKey: GlobalKey(),
///   onPressed: () => print('Updating user...'),
/// )
/// ```
class UpdateUserButton extends ConsumerStatefulWidget {
  const UpdateUserButton({
    required this.updateData,
    required this.changeNotifier,
    required this.authUserAdapterFamilyKey,
    this.onPressed,
    super.key,
  });

  /// Tracks whether form data has changed.
  final ValueNotifier<bool> changeNotifier;

  /// The data payload (fields to update).
  final DataMap updateData;

  /// Optional callback executed before calling the provider.
  final VoidCallback? onPressed;

  /// A [GlobalKey] for scoping the [authUserProvider] family instance.
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
          // Optional pre-submit action (like form validation)
          widget.onPressed?.call();

          // Trigger user update via Riverpod provider
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
