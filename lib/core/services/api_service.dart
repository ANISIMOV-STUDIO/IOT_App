/// API Service
///
/// Handles all HTTP requests to the backend
library;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrlKey = 'api_base_url';
  static const String _tokenKey = 'auth_token';
  static const String _defaultBaseUrl = 'http://localhost:8080/api';

  final SharedPreferences _prefs;
  String? _authToken;
  late String _baseUrl;

  ApiService(this._prefs) {
    _baseUrl = _prefs.getString(_baseUrlKey) ?? _defaultBaseUrl;
    _authToken = _prefs.getString(_tokenKey);
  }

  // Getters
  String get baseUrl => _baseUrl;
  bool get isAuthenticated => _authToken != null;
  String? get authToken => _authToken;

  // Update base URL
  Future<void> updateBaseUrl(String url) async {
    _baseUrl = url;
    await _prefs.setString(_baseUrlKey, url);
  }

  // Save auth token
  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    await _prefs.setString(_tokenKey, token);
  }

  // Clear auth token (logout)
  Future<void> clearAuthToken() async {
    _authToken = null;
    await _prefs.remove(_tokenKey);
  }

  // Generic HTTP request method
  Future<http.Response> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
  }) async {
    try {
      // Build URI
      Uri uri = Uri.parse('$_baseUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      // Build headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

      // Make request
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      // Log in debug mode
      if (kDebugMode) {
        debugPrint('API $method $endpoint: ${response.statusCode}');
      }

      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Convenience methods
  Future<http.Response> get(String endpoint,
      {Map<String, String>? queryParams}) {
    return _request('GET', endpoint, queryParams: queryParams);
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) {
    return _request('POST', endpoint, body: body);
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) {
    return _request('PUT', endpoint, body: body);
  }

  Future<http.Response> delete(String endpoint) {
    return _request('DELETE', endpoint);
  }

  Future<http.Response> patch(String endpoint, {Map<String, dynamic>? body}) {
    return _request('PATCH', endpoint, body: body);
  }

  // ===== AUTH ENDPOINTS =====

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await post('/auth/register', body: {
      'email': email,
      'password': password,
      'name': name,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['token'] != null) {
        await saveAuthToken(data['token']);
      }
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['token'] != null) {
        await saveAuthToken(data['token']);
      }
      return data;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await post('/auth/logout');
    } finally {
      await clearAuthToken();
    }
  }

  /// Get current user profile
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await get('/auth/me');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  // ===== DEVICE ENDPOINTS =====

  /// Get all devices for current user
  Future<List<Map<String, dynamic>>> getDevices() async {
    final response = await get('/devices');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get devices');
    }
  }

  /// Add device by MAC address
  Future<Map<String, dynamic>> addDevice({
    required String macAddress,
    required String name,
    String? location,
  }) async {
    final response = await post('/devices', body: {
      'macAddress': macAddress,
      'name': name,
      'location': location,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to add device');
    }
  }

  /// Add device by QR code data
  Future<Map<String, dynamic>> addDeviceByQR({
    required String qrData,
    required String name,
    String? location,
  }) async {
    final response = await post('/devices/qr', body: {
      'qrData': qrData,
      'name': name,
      'location': location,
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to add device from QR');
    }
  }

  /// Update device
  Future<Map<String, dynamic>> updateDevice({
    required String deviceId,
    Map<String, dynamic>? updates,
  }) async {
    final response = await patch('/devices/$deviceId', body: updates);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update device');
    }
  }

  /// Delete device
  Future<void> deleteDevice(String deviceId) async {
    final response = await delete('/devices/$deviceId');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete device');
    }
  }

  /// Get device state
  Future<Map<String, dynamic>> getDeviceState(String deviceId) async {
    final response = await get('/devices/$deviceId/state');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get device state');
    }
  }

  /// Update device state (control commands)
  Future<Map<String, dynamic>> updateDeviceState({
    required String deviceId,
    bool? power,
    double? targetTemp,
    String? mode,
    String? fanSpeed,
  }) async {
    final body = <String, dynamic>{};
    if (power != null) body['power'] = power;
    if (targetTemp != null) body['targetTemp'] = targetTemp;
    if (mode != null) body['mode'] = mode;
    if (fanSpeed != null) body['fanSpeed'] = fanSpeed;

    final response = await put('/devices/$deviceId/state', body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update device state');
    }
  }

  /// Get temperature history
  Future<List<Map<String, dynamic>>> getTemperatureHistory(
    String deviceId, {
    int hours = 24,
  }) async {
    final response = await get(
      '/devices/$deviceId/history',
      queryParams: {'hours': hours.toString()},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get temperature history');
    }
  }
}
