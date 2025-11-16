import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';

// STATE
class WelcomeState {
  const WelcomeState();
}

// NOTIFIER
class WelcomeNotifier extends StateNotifier<WelcomeState> {
  WelcomeNotifier() : super(const WelcomeState());

  void continueNext(BuildContext context) {
    context.go(AppRoutes.connectsepay);
  }
}
