import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/auth/presentation/app/adapter/auth_adapter.dart';
import 'package:ecomly_client/src/auth/presentation/views/forgot_password_screen.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    ref.listenManual(authAdapterProvider(), (previous, next) {
      if (next is AuthError) {
        final AuthError(:message) = next;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is LoggedIn) {
        context.go('/', extra: 'home');
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscurePasswordNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authAdapterProvider());

    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: obscurePasswordNotifier,
            builder: (_, obscurePassword, __) {
              return VerticalLabelField(
                label: 'Password',
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter your password',
                obscureText: obscurePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscurePasswordNotifier.value =
                        !obscurePasswordNotifier.value;
                  },
                  child: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              );
            },
          ),
          const Gap(20),
          SizedBox(
            width: double.maxFinite,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  context.push(ForgotPasswordScreen.path);
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyles.paragraphSubTextRegular1.primary,
                ),
              ),
            ),
          ),
          const Gap(40),
          RoundedButton(
            text: 'Sign In',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                ref
                    .read(authAdapterProvider().notifier)
                    .login(email: email, password: password);
              }
            },
          ).loading(authState is AuthLoading),
        ],
      ),
    );
  }
}
