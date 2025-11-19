class UserSettings {
  final String currency;
  final String language;
  final String timezone;
  final bool notificationEnabled;

  UserSettings({
    required this.currency,
    required this.language,
    required this.timezone,
    required this.notificationEnabled,
  });

  UserSettings copyWith({
    String? currency,
    String? language,
    String? timezone,
    bool? notificationEnabled,
  }) {
    return UserSettings(
      currency: currency ?? this.currency,
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}
