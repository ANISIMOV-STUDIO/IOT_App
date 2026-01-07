/// HTTP client for HVAC service (Web platform)
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/error/http_error_handler.dart';
import '../../../../core/logging/api_logger.dart';
import '../../platform/api_client.dart';

class HvacHttpClient {
  final ApiClient _apiClient;

  HvacHttpClient(this._apiClient);

  /// Получить все устройства
  /// GET /api/device
  Future<List<Map<String, dynamic>>> listDevices() async {
    final url = ApiConfig.hvacApiUrl;

    try {
      ApiLogger.logHttpRequest('GET', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Backend может вернуть массив или объект с массивом devices
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data.containsKey('devices')) {
          return (data['devices'] as List).cast<Map<String, dynamic>>();
        }
        return [];
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('GET', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Get device by ID
  Future<Map<String, dynamic>> getDevice(String deviceId) async {
    if (deviceId.isEmpty) {
      throw ArgumentError('deviceId cannot be empty');
    }
    final url = '${ApiConfig.hvacApiUrl}/$deviceId';

    try {
      ApiLogger.logHttpRequest('GET', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('GET', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Set power
  Future<Map<String, dynamic>> setPower(String deviceId, bool power) async {
    if (deviceId.isEmpty) {
      throw ArgumentError('deviceId cannot be empty');
    }
    final url = '${ApiConfig.hvacApiUrl}/$deviceId/power';
    final body = json.encode({'power': power});

    try {
      ApiLogger.logHttpRequest('POST', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('POST', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }


  /// Обновить настройки устройства (температура, вентиляторы) через PATCH
  /// PATCH /api/device/{id}
  Future<Map<String, dynamic>> updateDevice(
    String deviceId, {
    int? heatingTemperature,
    int? coolingTemperature,
    int? supplyFan,
    int? exhaustFan,
  }) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId';
    final bodyMap = <String, dynamic>{};
    if (heatingTemperature != null) {
      bodyMap['heatingTemperature'] = heatingTemperature;
    }
    if (coolingTemperature != null) {
      bodyMap['coolingTemperature'] = coolingTemperature;
    }
    if (supplyFan != null) bodyMap['supplyFan'] = supplyFan;
    if (exhaustFan != null) bodyMap['exhaustFan'] = exhaustFan;

    final body = json.encode(bodyMap);

    try {
      ApiLogger.logHttpRequest('PATCH', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PATCH', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PATCH', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Set heating temperature via PATCH
  Future<Map<String, dynamic>> setTemperature(
      String deviceId, int temperature) async {
    return updateDevice(deviceId, heatingTemperature: temperature);
  }
  /// Set mode
  Future<Map<String, dynamic>> setMode(String deviceId, String mode) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId/mode';
    final body = json.encode({'mode': mode});

    try {
      ApiLogger.logHttpRequest('POST', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('POST', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }


  /// Set fan speed via PATCH
  Future<Map<String, dynamic>> setFanSpeed(
    String deviceId,
    int supplyFan,
    int exhaustFan,
  ) async {
    return updateDevice(deviceId, supplyFan: supplyFan, exhaustFan: exhaustFan);
  }
  /// Получить историю аварий устройства
  /// GET /api/device/{id}/alarms?limit=100
  Future<List<Map<String, dynamic>>> getAlarmHistory(
    String deviceId, {
    int limit = 100,
  }) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId/alarms?limit=$limit';

    try {
      ApiLogger.logHttpRequest('GET', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('GET', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
        return [];
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('GET', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Зарегистрировать новое устройство по MAC-адресу
  /// POST /api/device/register
  Future<Map<String, dynamic>> registerDevice(
    String macAddress,
    String name,
  ) async {
    final url = '${ApiConfig.hvacApiUrl}/register';
    final body = json.encode({
      'macAddress': macAddress,
      'name': name,
    });

    try {
      ApiLogger.logHttpRequest('POST', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('POST', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Удалить устройство
  /// DELETE /api/device/{id}
  Future<void> deleteDevice(String deviceId) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId';

    try {
      ApiLogger.logHttpRequest('DELETE', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().delete(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('DELETE', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('DELETE', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Переименовать устройство
  /// PATCH /api/device/{id}
  Future<void> renameDevice(String deviceId, String newName) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId';
    final body = json.encode({'name': newName});

    try {
      ApiLogger.logHttpRequest('PATCH', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().patch(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PATCH', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PATCH', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Сбросить аварию устройства
  /// POST /api/device/{id}/alarm-reset
  Future<void> resetAlarm(String deviceId) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId/alarm-reset';

    try {
      ApiLogger.logHttpRequest('POST', url, null);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );

      ApiLogger.logHttpResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('POST', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Установить настройки режима
  /// POST /api/device/{id}/mode-settings
  ///
  /// Backend SetModeSettingsRequest:
  /// - modeName: string (basic, intensive, economy, max_performance, etc.)
  /// - supplyFan: int (20-100%)
  /// - exhaustFan: int (20-100%)
  /// - heatingTemperature: int (15-35°C)
  /// - coolingTemperature: int (15-35°C)
  Future<void> setModeSettings(
    String deviceId, {
    required String modeName,
    required int supplyFan,
    required int exhaustFan,
    required int heatingTemperature,
    required int coolingTemperature,
  }) async {
    final url = '${ApiConfig.hvacApiUrl}/$deviceId/mode-settings';
    final body = json.encode({
      'modeName': modeName,
      'supplyFan': supplyFan,
      'exhaustFan': exhaustFan,
      'heatingTemperature': heatingTemperature,
      'coolingTemperature': coolingTemperature,
    });

    try {
      ApiLogger.logHttpRequest('POST', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('POST', url, response.statusCode, response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('POST', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }
}
