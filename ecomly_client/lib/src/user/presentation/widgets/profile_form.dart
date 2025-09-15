import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'package:ecomly_client/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

/// A form widget for editing the current user's profile details.
///
/// It binds user data (name, email, phone) to text controllers and updates
/// external notifiers to track changes. Useful when combined with an
/// [UpdateUserButton].
///
/// ### Behavior:
/// - Initializes form fields with current user data from [currentUserProvider].
/// - Tracks differences between form fields and the current user.
/// - If a field changes:
///   - Updates [updateContainer] with the modified key-value.
///   - Sets [changeNotifier] to `true`.
/// - If reverted back to original values:
///   - Clears [updateContainer].
///   - Sets [changeNotifier] to `false`.
///
/// ### Example:
/// ```dart
/// final nameNotifier = ValueNotifier('');
/// final changeNotifier = ValueNotifier(false);
/// final updateContainer = <String, dynamic>{};
///
/// ProfileForm(
///   nameFocusNode: FocusNode(),
///   nameNotifier: nameNotifier,
///   changeNotifier: changeNotifier,
///   updateContainer: updateContainer,
/// )
/// ```
///
/// Later, you can use [updateContainer] with [UpdateUserButton] to submit only
/// the changed fields.
class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({
    required this.nameFocusNode,
    required this.nameNotifier,
    required this.changeNotifier,
    required this.updateContainer,
    super.key,
  });

  /// notifies listeners about the current "Full Name" value.
  final ValueNotifier<String> nameNotifier;

  /// focus node for the "Full Name" field (to control focus externally).
  final FocusNode nameFocusNode;

  /// indicates whether any form field has unsaved changes.
  final ValueNotifier<bool> changeNotifier;

  /// a mutable map storing only changed fields to be sent when updating the user.
  final DataMap updateContainer;

  @override
  ConsumerState createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nameController = TextEditingController(text: currentUser().name.trim())
      ..addListener(nameControllerListener);
    emailController = TextEditingController(text: currentUser().email.trim())
      ..addListener(emailControllerListener);
    phoneController = TextEditingController(text: currentUser().phone?.trim())
      ..addListener(phoneControllerListener);
  }

  @override
  void dispose() {
    nameController
      ..removeListener(nameControllerListener)
      ..dispose();
    emailController
      ..removeListener(emailControllerListener)
      ..dispose();
    phoneController
      ..removeListener(phoneControllerListener)
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(currentUserProvider, (previous, next) {
      if (noChanges()) {
        widget.changeNotifier.value = false;
        widget.updateContainer.clear();
      }
    });
  }

  /// Checks if all form fields match the [currentUserProvider] values.
  bool noChanges() {
    final currentUser = ref.watch(currentUserProvider)!;
    return nameController.text.toLowerCase().trim() ==
            currentUser.name.toLowerCase().trim() &&
        emailController.text.toLowerCase().trim() ==
            currentUser.email.toLowerCase().trim() &&
        phoneController.text.toLowerCase().trim() ==
            currentUser.phone?.toLowerCase().trim();
  }

  /// Returns the current user entity from [currentUserProvider].
  User currentUser() {
    return ref.watch(currentUserProvider)!;
  }

  /// Listener: reacts to "Full Name" changes.
  void nameControllerListener() {
    widget.nameNotifier.value = nameController.text.trim();
    if (nameController.text.toLowerCase().trim() !=
        currentUser().name.toLowerCase().trim()) {
      widget.changeNotifier.value = true;
      widget.updateContainer['name'] = nameController.text.trim();
    } else if (noChanges()) {
      widget.changeNotifier.value = false;
      widget.updateContainer.clear();
    } else {
      widget.updateContainer.remove('name');
    }
  }

  /// Listener: reacts to "Email" changes.
  void emailControllerListener() {
    if (emailController.text.toLowerCase().trim() !=
        currentUser().email.toLowerCase().trim()) {
      widget.changeNotifier.value = true;
      widget.updateContainer['email'] = emailController.text.trim();
    } else if (noChanges()) {
      widget.changeNotifier.value = false;
      widget.updateContainer.clear();
    } else {
      widget.updateContainer.remove('email');
    }
  }

  /// Listener: reacts to "Phone" changes.
  void phoneControllerListener() {
    if (phoneController.text.toLowerCase().trim() !=
        currentUser().phone?.toLowerCase().trim()) {
      widget.changeNotifier.value = true;
      widget.updateContainer['phone'] = phoneController.text.trim();
    } else if (noChanges()) {
      widget.changeNotifier.value = false;
      widget.updateContainer.clear();
    } else {
      widget.updateContainer.remove('phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        VerticalLabelField(
          label: 'Full Name',
          focusNode: widget.nameFocusNode,
          controller: nameController,
          hintText: 'Enter your full name',
        ),
        const Gap(15),
        VerticalLabelField(
          label: 'Email',
          controller: emailController,
          hintText: 'Enter your email',
        ),
        const Gap(15),
        VerticalLabelField(
          label: 'Phone',
          controller: phoneController,
          hintText: 'Enter your phone number',
        ),
      ],
    );
  }
}
