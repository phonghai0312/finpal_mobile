import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finpal/features/welcome/presentation/provider/welcome/welcome_notifier.dart';

final welcomeNotifierProvider =
    StateNotifierProvider<WelcomeNotifier, WelcomeState>(
      (ref) => WelcomeNotifier(),
    );
