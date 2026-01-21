/// User Preferences Entity
///
/// Настройки пользователя, синхронизируемые с бэкендом.
library;

import 'package:equatable/equatable.dart';

/// Тема приложения (для API)
enum PreferenceTheme {
  light,
  dark;

  /// Из строки бэкенда
  static PreferenceTheme fromString(String value) => switch (value.toLowerCase()) {
        'dark' => PreferenceTheme.dark,
        _ => PreferenceTheme.light,
      };

  /// В строку для бэкенда
  String toApiString() => switch (this) {
        PreferenceTheme.light => 'Light',
        PreferenceTheme.dark => 'Dark',
      };
}

/// Язык интерфейса (для API)
enum PreferenceLanguage {
  russian,
  english;

  /// Из строки бэкенда
  static PreferenceLanguage fromString(String value) => switch (value.toLowerCase()) {
        'english' => PreferenceLanguage.english,
        _ => PreferenceLanguage.russian,
      };

  /// В строку для бэкенда
  String toApiString() => switch (this) {
        PreferenceLanguage.russian => 'Russian',
        PreferenceLanguage.english => 'English',
      };

  /// Код локали
  String get localeCode => switch (this) {
        PreferenceLanguage.russian => 'ru',
        PreferenceLanguage.english => 'en',
      };
}

/// Настройки пользователя
class UserPreferences extends Equatable {
  const UserPreferences({
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.theme = PreferenceTheme.light,
    this.language = PreferenceLanguage.russian,
  });

  /// Из JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool? ?? true,
        emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool? ?? true,
        theme: PreferenceTheme.fromString(json['theme'] as String? ?? 'Light'),
        language: PreferenceLanguage.fromString(json['language'] as String? ?? 'Russian'),
      );

  /// Push-уведомления включены
  final bool pushNotificationsEnabled;

  /// Email-уведомления включены
  final bool emailNotificationsEnabled;

  /// Тема приложения
  final PreferenceTheme theme;

  /// Язык интерфейса
  final PreferenceLanguage language;

  /// В JSON для PATCH (только не-null поля)
  Map<String, dynamic> toJson() => {
        'pushNotificationsEnabled': pushNotificationsEnabled,
        'emailNotificationsEnabled': emailNotificationsEnabled,
        'theme': theme.toApiString(),
        'language': language.toApiString(),
      };

  /// Копирование с изменениями
  UserPreferences copyWith({
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    PreferenceTheme? theme,
    PreferenceLanguage? language,
  }) => UserPreferences(
        pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
        emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
        theme: theme ?? this.theme,
        language: language ?? this.language,
      );

  @override
  List<Object?> get props => [
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        theme,
        language,
      ];
}
