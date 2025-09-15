import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/core/common/widgets/input_field.dart';
import 'package:ecomly_client/core/common/widgets/rounded_button.dart';
import 'package:ecomly_client/core/common/widgets/vertical_label_field.dart';
import 'package:ecomly_client/core/extensions/widget_extensions.dart';
import 'package:ecomly_client/core/utils/core_utils.dart';
import 'package:ecomly_client/src/auth/presentation/app/adapter/auth_adapter.dart';

class RegistrationForm extends ConsumerStatefulWidget {
  const RegistrationForm({super.key});

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final obscurePasswordNotifier = ValueNotifier(true);
  final obscureConfirmPasswordNotifier = ValueNotifier(true);

  final countryNotifier = ValueNotifier<Country?>(null);

  void pickCountry() {
    showCountryPicker(
      context: context,
      onSelect: (country) {
        if (country != countryNotifier.value) countryNotifier.value = country;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    countryNotifier.addListener(() {
      if (countryNotifier.value == null) {
        phoneController.clear();
        countryController.clear();
      } else {
        countryController.text = '+${countryNotifier.value!.phoneCode}';
      }
    });

    ref.listenManual(authAdapterProvider(), (previous, next) {
      if (next is AuthError) {
        final AuthError(:message) = next;
        CoreUtils.showSnackBar(context, message: message);
      } else if (next is Registered) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    countryController.dispose();
    obscurePasswordNotifier.dispose();
    obscureConfirmPasswordNotifier.dispose();
    countryNotifier.dispose();
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
            label: 'Full Name',
            controller: fullNameController,
            hintText: 'Enter your name',
            keyboardType: TextInputType.name,
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Email',
            controller: emailController,
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const Gap(20),
          ValueListenableBuilder(
            valueListenable: countryNotifier,
            builder: (context, country, __) {
              return VerticalLabelField(
                label: 'Phone',
                enabled: country != null,
                hintText: 'Enter your phone number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (!isPhoneValid(
                    value!,
                    defaultCountryCode: country?.countryCode,
                  )) {
                    return 'Invalid Phone number';
                  }
                  return null;
                },
                inputFormatters: [
                  PhoneInputFormatter(defaultCountryCode: country?.countryCode),
                ],
                mainFieldFlex: 3,
                prefix: InputField(
                  controller: countryController,
                  defaultValidation: false,
                  readOnly: true,
                  contentPadding: const EdgeInsets.only(left: 10),
                  suffixIcon: GestureDetector(
                    onTap: pickCountry,
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                  suffixIconConstraints: const BoxConstraints(),
                  validator: (_) {
                    if (!isPhoneValid(
                      phoneController.text,
                      defaultCountryCode: country?.countryCode,
                    )) {
                      return '';
                    }
                    return null;
                  },
                ),
              );
            },
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
          ValueListenableBuilder(
            valueListenable: obscureConfirmPasswordNotifier,
            builder: (_, obscureConfirmPassword, __) {
              return VerticalLabelField(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Re-enter your password',
                obscureText: obscureConfirmPassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureConfirmPasswordNotifier.value =
                        !obscureConfirmPasswordNotifier.value;
                  },
                  child: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
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
            text: 'Sign Up',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final phoneNumber = phoneController.text.trim();
                final country = countryNotifier.value!;
                final formattedNumber =
                    '+${country.phoneCode}'
                    '${toNumericString(phoneNumber)}';

                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final fullName = fullNameController.text.trim();

                ref
                    .read(authAdapterProvider().notifier)
                    .register(
                      name: fullName,
                      email: email,
                      password: password,
                      phone: formattedNumber,
                    );
              }
            },
          ).loading(authState is AuthLoading),
        ],
      ),
    );
  }
}
