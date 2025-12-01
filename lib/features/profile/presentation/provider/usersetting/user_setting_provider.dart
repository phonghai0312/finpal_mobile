import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/usersetting/user_setting_notifier.dart';

final userSettingsNotifierProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettingsState>((ref) {
      return UserSettingsNotifier();
    });
