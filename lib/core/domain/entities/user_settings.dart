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
}
