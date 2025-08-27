import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecomly_client/core/extensions/context_extensions.dart';
import 'package:ecomly_client/core/extensions/text_style_extensions.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'home',
            style: context.theme.textTheme.bodyLarge?.adaptiveColour(context),
          ),
        ),
      ),
    );
  }
}
