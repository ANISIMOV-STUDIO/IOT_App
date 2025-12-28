/// HTTP error handler
library;

import 'package:http/http.dart' as http;
import 'api_exception.dart';

class HttpErrorHandler {
  static ApiException handle(http.Response response) {
    switch (response.statusCode) {
      case 401:
        return ApiException(
          type: ApiErrorType.authentication,
          message: 'Требуется авторизация',
          statusCode: response.statusCode,
        );

      case 403:
        return ApiException(
          type: ApiErrorType.authorization,
          message: 'Недостаточно прав доступа',
          statusCode: response.statusCode,
        );

      case 404:
        return ApiException(
          type: ApiErrorType.notFound,
          message: 'Ресурс не найден',
          statusCode: response.statusCode,
        );

      case 400:
        return ApiException(
          type: ApiErrorType.validation,
          message: 'Неверные параметры запроса',
          statusCode: response.statusCode,
        );

      case 408:
        return ApiException(
          type: ApiErrorType.timeout,
          message: 'Превышено время ожидания',
          statusCode: response.statusCode,
        );

      case >= 500:
        return ApiException(
          type: ApiErrorType.serverError,
          message: 'Ошибка сервера',
          statusCode: response.statusCode,
        );

      default:
        return ApiException(
          type: ApiErrorType.unknown,
          message: 'Неизвестная ошибка',
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
