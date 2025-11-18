class UserSettingsUpdateRequestModel {
  final String? currency;
  final String? language;
  final String? timezone;
  final bool? notificationEnabled;

  UserSettingsUpdateRequestModel({
    this.currency,
    this.language,
    this.timezone,
    this.notificationEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'language': language,
      'timezone': timezone,
      'notificationEnabled': notificationEnabled,
    };
  }
}
