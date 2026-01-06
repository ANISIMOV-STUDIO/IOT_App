/// App Routes - Централизованные маршруты и deep link пути
library;

/// Константы маршрутов приложения
///
/// Поддерживаемые deep links:
/// - breez://home - главный экран
/// - breez://device/{id} - страница устройства
/// - breez://device/{id}/schedule - расписание устройства
/// - breez://device/{id}/analytics - аналитика устройства
/// - breez://notifications - уведомления
/// - breez://profile - профиль
/// - breez://settings - настройки
abstract final class AppRoutes {
  // ============ Auth Routes ============
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';

  // ============ Main Routes ============
  static const String home = '/';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // ============ Device Routes ============
  /// Базовый путь устройства: /device/:deviceId
  static const String device = '/device/:deviceId';

  /// Расписание устройства: /device/:deviceId/schedule
  static const String deviceSchedule = '/device/:deviceId/schedule';

  /// Аналитика устройства: /device/:deviceId/analytics
  static const String deviceAnalytics = '/device/:deviceId/analytics';

  /// История тревог: /device/:deviceId/alarms
  static const String deviceAlarms = '/device/:deviceId/alarms';

  /// Настройки устройства: /device/:deviceId/settings
  static const String deviceSettings = '/device/:deviceId/settings';

  // ============ Legacy Routes (для обратной совместимости) ============
  static const String schedule = '/schedule';
  static const String alarmHistory = '/alarm-history';
}

/// Построители путей для навигации
///
/// Использование:
/// ```dart
/// context.go(AppPaths.device('device-123'));
/// context.go(AppPaths.deviceSchedule('device-123', 'Гостиная'));
/// ```
abstract final class AppPaths {
  /// Путь к странице устройства
  static String device(String deviceId) => '/device/$deviceId';

  /// Путь к расписанию устройства
  static String deviceSchedule(String deviceId) => '/device/$deviceId/schedule';

  /// Путь к аналитике устройства
  static String deviceAnalytics(String deviceId) => '/device/$deviceId/analytics';

  /// Путь к истории тревог устройства
  static String deviceAlarms(String deviceId) => '/device/$deviceId/alarms';

  /// Путь к настройкам устройства
  static String deviceSettings(String deviceId) => '/device/$deviceId/settings';

  /// Путь к верификации email
  static String verifyEmail(String email, {String? password}) {
    final query = 'email=${Uri.encodeComponent(email)}';
    return '${AppRoutes.verifyEmail}?$query';
  }

  /// Путь к восстановлению пароля
  static String forgotPassword({String? email}) {
    if (email == null) return AppRoutes.forgotPassword;
    return '${AppRoutes.forgotPassword}?email=${Uri.encodeComponent(email)}';
  }
}

/// Deep link URI схемы
abstract final class AppDeepLinks {
  /// Кастомная URI схема приложения
  static const String scheme = 'breez';

  /// Web домен для Universal Links / App Links
  static const String webDomain = 'breez.app';

  /// Полные deep link URLs
  static String home() => '$scheme://home';
  static String device(String deviceId) => '$scheme://device/$deviceId';
  static String deviceSchedule(String deviceId) => '$scheme://device/$deviceId/schedule';
  static String deviceAnalytics(String deviceId) => '$scheme://device/$deviceId/analytics';
  static String notifications() => '$scheme://notifications';
  static String profile() => '$scheme://profile';
  static String settings() => '$scheme://settings';
}

/// Параметры маршрута
abstract final class RouteParams {
  static const String deviceId = 'deviceId';
  static const String deviceName = 'deviceName';
  static const String email = 'email';
  static const String tab = 'tab';
}

/// Вкладки главного экрана для deep link навигации
enum MainTab {
  dashboard(0, 'dashboard'),
  devices(1, 'devices'),
  analytics(2, 'analytics'),
  profile(3, 'profile');

  final int tabIndex;
  final String tabName;

  const MainTab(this.tabIndex, this.tabName);

  /// Получить вкладку по имени
  static MainTab? fromName(String? name) {
    if (name == null) return null;
    return MainTab.values.where((t) => t.tabName == name).firstOrNull;
  }

  /// Получить вкладку по индексу
  static MainTab fromIndex(int idx) {
    return MainTab.values.firstWhere(
      (t) => t.tabIndex == idx,
      orElse: () => MainTab.dashboard,
    );
  }
}
