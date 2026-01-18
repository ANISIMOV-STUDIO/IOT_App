/// Константы приложения
///
/// Централизованное хранение всех конфигурационных констант.
/// Легко изменять для разных environments.
library;

/// Информация о приложении
abstract class AppInfo {
  /// Название приложения
  static const appName = 'BREEZ IOT';
}

/// Константы для работы с сетью
abstract class NetworkConstants {
  /// Интервал проверки доступности сервера
  static const serverCheckInterval = Duration(seconds: 30);

  /// Таймаут ping-запроса
  static const pingTimeout = Duration(seconds: 5);

  /// Интервал polling устройств
  static const devicePollingInterval = Duration(seconds: 30);

  /// Интервал polling энергии
  static const energyPollingInterval = Duration(minutes: 1);

  /// Интервал проверки версии приложения
  static const versionCheckInterval = Duration(hours: 1);
}

/// Константы кеширования
abstract class CacheConstants {
  /// TTL по умолчанию для кеша
  static const defaultTtl = Duration(minutes: 30);

  /// TTL для критических данных (климат, устройства)
  static const criticalDataTtl = Duration(minutes: 5);

  /// TTL для исторических данных
  static const historyDataTtl = Duration(hours: 1);
}

/// Константы аутентификации
abstract class AuthConstants {
  /// Буфер перед истечением токена (обновляем заранее)
  static const tokenExpiryBuffer = Duration(minutes: 1);
}

/// Лимиты запросов
abstract class RequestLimits {
  /// Лимит записей истории датчиков
  static const sensorHistoryLimit = 1000;

  /// Лимит записей истории аварий
  static const alarmHistoryLimit = 100;

  /// Лимит точек графика
  static const graphDataLimit = 1000;

  /// Диапазон графика по умолчанию
  static const defaultGraphRangeDays = 7;
}

/// Значения по умолчанию для устройств
abstract class DeviceDefaults {
  /// Целевая влажность по умолчанию
  static const targetHumidity = 50.0;

  /// Приточный поток по умолчанию
  static const supplyAirflow = 50.0;

  /// Вытяжной поток по умолчанию
  static const exhaustAirflow = 40.0;

  /// Уровень CO2 по умолчанию
  static const co2Ppm = 400;

  /// AQI по умолчанию
  static const pollutantsAqi = 50;
}

/// UI константы
abstract class UiConstants {
  /// Длительность toast уведомления
  static const toastDuration = Duration(seconds: 3);

  /// Длительность анимации
  static const animationDuration = Duration(milliseconds: 300);
}
