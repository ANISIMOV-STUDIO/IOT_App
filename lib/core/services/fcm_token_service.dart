/// Сервис регистрации FCM токена на сервере
///
/// Отправляет FCM токен на backend для получения push уведомлений.
/// Автоматически обновляет токен при его изменении.
library;

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../data/api/platform/api_client.dart';
import 'push_notification_service.dart';

/// Сервис для регистрации FCM токена на backend
class FcmTokenService {
  final ApiClient _apiClient;
  final PushNotificationService _pushService;

  StreamSubscription<String?>? _tokenSubscription;
  String? _registeredToken;

  FcmTokenService({
    required ApiClient apiClient,
    required PushNotificationService pushService,
  })  : _apiClient = apiClient,
        _pushService = pushService;

  /// Инициализация — подписка на изменения токена
  void initialize() {
    _tokenSubscription = _pushService.onTokenRefresh.listen(_onTokenChanged);

    // Регистрируем текущий токен если есть
    final currentToken = _pushService.token;
    if (currentToken != null && currentToken != _registeredToken) {
      registerToken(currentToken);
    }
  }

  /// Обработка изменения токена
  Future<void> _onTokenChanged(String? newToken) async {
    if (newToken == null) {
      // Токен удалён — отменяем регистрацию
      if (_registeredToken != null) {
        await unregisterToken(_registeredToken!);
        _registeredToken = null;
      }
    } else if (newToken != _registeredToken) {
      // Новый токен — регистрируем
      await registerToken(newToken);
    }
  }

  /// Зарегистрировать токен на сервере
  Future<bool> registerToken(String token) async {
    try {
      final httpClient = _apiClient.getHttpClient();
      final authToken = await _apiClient.getAuthToken();

      if (authToken == null) {
        debugPrint('FcmTokenService: Нет auth токена для регистрации');
        return false;
      }

      final response = await httpClient.post(
        Uri.parse('${_apiClient.baseUrl}/api/push/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'token': token,
          'platform': _getPlatform(),
          'deviceInfo': _getDeviceInfo(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _registeredToken = token;
        debugPrint('FcmTokenService: Токен зарегистрирован');
        return true;
      } else {
        debugPrint('FcmTokenService: Ошибка регистрации: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('FcmTokenService: Ошибка регистрации токена: $e');
      return false;
    }
  }

  /// Отменить регистрацию токена
  /// Backend: POST /api/push/unregister (НЕ DELETE!)
  Future<bool> unregisterToken(String token) async {
    try {
      final httpClient = _apiClient.getHttpClient();
      final authToken = await _apiClient.getAuthToken();

      if (authToken == null) {
        debugPrint('FcmTokenService: Нет auth токена для отмены регистрации');
        return false;
      }

      // ВАЖНО: Backend использует POST, не DELETE
      final response = await httpClient.post(
        Uri.parse('${_apiClient.baseUrl}/api/push/unregister'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _registeredToken = null;
        debugPrint('FcmTokenService: Токен удалён с сервера');
        return true;
      } else {
        debugPrint('FcmTokenService: Ошибка удаления токена: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('FcmTokenService: Ошибка удаления токена: $e');
      return false;
    }
  }

  /// Получить платформу
  String _getPlatform() {
    if (kIsWeb) return 'web';
    // Для мобильных платформ можно использовать Platform.isAndroid/isIOS
    return 'unknown';
  }

  /// Получить информацию об устройстве
  String _getDeviceInfo() {
    if (kIsWeb) {
      return 'Web Browser';
    }
    return 'Unknown Device';
  }

  /// Принудительно обновить регистрацию токена
  Future<bool> refreshRegistration() async {
    final token = await _pushService.getToken();
    if (token != null) {
      return registerToken(token);
    }
    return false;
  }

  /// Освободить ресурсы
  void dispose() {
    _tokenSubscription?.cancel();
  }
}
