class UserSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool privateProfile;
  final bool showOnlineStatus;
  final String themeMode; // 'light', 'dark', 'system'
  final String language;

  UserSettings({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.privateProfile = false,
    this.showOnlineStatus = true,
    this.themeMode = 'system',
    this.language = 'en',
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      privateProfile: json['privateProfile'] ?? false,
      showOnlineStatus: json['showOnlineStatus'] ?? true,
      themeMode: json['themeMode'] ?? 'system',
      language: json['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'privateProfile': privateProfile,
      'showOnlineStatus': showOnlineStatus,
      'themeMode': themeMode,
      'language': language,
    };
  }

  UserSettings copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? privateProfile,
    bool? showOnlineStatus,
    String? themeMode,
    String? language,
  }) {
    return UserSettings(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      privateProfile: privateProfile ?? this.privateProfile,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}
