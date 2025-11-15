// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_routes.dart';

final splashNotifierProvider =
    StateNotifierProvider<SplashNotifier, SplashState>(
      (ref) => SplashNotifier(),
    );

/// STATE
class SplashState {
  final AnimationController? controller;
  final Animation<double>? scaleAnim;
  final Animation<double>? fadeAnim;
  final bool hasNavigated;

  const SplashState({
    this.controller,
    this.scaleAnim,
    this.fadeAnim,
    this.hasNavigated = false,
  });

  SplashState copyWith({
    AnimationController? controller,
    Animation<double>? scaleAnim,
    Animation<double>? fadeAnim,
    bool? hasNavigated,
  }) {
    return SplashState(
      controller: controller ?? this.controller,
      scaleAnim: scaleAnim ?? this.scaleAnim,
      fadeAnim: fadeAnim ?? this.fadeAnim,
      hasNavigated: hasNavigated ?? this.hasNavigated,
    );
  }
}

/// NOTIFIER
class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier() : super(const SplashState());

  /// Initialize when screen opens
  Future<void> init(BuildContext context, TickerProvider vsync) async {
    final controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1800),
    );

    final scaleAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    final fadeAnim = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    state = state.copyWith(
      controller: controller,
      scaleAnim: scaleAnim,
      fadeAnim: fadeAnim,
    );

    await controller.forward();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!state.hasNavigated) {
      state = state.copyWith(hasNavigated: true);

      final prefs = await SharedPreferences.getInstance();
      final hasOpened = prefs.getBool('hasOpenedApp') ?? false;

      if (hasOpened) {
        context.go(AppRoutes.home);
      } else {
        await prefs.setBool('hasOpenedApp', true);
        context.go(AppRoutes.onboarding);
      }
    }
  }

  /// Dispose
  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}
