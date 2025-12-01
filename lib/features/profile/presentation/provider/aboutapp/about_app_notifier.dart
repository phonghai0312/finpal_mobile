import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';

class AboutAppState {
  final String appName;
  final String version;
  final String buildNumber;
  final String description;

  const AboutAppState({
    this.appName = 'FinPal – Smart Wallet',
    this.version = '1.0.0',
    this.buildNumber = '100',
    this.description =
        'FinPal is an intelligent personal finance assistant '
        'that helps you track expenses, analyze spending habits, and build better financial routines.',
  });
}

class AboutAppNotifier extends StateNotifier<AboutAppState> {
  final Ref ref;

  AboutAppNotifier(this.ref) : super(const AboutAppState());

  /// Back
  void onBack(BuildContext context) => context.go(AppRoutes.profile);

  /// Optional: đi đến trang Licenses nếu có
  // void goToLicenses(BuildContext context) =>
  //     context.push(AppRoutes.licensesPage);
}
