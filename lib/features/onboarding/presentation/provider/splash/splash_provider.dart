import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'splash_notifier.dart';

/// Provider
final splashNotifierProvider =
    StateNotifierProvider.autoDispose<SplashNotifier, SplashState>(
      (ref) => SplashNotifier(),
    );
