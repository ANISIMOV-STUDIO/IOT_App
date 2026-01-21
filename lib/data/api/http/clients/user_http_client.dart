/// User HTTP Client - работа с настройками пользователя
library;

import 'package:hvac_control/core/config/api_config.dart';
import 'package:hvac_control/data/api/http/base_http_client.dart';
import 'package:hvac_control/domain/entities/user_preferences.dart';

/// HTTP клиент для работы с пользовательскими настройками
class UserHttpClient extends BaseHttpClient {
  UserHttpClient(super.apiClient);

  /// Базовый URL для User API
  String get _baseUrl => '${ApiConfig.apiBaseUrl}/user';

  /// Получить настройки пользователя
  Future<UserPreferences> getPreferences() async => get(
        '$_baseUrl/preferences',
        (json) => UserPreferences.fromJson(json as Map<String, dynamic>),
      );

  /// Обновить настройки пользователя (частичное обновление)
  ///
  /// Передавать только те поля, которые нужно изменить.
  Future<UserPreferences> updatePreferences({
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    String? theme,
    String? language,
  }) async {
    final body = <String, dynamic>{
      if (pushNotificationsEnabled != null)
        'pushNotificationsEnabled': pushNotificationsEnabled,
      if (emailNotificationsEnabled != null)
        'emailNotificationsEnabled': emailNotificationsEnabled,
      if (theme != null) 'theme': theme,
      if (language != null) 'language': language,
    };

    return patch(
      '$_baseUrl/preferences',
      body,
      (json) => UserPreferences.fromJson(json as Map<String, dynamic>),
    );
  }
}
