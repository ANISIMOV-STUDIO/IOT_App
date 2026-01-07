/// Сервис для отслеживания сетевого подключения и доступности API
///
/// Использует connectivity_plus для определения состояния сети
/// и периодический ping для проверки доступности сервера.
library;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../config/app_constants.dart';
import '../logging/api_logger.dart';

/// Состояние сетевого подключения
enum NetworkStatus {
  /// Полностью онлайн - есть сеть и сервер доступен
  online,
  /// Нет сети (wifi/mobile отключены)
  offline,
  /// Есть сеть, но сервер недоступен
  serverUnavailable,
  /// Состояние неизвестно (инициализация)
  unknown,
}

/// Сервис для мониторинга сетевого подключения и доступности API
class ConnectivityService {
  final Connectivity _connectivity;
  final http.Client? _httpClient;

  /// Контроллер для стрима состояния
  final _statusController = StreamController<NetworkStatus>.broadcast();

  /// Текущее состояние сети
  NetworkStatus _currentStatus = NetworkStatus.unknown;

  /// Подписка на изменения connectivity
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Таймер для периодической проверки сервера
  Timer? _serverCheckTimer;

  /// Интервал проверки сервера
  static const _serverCheckInterval = NetworkConstants.serverCheckInterval;

  /// Таймаут для ping запроса
  static const _pingTimeout = NetworkConstants.pingTimeout;

  /// Конструктор с возможностью инжекции зависимости
  ConnectivityService([Connectivity? connectivity, http.Client? httpClient])
      : _connectivity = connectivity ?? Connectivity(),
        _httpClient = httpClient;

  /// Текущий статус сети
  NetworkStatus get status => _currentStatus;

  /// true если есть подключение к интернету и серверу
  bool get isOnline => _currentStatus == NetworkStatus.online;

  /// true если нет подключения к интернету
  bool get isOffline => _currentStatus == NetworkStatus.offline;

  /// true если сервер недоступен (но сеть есть)
  bool get isServerUnavailable => _currentStatus == NetworkStatus.serverUnavailable;

  /// true если можно использовать кеш (offline или сервер недоступен)
  bool get shouldUseCache =>
      _currentStatus == NetworkStatus.offline ||
      _currentStatus == NetworkStatus.serverUnavailable;

  /// Stream изменений состояния сети
  Stream<NetworkStatus> get onStatusChange => _statusController.stream;

  /// Инициализация сервиса
  ///
  /// Должен быть вызван при старте приложения
  Future<void> initialize() async {
    // Получаем текущее состояние
    await checkConnectivity();

    // Подписываемся на изменения сети
    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);

    // Запускаем периодическую проверку сервера
    _startServerCheck();
  }

  /// Запустить периодическую проверку сервера
  void _startServerCheck() {
    _serverCheckTimer?.cancel();
    _serverCheckTimer = Timer.periodic(_serverCheckInterval, (_) {
      _checkServerAvailability();
    });
  }

  /// Проверить текущее состояние сети и сервера
  Future<NetworkStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasNetwork = _hasNetworkConnection(results);

      if (!hasNetwork) {
        _updateStatus(NetworkStatus.offline);
        return _currentStatus;
      }

      // Есть сеть - проверяем сервер
      final serverAvailable = await _checkServerAvailability();
      _updateStatus(serverAvailable ? NetworkStatus.online : NetworkStatus.serverUnavailable);
      return _currentStatus;
    } catch (e) {
      _updateStatus(NetworkStatus.unknown);
      return _currentStatus;
    }
  }

  /// Проверить доступность сервера
  Future<bool> _checkServerAvailability() async {
    final client = _httpClient ?? http.Client();
    final shouldCloseClient = _httpClient == null;

    try {
      // Пробуем /health endpoint
      final response = await client
          .get(Uri.parse('${ApiConfig.httpUrl}/health'))
          .timeout(_pingTimeout);

      return response.statusCode == 200;
    } catch (e) {
      // Попробуем другой endpoint если /health не существует
      try {
        final response = await client
            .get(Uri.parse(ApiConfig.deviceApiUrl))
            .timeout(_pingTimeout);

        // Любой ответ кроме сетевой ошибки - сервер доступен
        return response.statusCode < 500;
      } catch (e) {
        ApiLogger.debug('[Connectivity] Сервер недоступен', e);
        return false;
      }
    } finally {
      // Гарантированно закрываем клиент если создали его здесь
      if (shouldCloseClient) {
        client.close();
      }
    }
  }

  /// Обработчик изменений connectivity
  void _handleConnectivityChange(List<ConnectivityResult> results) async {
    final hasNetwork = _hasNetworkConnection(results);

    if (!hasNetwork) {
      _updateStatus(NetworkStatus.offline);
      return;
    }

    // Есть сеть - проверяем сервер
    final serverAvailable = await _checkServerAvailability();
    _updateStatus(serverAvailable ? NetworkStatus.online : NetworkStatus.serverUnavailable);
  }

  /// Проверить наличие сетевого подключения
  bool _hasNetworkConnection(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }

    return results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
  }

  /// Обновить статус
  void _updateStatus(NetworkStatus newStatus) {
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
    }
  }

  /// Выполнить действие только при наличии сети и сервера
  Future<T> executeIfOnline<T>({
    required Future<T> Function() action,
    required T fallback,
  }) async {
    if (isOnline) {
      return action();
    }
    return fallback;
  }

  /// Выполнить действие с fallback на кеш
  Future<T> executeWithFallback<T>({
    required Future<T> Function() onlineAction,
    required Future<T> Function() offlineAction,
  }) async {
    if (shouldUseCache) {
      return offlineAction();
    }

    try {
      return await onlineAction();
    } catch (e) {
      // При ошибке — возвращаем из кеша и помечаем сервер недоступным
      ApiLogger.warning('[Connectivity] Fallback на оффлайн режим', e);
      _updateStatus(NetworkStatus.serverUnavailable);
      return offlineAction();
    }
  }

  /// Принудительно пометить сервер недоступным (при ошибке запроса)
  void markServerUnavailable() {
    if (_currentStatus == NetworkStatus.online) {
      _updateStatus(NetworkStatus.serverUnavailable);
    }
  }

  /// Принудительно проверить соединение
  Future<void> recheckConnection() async {
    await checkConnectivity();
  }

  /// Освободить ресурсы
  void dispose() {
    _subscription?.cancel();
    _serverCheckTimer?.cancel();
    _statusController.close();
  }
}
