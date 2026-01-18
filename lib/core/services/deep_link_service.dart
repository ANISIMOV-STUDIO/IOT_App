/// Deep Link Service - Обработка входящих deep links
library;

import 'dart:async';

import 'package:go_router/go_router.dart';

import 'package:hvac_control/core/logging/talker_config.dart';
import 'package:hvac_control/core/navigation/app_routes.dart';

/// Сервис для обработки deep links
///
/// Поддерживает:
/// - Кастомную URI схему (breez://)
/// - Universal Links (iOS) / App Links (Android)
/// - Холодный и горячий запуск
///
/// Примечание: Для полной поддержки deep links добавьте пакет app_links:
/// ```yaml
/// dependencies:
///   app_links: ^6.0.0
/// ```
///
/// И раскомментируйте код инициализации ниже.
class DeepLinkService {

  DeepLinkService({required this.router});
  final GoRouter router;

  // Для полной поддержки deep links:
  // final AppLinks _appLinks = AppLinks();
  // StreamSubscription<Uri>? _linkSubscription;

  Uri? _initialUri;
  Uri? _pendingDeepLink;
  bool _isInitialized = false;

  /// Инициализация сервиса
  ///
  /// Вызывать после создания GoRouter
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    // GoRouter автоматически обрабатывает deep links если настроен правильно.
    // Этот сервис предоставляет дополнительные утилиты и логирование.

    // Для полной поддержки раскомментируйте:
    // try {
    //   _initialUri = await _appLinks.getInitialLink();
    //   if (_initialUri != null) {
    //     TalkerConfig.talker.info('Deep link (cold start): $_initialUri');
    //     _handleDeepLink(_initialUri!);
    //   }
    //
    //   _linkSubscription = _appLinks.uriLinkStream.listen(
    //     (uri) {
    //       TalkerConfig.talker.info('Deep link (warm): $uri');
    //       _handleDeepLink(uri);
    //     },
    //     onError: (error) {
    //       TalkerConfig.talker.error('Deep link error: $error');
    //     },
    //   );
    // } catch (e, st) {
    //   TalkerConfig.talker.handle(e, st, 'Deep link initialization failed');
    // }

    TalkerConfig.talker.info('DeepLinkService initialized');
  }

  /// Обработать deep link вручную (для тестирования или кастомной логики)
  void handleDeepLink(Uri uri) {
    TalkerConfig.talker.info('Handling deep link: $uri');
    final path = convertUriToPath(uri);
    if (path != null) {
      TalkerConfig.talker.debug('Navigating to: $path');
      router.go(path);
    }
  }

  /// Сохранить pending deep link для обработки после авторизации
  void setPendingDeepLink(Uri uri) {
    _pendingDeepLink = uri;
    TalkerConfig.talker.debug('Pending deep link saved: $uri');
  }

  /// Обработать pending deep link (вызывать после успешной авторизации)
  void processPendingDeepLink() {
    if (_pendingDeepLink != null) {
      TalkerConfig.talker.info('Processing pending deep link: $_pendingDeepLink');
      handleDeepLink(_pendingDeepLink!);
      _pendingDeepLink = null;
    }
  }

  /// Конвертация URI в путь GoRouter
  String? convertUriToPath(Uri uri) {
    // Обработка кастомной схемы breez://
    if (uri.scheme == AppDeepLinks.scheme) {
      return _parseCustomScheme(uri);
    }

    // Обработка https:// (Universal Links)
    if (uri.scheme == 'https' && uri.host == AppDeepLinks.webDomain) {
      return uri.path + (uri.query.isNotEmpty ? '?${uri.query}' : '');
    }

    // Обработка http:// (для тестирования)
    if (uri.scheme == 'http' && uri.host == 'localhost') {
      return uri.path + (uri.query.isNotEmpty ? '?${uri.query}' : '');
    }

    TalkerConfig.talker.warning('Unknown deep link scheme: ${uri.scheme}');
    return null;
  }

  /// Парсинг кастомной схемы breez://
  String? _parseCustomScheme(Uri uri) {
    final host = uri.host;
    final pathSegments = uri.pathSegments;

    return switch (host) {
      'home' => AppRoutes.home,
      'login' => AppRoutes.login,
      'register' => AppRoutes.register,
      'notifications' => AppRoutes.notifications,
      'profile' => AppRoutes.profile,
      'settings' => AppRoutes.settings,
      'device' when pathSegments.isNotEmpty => _parseDevicePath(pathSegments),
      _ => _parseFallbackPath(uri),
    };
  }

  /// Парсинг путей устройства
  String? _parseDevicePath(List<String> pathSegments) {
    if (pathSegments.isEmpty) {
      return null;
    }

    final deviceId = pathSegments[0];
    if (pathSegments.length == 1) {
      return AppPaths.device(deviceId);
    }

    final subPath = pathSegments[1];
    return switch (subPath) {
      'schedule' => AppPaths.deviceSchedule(deviceId),
      'analytics' => AppPaths.deviceAnalytics(deviceId),
      'alarms' => AppPaths.deviceAlarms(deviceId),
      'settings' => AppPaths.deviceSettings(deviceId),
      _ => AppPaths.device(deviceId),
    };
  }

  /// Fallback парсинг
  String? _parseFallbackPath(Uri uri) {
    final path = '/${uri.host}${uri.path}';
    final query = uri.query.isNotEmpty ? '?${uri.query}' : '';
    return '$path$query';
  }

  /// Получить initial deep link URI
  Uri? get initialUri => _initialUri;

  /// Был ли запуск через deep link
  bool get wasLaunchedFromDeepLink => _initialUri != null;

  /// Есть ли pending deep link
  bool get hasPendingDeepLink => _pendingDeepLink != null;

  /// Освобождение ресурсов
  void dispose() {
    // _linkSubscription?.cancel();
    // _linkSubscription = null;
  }
}

/// Утилиты для работы с deep links
abstract final class DeepLinkUtils {
  /// Создать deep link URL для шаринга
  static String createShareLink({
    required String path,
    Map<String, String>? queryParams,
    bool useWebDomain = true,
  }) {
    final uri = Uri(
      scheme: useWebDomain ? 'https' : AppDeepLinks.scheme,
      host: useWebDomain ? AppDeepLinks.webDomain : null,
      path: path,
      queryParameters: queryParams?.isNotEmpty ?? false ? queryParams : null,
    );
    return uri.toString();
  }

  /// Создать deep link для устройства
  static String deviceLink(String deviceId, {bool webLink = true}) => createShareLink(
      path: '/device/$deviceId',
      useWebDomain: webLink,
    );

  /// Создать deep link для расписания устройства
  static String scheduleLink(String deviceId, {bool webLink = true}) => createShareLink(
      path: '/device/$deviceId/schedule',
      useWebDomain: webLink,
    );

  /// Валидация deep link URI
  static bool isValidDeepLink(Uri uri) {
    if (uri.scheme == AppDeepLinks.scheme) {
      return true;
    }
    if (uri.scheme == 'https' && uri.host == AppDeepLinks.webDomain) {
      return true;
    }
    return false;
  }

  /// Извлечь deviceId из deep link
  static String? extractDeviceId(Uri uri) {
    final pathSegments = uri.pathSegments;

    // Для кастомной схемы host = 'device'
    if (uri.scheme == AppDeepLinks.scheme && uri.host == 'device') {
      return pathSegments.isNotEmpty ? pathSegments[0] : null;
    }

    // Для web link: /device/123/...
    final deviceIndex = pathSegments.indexOf('device');
    if (deviceIndex != -1 && deviceIndex + 1 < pathSegments.length) {
      return pathSegments[deviceIndex + 1];
    }

    return null;
  }
}
