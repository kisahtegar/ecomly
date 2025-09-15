import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/extensions/text_style_extensions.dart';
import 'package:ecomly_client/core/resources/styles/colours.dart';
import 'package:ecomly_client/core/resources/styles/text_styles.dart';
import 'package:ecomly_client/src/auth/presentation/app/adapter/auth_adapter.dart';

class OTPTimer extends ConsumerStatefulWidget {
  const OTPTimer({required this.email, required this.familyKey, super.key});

  final String email;
  final GlobalKey familyKey;

  @override
  ConsumerState<OTPTimer> createState() => _OTPTimerState();
}

class _OTPTimerState extends ConsumerState<OTPTimer> {
  int _mainDuration = 60;

  int _duration = 60;

  int increment = 10;

  Timer? _timer;

  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    ref.listenManual(authAdapterProvider(widget.familyKey), (previous, next) {
      if (next is OTPSent) {
        _startTimer();
        setState(() {
          canResend = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration--;
      });
      if (_duration == 0) {
        // we use 10 seconds increment after each resend
        if (_mainDuration > 60) increment *= 2;

        _mainDuration += increment;
        _duration = _mainDuration;

        timer.cancel();

        setState(() {
          canResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _duration ~/ 60;
    final seconds = _duration.remainder(60);

    final authState = ref.read(authAdapterProvider(widget.familyKey));

    return Center(
      child: switch (canResend) {
        true => switch (authState) {
          AuthLoading _ => const SizedBox.shrink(),
          _ => TextButton(
            onPressed: () {
              ref
                  .read(authAdapterProvider(widget.familyKey).notifier)
                  .forgotPassword(email: widget.email);
            },
            child: Text(
              'Resend Code',
              style: TextStyles.headingMedium4.primary,
            ),
          ),
        },
        _ => RichText(
          text: TextSpan(
            text: 'Resend code in ',
            style: TextStyles.headingMedium4.grey,
            children: [
              TextSpan(
                text: '$minutes:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colours.lightThemePrimaryColour),
              ),
              const TextSpan(text: ' seconds'),
            ],
          ),
        ),
      },
    );
  }
}
