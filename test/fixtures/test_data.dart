/// Фабрика тестовых данных
library;

import 'package:hvac_control/domain/entities/user.dart';
import 'package:hvac_control/domain/entities/smart_device.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/entities/energy_stats.dart';
import 'package:hvac_control/domain/entities/occupant.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/data/models/auth_models.dart';

/// Класс с тестовыми данными
class TestData {
  // ==================== Пользователи ====================

  /// Тестовый пользователь
  static User get testUser => const User(
        id: 'test-user-id-123',
        email: 'test@example.com',
        firstName: 'Иван',
        lastName: 'Петров',
        role: 'User',
        emailConfirmed: true,
      );

  /// Неподтверждённый пользователь
  static User get unverifiedUser => const User(
        id: 'unverified-user-id',
        email: 'unverified@example.com',
        firstName: 'Неверифицированный',
        lastName: 'Пользователь',
        role: 'User',
        emailConfirmed: false,
      );

  /// Администратор
  static User get adminUser => const User(
        id: 'admin-user-id',
        email: 'admin@example.com',
        firstName: 'Админ',
        lastName: 'Системы',
        role: 'Admin',
        emailConfirmed: true,
      );

  // ==================== Токены ====================

  /// Тестовый access token (формат JWT, но фиктивный)
  static const String testAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0LXVzZXItaWQtMTIzIiwiZW1haWwiOiJ0ZXN0QGV4YW1wbGUuY29tIiwiZXhwIjo5OTk5OTk5OTk5fQ.test';

  /// Тестовый refresh token
  static const String testRefreshToken = 'test-refresh-token-abc123';

  /// Истёкший access token
  static const String expiredAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0LXVzZXItaWQtMTIzIiwiZW1haWwiOiJ0ZXN0QGV4YW1wbGUuY29tIiwiZXhwIjoxNjAwMDAwMDAwfQ.expired';

  // ==================== Запросы авторизации ====================

  /// Запрос на вход
  static LoginRequest get loginRequest => const LoginRequest(
        email: 'test@example.com',
        password: 'Password123!',
      );

  /// Запрос на регистрацию
  static RegisterRequest get registerRequest => const RegisterRequest(
        email: 'newuser@example.com',
        password: 'Password123!',
        firstName: 'Новый',
        lastName: 'Пользователь',
        dataProcessingConsent: true,
      );

  /// Запрос на верификацию email
  static VerifyEmailRequest get verifyEmailRequest => const VerifyEmailRequest(
        email: 'test@example.com',
        code: '123456',
      );

  /// Запрос на повторную отправку кода
  static ResendCodeRequest get resendCodeRequest => const ResendCodeRequest(
        email: 'test@example.com',
      );

  // ==================== Ответы авторизации ====================

  /// Успешный ответ на вход
  static AuthResponse get authResponse => AuthResponse.fromJson({
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
        'user': userJson,
      });

  /// Успешный ответ на регистрацию
  static const RegisterResponse registerResponse = RegisterResponse(
    message: 'Регистрация успешна',
    email: 'newuser@example.com',
    requiresEmailVerification: true,
  );

  // ==================== JSON ответы ====================

  /// JSON для пользователя
  static Map<String, dynamic> get userJson => {
        'id': 'test-user-id-123',
        'email': 'test@example.com',
        'firstName': 'Иван',
        'lastName': 'Петров',
        'role': 'User',
        'emailConfirmed': true,
      };

  /// JSON для успешного входа
  static Map<String, dynamic> get loginSuccessJson => {
        'accessToken': testAccessToken,
        'refreshToken': testRefreshToken,
        'user': userJson,
      };

  /// JSON для успешной регистрации
  static Map<String, dynamic> get registerSuccessJson => {
        'message': 'Регистрация успешна',
        'email': 'newuser@example.com',
        'requiresEmailVerification': true,
      };

  /// JSON для ошибки
  static Map<String, dynamic> errorJson(String message) => {
        'message': message,
      };

  // ==================== Учётные данные ====================

  /// Валидный email
  static const String validEmail = 'valid@example.com';

  /// Невалидный email
  static const String invalidEmail = 'invalid-email';

  /// Пустой email
  static const String emptyEmail = '';

  /// Валидный пароль
  static const String validPassword = 'Password123!';

  /// Короткий пароль (менее 8 символов)
  static const String shortPassword = 'Pass1!';

  /// Пароль без цифр
  static const String noDigitPassword = 'PasswordABC!';

  /// Пароль без букв
  static const String noLetterPassword = '12345678!';

  /// Пароль с кириллицей
  static const String cyrillicPassword = 'Пароль123!';

  /// Пустой пароль
  static const String emptyPassword = '';

  /// Валидное имя
  static const String validName = 'Иван';

  /// Короткое имя (менее 2 символов)
  static const String shortName = 'И';

  /// Имя с цифрами
  static const String nameWithNumbers = 'Иван123';

  /// Пустое имя
  static const String emptyName = '';

  // ==================== HVAC устройства ====================

  /// Тестовое HVAC устройство
  static HvacDevice get testHvacDevice => const HvacDevice(
        id: 'hvac-device-1',
        name: 'Бризер Гостиная',
        brand: 'Breez',
        deviceType: HvacDeviceType.ventilation,
        isOnline: true,
        isActive: true,
      );

  /// Второе HVAC устройство
  static HvacDevice get testHvacDevice2 => const HvacDevice(
        id: 'hvac-device-2',
        name: 'Бризер Спальня',
        brand: 'Breez',
        deviceType: HvacDeviceType.ventilation,
        isOnline: true,
        isActive: false,
      );

  /// Список HVAC устройств
  static List<HvacDevice> get testHvacDevices => [
        testHvacDevice,
        testHvacDevice2,
      ];

  // ==================== Smart устройства ====================

  /// Тестовое smart устройство (вентиляция)
  static SmartDevice get testSmartDevice => SmartDevice(
        id: 'smart-device-1',
        name: 'Вентиляция Гостиная',
        type: SmartDeviceType.ventilation,
        isOn: true,
        powerConsumption: 0.15,
        lastUpdated: DateTime(2024, 1, 15, 10, 30),
      );

  /// Тестовое smart устройство (выключено)
  static SmartDevice get testSmartDeviceOff => SmartDevice(
        id: 'smart-device-2',
        name: 'Увлажнитель',
        type: SmartDeviceType.humidifier,
        isOn: false,
        powerConsumption: 0.05,
        lastUpdated: DateTime(2024, 1, 15, 10, 30),
      );

  /// Список smart устройств
  static List<SmartDevice> get testSmartDevices => [
        testSmartDevice,
        testSmartDeviceOff,
      ];

  // ==================== Климат ====================

  /// Тестовое состояние климата
  static ClimateState get testClimateState => const ClimateState(
        roomId: 'room-1',
        deviceName: 'Бризер Гостиная',
        currentTemperature: 23.5,
        targetTemperature: 22,
        humidity: 45,
        mode: ClimateMode.heating,
        isOn: true,
        supplyAirflow: 150,
        exhaustAirflow: 130,
        co2Ppm: 650,
        pollutantsAqi: 25,
        airQuality: AirQualityLevel.good,
      );

  /// Климат в режиме охлаждения
  static ClimateState get testClimateStateCooling => const ClimateState(
        roomId: 'room-2',
        deviceName: 'Бризер Спальня',
        currentTemperature: 26.0,
        targetTemperature: 24,
        humidity: 50,
        mode: ClimateMode.cooling,
        isOn: true,
        supplyAirflow: 200,
        exhaustAirflow: 180,
        co2Ppm: 450,
        pollutantsAqi: 15,
        airQuality: AirQualityLevel.excellent,
      );

  // ==================== Энергопотребление ====================

  /// Тестовая статистика энергопотребления
  static EnergyStats get testEnergyStats => EnergyStats(
        totalKwh: 12.5,
        totalHours: 8,
        date: DateTime(2024, 1, 15),
        hourlyData: const [
          HourlyUsage(hour: 8, kwh: 1.2),
          HourlyUsage(hour: 9, kwh: 1.5),
          HourlyUsage(hour: 10, kwh: 1.3),
        ],
      );

  /// Потребление по устройствам
  static List<DeviceEnergyUsage> get testDeviceEnergyUsage => const [
        DeviceEnergyUsage(
          deviceId: 'hvac-device-1',
          deviceName: 'Бризер Гостиная',
          deviceType: 'hvac',
          unitCount: 1,
          totalKwh: 8.5,
        ),
        DeviceEnergyUsage(
          deviceId: 'smart-device-1',
          deviceName: 'Термостат',
          deviceType: 'thermostat',
          unitCount: 1,
          totalKwh: 4.0,
        ),
      ];

  // ==================== Жители ====================

  /// Тестовый житель (дома)
  static Occupant get testOccupantHome => const Occupant(
        id: 'occupant-1',
        name: 'Иван',
        avatarUrl: null,
        isHome: true,
        currentRoom: 'Гостиная',
      );

  /// Тестовый житель (не дома)
  static Occupant get testOccupantAway => const Occupant(
        id: 'occupant-2',
        name: 'Мария',
        avatarUrl: null,
        isHome: false,
        currentRoom: null,
      );

  /// Список жителей
  static List<Occupant> get testOccupants => [
        testOccupantHome,
        testOccupantAway,
      ];

  // ==================== Расписание ====================

  /// Тестовая запись расписания (активная)
  static ScheduleEntry get testScheduleEntryActive => const ScheduleEntry(
        id: 'schedule-1',
        deviceId: 'hvac-device-1',
        day: 'Понедельник',
        mode: 'comfort',
        timeRange: '08:00-18:00',
        tempDay: 22,
        tempNight: 19,
        isActive: true,
      );

  /// Тестовая запись расписания (неактивная)
  static ScheduleEntry get testScheduleEntryInactive => const ScheduleEntry(
        id: 'schedule-2',
        deviceId: 'hvac-device-1',
        day: 'Вторник',
        mode: 'eco',
        timeRange: '09:00-17:00',
        tempDay: 20,
        tempNight: 18,
        isActive: false,
      );

  /// Список записей расписания
  static List<ScheduleEntry> get testWeeklySchedule => [
        testScheduleEntryActive,
        testScheduleEntryInactive,
      ];

  // ==================== Уведомления ====================

  /// Фиксированный timestamp для тестов (избегаем DateTime.now())
  static final DateTime _fixedTimestamp = DateTime(2024, 1, 15, 12, 0, 0);
  static final DateTime _fixedTimestampYesterday = DateTime(2024, 1, 14, 12, 0, 0);

  /// Тестовое уведомление (непрочитанное)
  static UnitNotification get testNotificationUnread => UnitNotification(
        id: 'notif-1',
        deviceId: 'hvac-device-1',
        title: 'Замена фильтра',
        message: 'Рекомендуется заменить фильтр через 30 дней',
        type: NotificationType.warning,
        timestamp: _fixedTimestamp,
        isRead: false,
      );

  /// Тестовое уведомление (прочитанное)
  static UnitNotification get testNotificationRead => UnitNotification(
        id: 'notif-2',
        deviceId: 'hvac-device-1',
        title: 'Обновление прошивки',
        message: 'Доступна новая версия прошивки 2.1.0',
        type: NotificationType.info,
        timestamp: _fixedTimestampYesterday,
        isRead: true,
      );

  /// Список уведомлений (кешируем для equatable сравнений)
  static final List<UnitNotification> _testNotificationsCache = [
    UnitNotification(
      id: 'notif-1',
      deviceId: 'hvac-device-1',
      title: 'Замена фильтра',
      message: 'Рекомендуется заменить фильтр через 30 дней',
      type: NotificationType.warning,
      timestamp: _fixedTimestamp,
      isRead: false,
    ),
    UnitNotification(
      id: 'notif-2',
      deviceId: 'hvac-device-1',
      title: 'Обновление прошивки',
      message: 'Доступна новая версия прошивки 2.1.0',
      type: NotificationType.info,
      timestamp: _fixedTimestampYesterday,
      isRead: true,
    ),
  ];

  /// Список уведомлений
  static List<UnitNotification> get testNotifications => _testNotificationsCache;

  // ==================== Данные графиков ====================

  /// Тестовые точки графика
  static List<GraphDataPoint> get testGraphData => const [
        GraphDataPoint(label: 'Пн', value: 22.0),
        GraphDataPoint(label: 'Вт', value: 22.5),
        GraphDataPoint(label: 'Ср', value: 23.0),
        GraphDataPoint(label: 'Чт', value: 21.5),
        GraphDataPoint(label: 'Пт', value: 22.0),
      ];
}
