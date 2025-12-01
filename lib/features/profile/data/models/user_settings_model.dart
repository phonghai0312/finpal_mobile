import 'package:fridge_to_fork_ai/core/domain/entities/user_settings.dart';

class UserSettingsModel extends UserSettings {
  UserSettingsModel({
    required super.currency,
    required super.language,
    required super.timezone,
    required super.notificationEnabled,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      currency: json['currency']?.toString() ?? 'VND',
      language: json['language']?.toString() ?? 'vi',
      timezone: json['timezone']?.toString() ?? 'Asia/Ho_Chi_Minh',
      notificationEnabled: json['notificationEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'language': language,
      'timezone': timezone,
      'notificationEnabled': notificationEnabled,
    };
  }
}
