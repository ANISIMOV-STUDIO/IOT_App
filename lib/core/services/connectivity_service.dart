/// Сервис для отслеживания сетевого подключения
///
/// Использует connectivity_plus для определения состояния сети.
/// Предоставляет:
/// - Текущий статус подключения
/// - Stream изменений состояния
/// - Методы для проверки доступности сети
library;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Состояние сетевого подключения
enum NetworkStatus {
  /// Подключение к интернету есть
  online,
  /// Нет подключения к интернету
  offline,
  /// Состояние неизвестно (инициализация)
  unknown,
}

/// Сервис для мониторинга сетевого подключения
class ConnectivityService {
  final Connectivity _connectivity;

  /// Контроллер для стрима состояния
  final _statusController = StreamController<NetworkStatus>.broadcast();

  /// Текущее состояние сети
  NetworkStatus _currentStatus = NetworkStatus.unknown;

  /// Подписка на изменения connectivity
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Конструктор с возможностью инжекции зависимости
  ConnectivityService([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  /// Текущий статус сети
  NetworkStatus get status => _currentStatus;

  /// true если есть подключение к интернету
  bool get isOnline => _currentStatus == NetworkStatus.online;

  /// true если нет подключения к интернету
  bool get isOffline => _currentStatus == NetworkStatus.offline;

  /// Stream изменений состояния сети
  Stream<NetworkStatus> get onStatusChange => _statusController.stream;

  /// Инициализация сервиса
  ///
  /// Должен быть вызван при старте приложения
  Future<void> initialize() async {
    // Получаем текущее состояние
    await checkConnectivity();

    // Подписываемся на изменения
    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  /// Проверить текущее состояние сети
  Future<NetworkStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);
      return _currentStatus;
    } catch (e) {
      _currentStatus = NetworkStatus.unknown;
      _statusController.add(_currentStatus);
      return _currentStatus;
    }
  }

  /// Обработчик изменений connectivity
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    _updateStatus(results);
  }

  /// Обновить статус на основе результатов connectivity
  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus = _mapToNetworkStatus(results);

    // Эмитим только если статус изменился
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
    }
  }

  /// Преобразовать результаты connectivity в NetworkStatus
  NetworkStatus _mapToNetworkStatus(List<ConnectivityResult> results) {
    // Если есть хотя бы одно активное подключение — online
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkStatus.offline;
    }

    // WiFi, Mobile, Ethernet — всё считается online
    if (results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet)) {
      return NetworkStatus.online;
    }

    return NetworkStatus.offline;
  }

  /// Выполнить действие только при наличии сети
  ///
  /// Возвращает результат [action] если online,
  /// иначе возвращает [fallback]
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
  ///
  /// Пытается выполнить [onlineAction], при ошибке или offline
  /// вызывает [offlineAction]
  Future<T> executeWithFallback<T>({
    required Future<T> Function() onlineAction,
    required Future<T> Function() offlineAction,
  }) async {
    if (isOffline) {
      return offlineAction();
    }

    try {
      return await onlineAction();
    } catch (_) {
      // При ошибке сети — возвращаем из кеша
      return offlineAction();
    }
  }

  /// Освободить ресурсы
  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
