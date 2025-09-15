import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/auth/presentation/app/adapter/auth_adapter.dart';

class ResetPasswordForm extends ConsumerStatefulWidget {
  const ResetPasswordForm({required this.email, super.key});

  final String email;

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends ConsumerState<ResetPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final familyKey = GlobalKey();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    ref.listenManual(authAdapterProvider(familyKey), (previous, next) {
      if (next is AuthError) {
        final AuthError(:message) = next;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is PasswordReset) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authAdapterProvider(familyKey));

    return Form(
      key: formKey,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, obscurePassword, __) {
              return VerticalLabelField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscurePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                        !obscurePasswordNotifier.value;
                  },
                  child: Icon(switch (obscurePassword) {
                    true => Icons.visibility_off_outlined,
                    _ => Icons.visibility_outlined,
                  }),
                ),
              );
            },
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, obscureConfirmPassword, __) {
              return VerticalLabelField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureConfirmPassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureConfirmPasswordNotifier.value =
                        !obscureConfirmPasswordNotifier.value;
                  },
                  child: Icon(switch (obscureConfirmPassword) {
                    true => Icons.visibility_off_outlined,
                    _ => Icons.visibility_outlined,
                  }),
                ),
                validator: (value) {
                  if (value! != passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              );
            },
          ),
          const Gap(40),
          RoundedButton(
            text: 'Submit',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                ref
                    .read(authAdapterProvider(familyKey).notifier)
                    .resetPassword(
                      email: widget.email,
                      newPassword: passwordController.text.trim(),
                    );
              }
            },
          ).loading(authState is AuthLoading),
        ],
      ),
    );
  }
}
