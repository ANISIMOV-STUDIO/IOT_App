/// Base HTTP Client - общая логика для всех HTTP клиентов (DRY)
///
/// Инкапсулирует:
/// - Формирование headers с авторизацией
/// - Логирование запросов/ответов
/// - Обработку ошибок
/// - Парсинг JSON
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/error/http_error_handler.dart';
import '../../../core/logging/api_logger.dart';
import '../platform/api_client.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// HTTP статус коды
abstract class HttpStatus {
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;
}

// =============================================================================
// BASE CLIENT
// =============================================================================

/// Базовый HTTP клиент с общей логикой
///
/// Использование:
/// ```dart
/// class MyClient extends BaseHttpClient {
///   MyClient(super.apiClient);
///
///   Future<Data> getData() => get('/endpoint', (json) => Data.fromJson(json));
/// }
/// ```
abstract class BaseHttpClient {
  final ApiClient _apiClient;

  BaseHttpClient(this._apiClient);

  /// Получить HTTP клиент
  http.Client get httpClient => _apiClient.getHttpClient();

  /// Получить токен авторизации
  Future<String?> getAuthToken() => _apiClient.getAuthToken();

  // ===========================================================================
  // HTTP METHODS
  // ===========================================================================

  /// GET запрос с парсингом ответа
  Future<T> get<T>(
    String url,
    T Function(dynamic json) parser,
  ) async {
    return _executeRequest(
      method: 'GET',
      url: url,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.get(Uri.parse(url), headers: headers);
      },
      parser: parser,
    );
  }

  /// GET запрос возвращающий список
  Future<List<T>> getList<T>(
    String url,
    T Function(Map<String, dynamic> json) itemParser, {
    String? listKey,
  }) async {
    return _executeRequest(
      method: 'GET',
      url: url,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.get(Uri.parse(url), headers: headers);
      },
      parser: (json) {
        List<dynamic> items;
        if (json is List) {
          items = json;
        } else if (listKey != null && json is Map && json[listKey] is List) {
          items = json[listKey] as List;
        } else {
          return <T>[];
        }
        return items
            .whereType<Map<String, dynamic>>()
            .map(itemParser)
            .toList();
      },
    );
  }

  /// GET запрос возвращающий raw Map
  Future<Map<String, dynamic>> getRaw(String url) async {
    return get(url, (json) => json as Map<String, dynamic>);
  }

  /// POST запрос с телом и парсингом ответа
  Future<T> post<T>(
    String url,
    Map<String, dynamic> body,
    T Function(dynamic json) parser,
  ) async {
    final encodedBody = json.encode(body);
    return _executeRequest(
      method: 'POST',
      url: url,
      body: encodedBody,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.post(
          Uri.parse(url),
          headers: headers,
          body: encodedBody,
        );
      },
      parser: parser,
    );
  }

  /// POST запрос без возвращаемого значения
  Future<void> postVoid(String url, [Map<String, dynamic>? body]) async {
    final encodedBody = body != null ? json.encode(body) : null;
    await _executeVoidRequest(
      method: 'POST',
      url: url,
      body: encodedBody,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.post(
          Uri.parse(url),
          headers: headers,
          body: encodedBody,
        );
      },
    );
  }

  /// PATCH запрос с телом и парсингом ответа
  Future<T> patch<T>(
    String url,
    Map<String, dynamic> body,
    T Function(dynamic json) parser,
  ) async {
    final encodedBody = json.encode(body);
    return _executeRequest(
      method: 'PATCH',
      url: url,
      body: encodedBody,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.patch(
          Uri.parse(url),
          headers: headers,
          body: encodedBody,
        );
      },
      parser: parser,
    );
  }

  /// PATCH запрос без возвращаемого значения
  Future<void> patchVoid(String url, Map<String, dynamic> body) async {
    final encodedBody = json.encode(body);
    await _executeVoidRequest(
      method: 'PATCH',
      url: url,
      body: encodedBody,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.patch(
          Uri.parse(url),
          headers: headers,
          body: encodedBody,
        );
      },
    );
  }

  /// DELETE запрос
  Future<void> delete(String url) async {
    await _executeVoidRequest(
      method: 'DELETE',
      url: url,
      execute: () async {
        final headers = await _buildHeaders();
        return httpClient.delete(Uri.parse(url), headers: headers);
      },
    );
  }

  // ===========================================================================
  // PRIVATE METHODS
  // ===========================================================================

  /// Формирование headers с авторизацией
  Future<Map<String, String>> _buildHeaders() async {
    final token = await getAuthToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Выполнение запроса с парсингом ответа
  Future<T> _executeRequest<T>({
    required String method,
    required String url,
    String? body,
    required Future<http.Response> Function() execute,
    required T Function(dynamic json) parser,
  }) async {
    try {
      ApiLogger.logHttpRequest(method, url, body);

      final response = await execute();

      ApiLogger.logHttpResponse(method, url, response.statusCode, response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final decoded = json.decode(response.body);
        return parser(decoded);
      } else {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError(method, url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }

  /// Выполнение запроса без возвращаемого значения
  Future<void> _executeVoidRequest({
    required String method,
    required String url,
    String? body,
    required Future<http.Response> Function() execute,
  }) async {
    try {
      ApiLogger.logHttpRequest(method, url, body);

      final response = await execute();

      ApiLogger.logHttpResponse(method, url, response.statusCode, response.body);

      if (response.statusCode != HttpStatus.ok &&
          response.statusCode != HttpStatus.created &&
          response.statusCode != HttpStatus.noContent) {
        throw HttpErrorHandler.handle(response);
      }
    } catch (e) {
      ApiLogger.logHttpError(method, url, e);
      if (e is http.ClientException) {
        throw HttpErrorHandler.handleException(e);
      }
      rethrow;
    }
  }
}
