import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';

/// STATE
class OnboardingState {
  final int currentIndex;
  final bool isAutoScrolling;

  const OnboardingState({this.currentIndex = 0, this.isAutoScrolling = false});

  OnboardingState copyWith({int? currentIndex, bool? isAutoScrolling}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isAutoScrolling: isAutoScrolling ?? this.isAutoScrolling,
    );
  }
}

/// NOTIFIER
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  late final PageController controller;
  Timer? _autoScrollTimer;
  Timer? _idleTimer;

  OnboardingNotifier() : super(const OnboardingState()) {
    controller = PageController();
    _resetIdleTimer();
  }

  /// Reset idle timer
  void _resetIdleTimer([int itemCount = 3]) {
    _idleTimer?.cancel();
    _stopAutoScroll();
    _idleTimer = Timer(
      const Duration(milliseconds: 3000),
      () => _startAutoScroll(itemCount),
    );
  }

  /// Start auto scroll
  void _startAutoScroll(int itemCount) {
    _autoScrollTimer?.cancel();
    state = state.copyWith(isAutoScrolling: true);

    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (state.currentIndex < itemCount - 1) {
        controller.nextPage(
          duration: const Duration(milliseconds: 1200),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        controller.animateToPage(
          0,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  /// Stop auto scroll
  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    state = state.copyWith(isAutoScrolling: false);
  }

  /// On page changed
  void onPageChanged(int index, int itemCount) {
    state = state.copyWith(currentIndex: index);
    _resetIdleTimer(itemCount);
  }

  /// On user interaction
  void onUserInteraction([int itemCount = 3]) => _resetIdleTimer(itemCount);

  /// Skip
  Future<void> skip(BuildContext context) async {
    _idleTimer?.cancel();
    _autoScrollTimer?.cancel();
    context.go(AppRoutes.login);
  }

  /// Dispose
  @override
  void dispose() {
    _idleTimer?.cancel();
    _autoScrollTimer?.cancel();
    controller.dispose();
    super.dispose();
  }
}
