/// HTTP client for Analytics service (Web platform)
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/error/http_error_handler.dart';
import '../../../../core/logging/api_logger.dart';
import '../../platform/api_client.dart';
import '../../../../domain/entities/sensor_history.dart';
import '../../mappers/device_json_mapper.dart';

class AnalyticsHttpClient {
  final ApiClient _apiClient;

  AnalyticsHttpClient(this._apiClient);

  /// Get energy stats for device
  Future<Map<String, dynamic>> getEnergyStats(String deviceId) async {
    final url = '${ApiConfig.analyticsApiUrl}/energy/$deviceId/stats';

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

  /// Get energy history
  Future<Map<String, dynamic>> getEnergyHistory(
    String deviceId,
    DateTime from,
    DateTime to,
    String period,
  ) async {
    final queryParams = {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'period': period,
    };
    final url = Uri.parse('${ApiConfig.analyticsApiUrl}/energy/$deviceId/history')
        .replace(queryParameters: queryParams)
        .toString();

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

  /// Получить историю датчиков устройства
  /// Возвращает List<SensorHistory> - domain entities
  Future<List<SensorHistory>> getSensorHistory(
    String deviceId, {
    DateTime? from,
    DateTime? to,
    int limit = 1000,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
    };
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final url = Uri.parse('${ApiConfig.deviceApiUrl}/$deviceId/history')
        .replace(queryParameters: queryParams)
        .toString();

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
          return DeviceJsonMapper.sensorHistoryListFromJson(data);
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

  /// Get graph data from device history
  /// Использует /api/device/{id}/history и преобразует в формат графика
  Future<Map<String, dynamic>> getGraphData(
    String deviceId,
    String metric,
    DateTime from,
    DateTime to,
  ) async {
    final queryParams = {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'limit': '1000',
    };
    final url = Uri.parse('${ApiConfig.deviceApiUrl}/$deviceId/history')
        .replace(queryParameters: queryParams)
        .toString();

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
          // Используем маппер для преобразования JSON → SensorHistory entities
          final history = DeviceJsonMapper.sensorHistoryListFromJson(data);

          // Преобразуем entities в формат dataPoints для графика
          final dataPoints = <Map<String, dynamic>>[];
          for (final item in history) {
            final value = item.getValueByMetric(metric);
            if (value != null) {
              dataPoints.add({
                'label': item.timestamp.toIso8601String(),
                'value': value,
              });
            }
          }
          return {'dataPoints': dataPoints};
        }
        return {'dataPoints': []};
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
}
