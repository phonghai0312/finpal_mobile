import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'about_app_notifier.dart';

final aboutAppNotifierProvider =
    StateNotifierProvider<AboutAppNotifier, AboutAppState>((ref) {
      return AboutAppNotifier(ref);
    });
