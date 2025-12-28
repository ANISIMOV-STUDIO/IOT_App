/// HTTP client for Occupant service (Web platform)
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../../../core/error/http_error_handler.dart';
import '../../../../core/logging/api_logger.dart';
import '../../platform/api_client.dart';

class OccupantHttpClient {
  final ApiClient _apiClient;

  OccupantHttpClient(this._apiClient);

  /// Get all occupants
  Future<List<Map<String, dynamic>>> getAllOccupants() async {
    final url = ApiConfig.occupantApiUrl;

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
        } else if (data is Map && data.containsKey('occupants')) {
          return (data['occupants'] as List).cast<Map<String, dynamic>>();
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

  /// Add occupant
  Future<Map<String, dynamic>> addOccupant(
      Map<String, dynamic> occupant) async {
    final url = ApiConfig.occupantApiUrl;
    final body = json.encode(occupant);

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

  /// Update presence
  Future<Map<String, dynamic>> updatePresence(
      String occupantId, bool isHome, String? currentRoom) async {
    final url = '${ApiConfig.occupantApiUrl}/$occupantId/presence';
    final body = json.encode({
      'isHome': isHome,
      if (currentRoom != null) 'currentRoom': currentRoom,
    });

    try {
      ApiLogger.logHttpRequest('PUT', url, body);

      final token = await _apiClient.getAuthToken();
      final response = await _apiClient.getHttpClient().put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: body,
          );

      ApiLogger.logHttpResponse('PUT', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError('PUT', url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Remove occupant
  Future<void> removeOccupant(String occupantId) async {
    final url = '${ApiConfig.occupantApiUrl}/$occupantId';

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
}
