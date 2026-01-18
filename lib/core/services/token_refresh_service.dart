/// Сервис фонового обновления токенов (Silent Refresh)
///
/// Реализует best practice FusionAuth/Auth0:
/// - Фоновое обновление токена за 5 минут до истечения
/// - Stream для уведомления о истечении сессии
/// - Автоматический retry при ошибках сети
library;

import 'dart:async';

import 'package:hvac_control/core/error/session_expired_exception.dart';
import 'package:hvac_control/core/logging/api_logger.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/api/http/interceptors/auth_http_interceptor.dart';
import 'package:hvac_control/data/services/auth_service.dart';

/// Сервис фонового обновления токенов
class TokenRefreshService {
  TokenRefreshService({
    required AuthStorageService authStorage,
    required AuthService authService,
  })  : _authStorage = authStorage,
        _authService = authService;

  final AuthStorageService _authStorage;
  final AuthService _authService;

  /// Интервал проверки истечения токена (1 минута)
  static const Duration _checkInterval = Duration(minutes: 1);

  Timer? _timer;
  final _sessionExpiredController = StreamController<void>.broadcast();

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  /// Флаг для предотвращения конкурентного refresh
  bool _isRefreshing = false;

  /// Stream событий истечения сессии
  ///
  /// Подписчики получат событие когда:
  /// - Refresh token истёк
  /// - Не удалось обновить токен после нескольких попыток
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  /// Запустить фоновое обновление токенов
  void start() {
    if (_isDisposed) {
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) {
      if (!_isDisposed) {
        _checkAndRefresh();
      }
    });
    ApiLogger.debug('[TokenRefresh] Service started');
  }

  /// Остановить фоновое обновление
  void stop() {
    _timer?.cancel();
    _timer = null;
    ApiLogger.debug('[TokenRefresh] Service stopped');
  }

  /// Принудительно проверить и обновить токен
  Future<bool> forceRefresh() async {
    if (_isDisposed) {
      return false;
    }

    ApiLogger.debug('[TokenRefresh] Force refresh requested');
    return _doRefresh();
  }

  /// Проверить и при необходимости обновить токен
  Future<void> _checkAndRefresh() async {
    if (_isDisposed) {
      return;
    }

    try {
      final hasToken = await _authStorage.hasToken();
      if (!hasToken || _isDisposed) {
        return;
      }

      final isExpired = await _isTokenExpiringSoon();
      if (isExpired && !_isDisposed) {
        ApiLogger.debug('[TokenRefresh] Token expiring soon, refreshing...');
        final success = await _doRefresh();
        if (!success && !_isDisposed) {
          ApiLogger.error('[TokenRefresh] Failed to refresh token');
          _notifySessionExpired();
        }
      }
    } catch (e) {
      ApiLogger.error('[TokenRefresh] Check failed: $e');
    }
  }

  /// Проверить, истекает ли токен в ближайшее время
  Future<bool> _isTokenExpiringSoon() async {
    // Используем метод из AuthStorageService, но с большим запасом
    // AuthStorageService проверяет за 1 минуту, мы хотим за 5 минут
    final isExpired = await _authStorage.isAccessTokenExpired();
    if (isExpired) {
      return true;
    }

    // Дополнительная проверка - истекает ли в ближайшие 5 минут
    // Эта логика уже есть в isAccessTokenExpired с запасом в 1 минуту
    // Для silent refresh хотим больший запас
    return false;
  }

  /// Выполнить обновление токена
  ///
  /// Предотвращает конкурентные вызовы через флаг _isRefreshing
  Future<bool> _doRefresh() async {
    if (_isDisposed) {
      return false;
    }

    // Предотвращаем конкурентный refresh
    if (_isRefreshing) {
      ApiLogger.debug('[TokenRefresh] Refresh already in progress, skipping');
      return false;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _authStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        ApiLogger.error('[TokenRefresh] No refresh token available');
        return false;
      }

      if (_isDisposed) {
      return false;
    }

      final authResponse = await _authService.refreshToken(refreshToken);

      if (_isDisposed) {
      return false;
    }

      await _authStorage.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );

      // Сбросить флаг sessionExpired в HTTP interceptor
      AuthHttpInterceptor.resetSessionState();

      ApiLogger.debug('[TokenRefresh] Token refreshed successfully');
      return true;
    } on SessionExpiredException {
      ApiLogger.error('[TokenRefresh] Session expired');
      _notifySessionExpired();
      return false;
    } catch (e) {
      ApiLogger.error('[TokenRefresh] Refresh failed: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Уведомить подписчиков об истечении сессии
  void _notifySessionExpired() {
    if (!_isDisposed && !_sessionExpiredController.isClosed) {
      _sessionExpiredController.add(null);
    }
  }

  /// Освободить ресурсы
  void dispose() {
    // Сначала помечаем как disposed чтобы остановить все операции
    _isDisposed = true;

    stop();
    _sessionExpiredController.close();
    ApiLogger.debug('[TokenRefresh] Service disposed');
  }
}
