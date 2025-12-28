/// gRPC error handler
library;

import 'package:grpc/grpc.dart';
import 'api_exception.dart';

class GrpcErrorHandler {
  static ApiException handle(GrpcError error) {
    switch (error.code) {
      case StatusCode.unavailable:
      case StatusCode.unknown:
        return ApiException(
          type: ApiErrorType.network,
          message: 'Не удается подключиться к серверу',
          statusCode: error.code,
          originalError: error,
        );

      case StatusCode.deadlineExceeded:
        return ApiException(
          type: ApiErrorType.timeout,
          message: 'Превышено время ожидания запроса',
          statusCode: error.code,
          originalError: error,
        );

      case StatusCode.unauthenticated:
        return ApiException(
          type: ApiErrorType.authentication,
          message: 'Требуется авторизация',
          statusCode: error.code,
          originalError: error,
        );

      case StatusCode.permissionDenied:
        return ApiException(
          type: ApiErrorType.authorization,
          message: 'Недостаточно прав доступа',
          statusCode: error.code,
          originalError: error,
        );

      case StatusCode.notFound:
        return ApiException(
          type: ApiErrorType.notFound,
          message: 'Ресурс не найден',
          statusCode: error.code,
          originalError: error,
        );

      case StatusCode.invalidArgument:
        return ApiException(
          type: ApiErrorType.validation,
          message: error.message ?? 'Неверные параметры запроса',
          statusCode: error.code,
          originalError: error,
        );

      default:
        return ApiException(
          type: ApiErrorType.serverError,
          message: error.message ?? 'Ошибка сервера',
          statusCode: error.code,
          originalError: error,
        );
    }
  }
}
