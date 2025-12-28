/// HTTP Retry Helper - утилита для повторных попыток HTTP запросов
///
/// Использует exponential backoff стратегию для retry логики
library;

import 'dart:async';
import '../../../core/logging/api_logger.dart';
import '../../../core/error/api_exception.dart';

class HttpRetryHelper {
  /// Выполнить HTTP операцию с автоматическими повторными попытками
  ///
  /// [operation] - функция для выполнения
  /// [maxRetries] - максимальное количество попыток (по умолчанию 3)
  /// [initialDelay] - начальная задержка перед первым retry (по умолчанию 1 сек)
  /// [maxDelay] - максимальная задержка между попытками (по умолчанию 10 сек)
  /// [retryableErrors] - типы ошибок, при которых делать retry
  ///
  /// Возвращает результат операции или выбрасывает исключение
  static Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 10),
    Set<ApiErrorType> retryableErrors = const {
      ApiErrorType.network,
      ApiErrorType.timeout,
      ApiErrorType.serverError,
    },
  }) async {
    int attempt = 0;
    Duration currentDelay = initialDelay;

    while (true) {
      try {
        return await operation();
      } catch (error) {
        attempt++;

        // Проверить, нужно ли делать retry
        final shouldRetry = _shouldRetry(
          error,
          attempt,
          maxRetries,
          retryableErrors,
        );

        if (!shouldRetry) {
          rethrow; // Выбросить исключение, если retry не нужен
        }

        // Логировать попытку retry
        ApiLogger.logHttpError(
          'RETRY',
          'Attempt $attempt/$maxRetries',
          'Error: $error, waiting ${currentDelay.inSeconds}s...',
        );

        // Подождать перед следующей попыткой
        await Future.delayed(currentDelay);

        // Exponential backoff: увеличить задержку в 2 раза
        currentDelay = Duration(
          milliseconds: (currentDelay.inMilliseconds * 2).clamp(
            initialDelay.inMilliseconds,
            maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }

  /// Проверить, нужно ли делать retry для данной ошибки
  static bool _shouldRetry(
    dynamic error,
    int attempt,
    int maxRetries,
    Set<ApiErrorType> retryableErrors,
  ) {
    // Превышено максимальное количество попыток
    if (attempt >= maxRetries) {
      return false;
    }

    // Проверить тип ошибки
    if (error is ApiException) {
      return retryableErrors.contains(error.type);
    }

    // Для неизвестных ошибок - делать retry только для network/timeout
    if (error is TimeoutException) {
      return retryableErrors.contains(ApiErrorType.timeout);
    }

    // Для других типов ошибок (SocketException, etc.) - считать network error
    return retryableErrors.contains(ApiErrorType.network);
  }

  /// Создать retry wrapper для HTTP метода
  ///
  /// Пример использования:
  /// ```dart
  /// final retryableGet = HttpRetryHelper.createRetryWrapper<Map<String, dynamic>>(
  ///   () => apiClient.get('/endpoint'),
  /// );
  /// final result = await retryableGet();
  /// ```
  static Future<T> Function() createRetryWrapper<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
  }) {
    return () => withRetry(
          operation,
          maxRetries: maxRetries,
        );
  }
}
