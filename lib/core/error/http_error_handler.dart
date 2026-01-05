/// HTTP error handler
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';
import '../logging/api_logger.dart';

class HttpErrorHandler {
  /// Извлечь сообщение об ошибке из тела ответа
  static String? _extractMessage(http.Response response) {
    try {
      if (response.body.isNotEmpty) {
        final json = jsonDecode(response.body);
        if (json is Map) {
          return json['message'] as String? ?? json['error'] as String?;
        }
      }
    } catch (e) {
      ApiLogger.debug('[HttpErrorHandler] Не удалось распарсить JSON ошибки', e);
    }
    return null;
  }

  static ApiException handle(http.Response response) {
    final serverMessage = _extractMessage(response);

    switch (response.statusCode) {
      case 401:
        return ApiException(
          type: ApiErrorType.authentication,
          message: serverMessage ?? 'Требуется авторизация',
          statusCode: response.statusCode,
        );

      case 403:
        return ApiException(
          type: ApiErrorType.authorization,
          message: serverMessage ?? 'Недостаточно прав доступа',
          statusCode: response.statusCode,
        );

      case 404:
        return ApiException(
          type: ApiErrorType.notFound,
          message: serverMessage ?? 'Ресурс не найден',
          statusCode: response.statusCode,
        );

      case 400:
        return ApiException(
          type: ApiErrorType.validation,
          message: serverMessage ?? 'Неверные параметры запроса',
          statusCode: response.statusCode,
        );

      case 408:
        return ApiException(
          type: ApiErrorType.timeout,
          message: serverMessage ?? 'Превышено время ожидания',
          statusCode: response.statusCode,
        );

      case 409:
        return ApiException(
          type: ApiErrorType.conflict,
          message: serverMessage ?? 'Ресурс уже существует',
          statusCode: response.statusCode,
        );

      case >= 500:
        return ApiException(
          type: ApiErrorType.serverError,
          message: serverMessage ?? 'Ошибка сервера',
          statusCode: response.statusCode,
        );

      default:
        return ApiException(
          type: ApiErrorType.unknown,
          message: serverMessage ?? 'Неизвестная ошибка',
          statusCode: response.statusCode,
        );
    }
  }

  static ApiException handleException(Object error) {
    return ApiException(
      type: ApiErrorType.network,
      message: 'Ошибка подключения к серверу',
      originalError: error,
    );
  }
}
