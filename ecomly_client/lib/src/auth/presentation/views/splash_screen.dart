import 'package:ecomly_client/core/common/widgets/ecomly_logo.dart';
import 'package:flutter/material.dart';

import 'package:ecomly_client/core/resources/styles/colours.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const path = '/login';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.lightThemePrimaryColour,
      body: Center(child: EcomlyLogo()),
    );
  }
}
