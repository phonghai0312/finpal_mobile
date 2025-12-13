import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_notifier.dart';

/// -------------------------------------------------------
/// HOME NOTIFIER PROVIDER
/// -------------------------------------------------------
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  return HomeNotifier(ref);
});
