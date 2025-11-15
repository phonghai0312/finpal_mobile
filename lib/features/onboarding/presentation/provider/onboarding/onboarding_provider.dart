import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_notifier.dart';

/// Provider
final onboardingNotifierProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
      (ref) => OnboardingNotifier(),
    );
