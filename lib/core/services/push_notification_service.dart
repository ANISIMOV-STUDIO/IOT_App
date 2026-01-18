/// Сервис Push уведомлений (Firebase Cloud Messaging)
///
/// Обеспечивает:
/// - Инициализацию FCM
/// - Запрос разрешений на уведомления
/// - Получение и обновление FCM токена
/// - Обработку входящих уведомлений
// ignore_for_file: do_not_use_environment

library;

// Сервис используется через DI (GetIt), analyzer не может отследить использование
// ignore_for_file: unreachable_from_main

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Callback для обработки уведомлений
typedef NotificationCallback = void Function(RemoteMessage message);

/// Сервис управления push уведомлениями
class PushNotificationService {
  /// Конструктор с возможностью инжекции (для тестов)
  PushNotificationService([FirebaseMessaging? messaging])
      : _messaging = messaging ?? FirebaseMessaging.instance;
  final FirebaseMessaging _messaging;

  /// Контроллер для токена FCM
  final _tokenController = StreamController<String?>.broadcast();

  /// Контроллер для входящих уведомлений (foreground)
  final _messageController = StreamController<RemoteMessage>.broadcast();

  /// Текущий FCM токен
  String? _currentToken;

  /// Инициализирован ли сервис
  bool _initialized = false;

  /// Флаг для предотвращения race condition при dispose
  bool _isDisposed = false;

  /// Текущий FCM токен
  String? get token => _currentToken;

  /// Stream изменений токена
  Stream<String?> get onTokenRefresh => _tokenController.stream;

  /// Инициализирован ли сервис
  bool get isInitialized => _initialized;

  /// Инициализация сервиса
  ///
  /// Должен быть вызван после Firebase.initializeApp()
  Future<void> initialize() async {
    if (_initialized || _isDisposed) {
      return;
    }

    try {
      // Запрашиваем разрешения
      final settings = await requestPermission();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Получаем токен
        await _getToken();

        // Слушаем обновления токена
        _messaging.onTokenRefresh.listen(_handleTokenRefresh);

        // Слушаем foreground сообщения
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Обрабатываем сообщение, которое открыло приложение
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          _handleMessageOpenedApp(initialMessage);
        }

        // Слушаем открытие приложения из уведомления
        FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

        _initialized = true;
        debugPrint('PushNotificationService: Инициализирован');
      } else {
        debugPrint('PushNotificationService: Разрешения не получены');
      }
    } catch (e) {
      debugPrint('PushNotificationService: Ошибка инициализации: $e');
    }
  }

  /// Запросить разрешения на уведомления
  Future<NotificationSettings> requestPermission() async =>
      _messaging.requestPermission();

  /// Внутренний метод получения токена
  Future<String?> _getToken() async {
    if (_isDisposed) {
      return null;
    }

    try {
      // Для Web нужно указать VAPID key
      if (kIsWeb) {
        _currentToken = await _messaging.getToken(
          vapidKey: _getVapidKey(),
        );
      } else {
        _currentToken = await _messaging.getToken();
      }

      if (_currentToken != null && !_isDisposed) {
        if (!_tokenController.isClosed) {
          _tokenController.add(_currentToken);
        }
        debugPrint('PushNotificationService: Токен получен');
      }

      return _currentToken;
    } catch (e) {
      debugPrint('PushNotificationService: Ошибка получения токена: $e');
      return null;
    }
  }

  /// Получить VAPID key для Web push
  ///
  /// VAPID key генерируется в Firebase Console:
  /// Project Settings -> Cloud Messaging -> Web Push certificates
  String? _getVapidKey() {
    // TODO: Заменить на реальный VAPID key из Firebase Console
    // Этот ключ нужно получить из Firebase Console после создания проекта
    const vapidKey = String.fromEnvironment(
      'FIREBASE_VAPID_KEY',
    );
    return vapidKey.isNotEmpty ? vapidKey : null;
  }

  /// Обработка обновления токена
  void _handleTokenRefresh(String newToken) {
    if (_isDisposed) {
      return;
    }
    _currentToken = newToken;
    if (!_tokenController.isClosed) {
      _tokenController.add(newToken);
    }
    debugPrint('PushNotificationService: Токен обновлён');
  }

  /// Обработка foreground сообщения
  void _handleForegroundMessage(RemoteMessage message) {
    if (_isDisposed) {
      return;
    }
    debugPrint(
        'PushNotificationService: Foreground сообщение: ${message.notification?.title}');
    if (!_messageController.isClosed) {
      _messageController.add(message);
    }
  }

  /// Обработка открытия приложения из уведомления
  void _handleMessageOpenedApp(RemoteMessage message) {
    if (_isDisposed) {
      return;
    }
    debugPrint('PushNotificationService: Приложение открыто из уведомления');
    if (!_messageController.isClosed) {
      _messageController.add(message);
    }
  }

  /// Подписаться на топик
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('PushNotificationService: Подписка на топик: $topic');
    } catch (e) {
      debugPrint('PushNotificationService: Ошибка подписки на топик: $e');
    }
  }

  /// Отписаться от топика
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('PushNotificationService: Отписка от топика: $topic');
    } catch (e) {
      debugPrint('PushNotificationService: Ошибка отписки от топика: $e');
    }
  }

  /// Удалить токен (при logout)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _currentToken = null;
      _tokenController.add(null);
      debugPrint('PushNotificationService: Токен удалён');
    } catch (e) {
      debugPrint('PushNotificationService: Ошибка удаления токена: $e');
    }
  }

  /// Освободить ресурсы
  void dispose() {
    // Сначала помечаем как disposed чтобы остановить все операции
    _isDisposed = true;

    _tokenController.close();
    _messageController.close();
  }
}

/// Background message handler (должен быть top-level функцией)
///
/// Вызывается для обработки сообщений когда приложение в background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Инициализируем Firebase если нужно
  await Firebase.initializeApp();

  debugPrint('Background message: ${message.notification?.title}');
  // Здесь можно добавить логику обработки background сообщений
}
