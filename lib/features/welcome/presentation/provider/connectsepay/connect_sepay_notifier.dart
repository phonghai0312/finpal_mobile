// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/config/routing/app_routes.dart';

/// STATE
class ConnectSepayState {
  final bool copied; // Đã copy URL chưa
  final bool isChecking; // Đang xử lý loading
  final String webhookUrl; // Webhook URL của user

  const ConnectSepayState({
    this.copied = false,
    this.isChecking = false,
    this.webhookUrl = "https://api.vithongminh.com/webhook/sepay/abc123xyz",
  });

  ConnectSepayState copyWith({
    bool? copied,
    bool? isChecking,
    String? webhookUrl,
  }) {
    return ConnectSepayState(
      copied: copied ?? this.copied,
      isChecking: isChecking ?? this.isChecking,
      webhookUrl: webhookUrl ?? this.webhookUrl,
    );
  }
}

/// NOTIFIER
class ConnectSepayNotifier extends StateNotifier<ConnectSepayState> {
  ConnectSepayNotifier() : super(const ConnectSepayState());

  /// Copy URL
  Future<void> copyUrl(BuildContext context) async {
    state = state.copyWith(copied: true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã sao chép Webhook URL"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Mở website Sepay
  Future<void> openSepay() async {
    final url = Uri.parse("https://my.sepay.vn");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> confirm(BuildContext context) async {
    state = state.copyWith(isChecking: true);

    await Future.delayed(const Duration(milliseconds: 700));

    state = state.copyWith(isChecking: false);

    context.go(AppRoutes.home);
  }

  void onPressBack(BuildContext context) {
    context.go(AppRoutes.welcome);
  }
}
