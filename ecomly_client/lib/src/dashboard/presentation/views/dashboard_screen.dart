import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecomly_client/src/dashboard/presentation/utils/dashboard_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.state, required this.child, super.key});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: DashboardUtils.scaffoldKey, body: child);
  }
}
