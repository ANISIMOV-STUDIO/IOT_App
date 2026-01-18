/// Сервис повторных попыток с exponential backoff
///
/// Реализует best practice Auth0/Google для retry логики:
/// - Exponential backoff: 1s, 2s, 4s
/// - Максимум 3 попытки
/// - Не повторять 401/403 (аутентификация)
library;

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:hvac_control/core/error/session_expired_exception.dart';
import 'package:hvac_control/core/logging/api_logger.dart';

/// Сервис для выполнения операций с повторными попытками
class RetryService {
  const RetryService._();

  /// Базовая задержка в миллисекундах (1 секунда)
  static const int _baseDelayMs = 1000;

  /// Максимальное количество попыток
  static const int _maxRetries = 3;

  /// HTTP коды, которые не должны повторяться
  static const List<int> _nonRetryableHttpCodes = [
    400, // Bad Request
    401, // Unauthorized
    403, // Forbidden
    404, // Not Found
    422, // Unprocessable Entity
  ];

  /// Выполнить операцию с повторными попытками
  ///
  /// [operation] - асинхронная операция для выполнения
  /// [maxRetries] - максимальное количество попыток (по умолчанию 3)
  /// [shouldRetry] - функция для определения, нужно ли повторять при ошибке
  /// [onRetry] - callback при каждой повторной попытке
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    int maxRetries = _maxRetries,
    bool Function(Object error)? shouldRetry,
    void Function(int attempt, Object error, Duration nextDelay)? onRetry,
  }) async {
    var attempt = 0;
    Object? lastError;

    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        lastError = e;
        attempt++;

        // Проверяем, можно ли повторить
        final canRetry = shouldRetry?.call(e) ?? _defaultShouldRetry(e);

        if (!canRetry || attempt >= maxRetries) {
          ApiLogger.error('[Retry] Giving up after $attempt attempts: $e');
          rethrow;
        }

        // Вычисляем задержку с exponential backoff
        final delay = _calculateDelay(attempt);

        ApiLogger.debug('[Retry] Attempt $attempt failed, retrying in ${delay.inMilliseconds}ms: $e');
        onRetry?.call(attempt, e, delay);

        await Future<void>.delayed(delay);
      }
    }

    // Не должно сюда дойти, но на всякий случай
    if (lastError is Exception) {
      throw lastError;
    }
    if (lastError is Error) {
      throw lastError;
    }
    throw Exception('Retry failed: $lastError');
  }

  /// Вычислить задержку с exponential backoff и jitter
  ///
  /// Формула: baseDelay * 2^(attempt-1) + random jitter
  /// Attempt 1: 1s + jitter
  /// Attempt 2: 2s + jitter
  /// Attempt 3: 4s + jitter
  static Duration _calculateDelay(int attempt) {
    // Exponential: 1s, 2s, 4s
    final exponentialMs = _baseDelayMs * pow(2, attempt - 1).toInt();

    // Добавляем jitter (0-500ms) для избежания thundering herd
    final jitter = Random().nextInt(500);

    return Duration(milliseconds: exponentialMs + jitter);
  }

  /// Стандартная логика определения, нужно ли повторять
  static bool _defaultShouldRetry(Object error) {
    // Не повторять SessionExpiredException
    if (error is SessionExpiredException) {
      return false;
    }

    // Сетевые ошибки - повторять
    if (error is SocketException ||
        error is TimeoutException ||
        error is HttpException) {
      return true;
    }

    // HTTP ошибки - проверить код
    if (error is HttpStatusException) {
      return !_nonRetryableHttpCodes.contains(error.statusCode);
    }

    // По умолчанию - не повторять неизвестные ошибки
    return false;
  }

  /// Проверить, является ли HTTP код повторяемым
  static bool isRetryableHttpCode(int statusCode) =>
      !_nonRetryableHttpCodes.contains(statusCode) && statusCode >= 500;

  /// Получить задержки для всех попыток (для тестирования/отладки)
  static List<Duration> getRetryDelays({int maxRetries = _maxRetries}) => List.generate(
      maxRetries - 1,
      (index) => Duration(milliseconds: _baseDelayMs * pow(2, index).toInt()),
    );
}

/// Исключение HTTP с кодом статуса
class HttpStatusException implements Exception {
  const HttpStatusException(this.statusCode, [this.message]);

  final int statusCode;
  final String? message;

  @override
  String toString() => 'HttpStatusException: $statusCode ${message ?? ''}';
}

/// Extension для удобного использования retry
extension RetryExtension<T> on Future<T> {
  /// Выполнить Future с повторными попытками
  Future<T> withRetry({
    int maxRetries = 3,
    bool Function(Object error)? shouldRetry,
    void Function(int attempt, Object error, Duration nextDelay)? onRetry,
  }) => RetryService.execute(
      operation: () => this,
      maxRetries: maxRetries,
      shouldRetry: shouldRetry,
      onRetry: onRetry,
    );
}
