/// Контейнер внедрения зависимостей (Dependency Injection)
///
/// Настройка всех зависимостей с использованием get_it service locator
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// Core - Основные сервисы
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../services/version_check_service.dart';
import '../services/auth_storage_service.dart';
import '../services/connectivity_service.dart';
import '../services/cache_service.dart';
import '../services/push_notification_service.dart';
import '../services/fcm_token_service.dart';

// Data - Сервисы данных
import '../../data/services/auth_service.dart';

// Data - API Client (Platform-specific)
import '../../data/api/platform/api_client.dart';
import '../../data/api/platform/api_client_factory.dart';

// Domain - Интерфейсы репозиториев
import '../../domain/repositories/climate_repository.dart';
import '../../domain/repositories/energy_repository.dart';
import '../../domain/repositories/smart_device_repository.dart';
import '../../domain/repositories/occupant_repository.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/graph_data_repository.dart';

// Presentation - BLoCs
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/devices/devices_bloc.dart';
import '../../presentation/bloc/climate/climate_bloc.dart';
import '../../presentation/bloc/notifications/notifications_bloc.dart';
import '../../presentation/bloc/analytics/analytics_bloc.dart';
import '../../presentation/bloc/connectivity/connectivity_bloc.dart';

// Domain - Use Cases
import '../../domain/usecases/usecases.dart';

// Data - Mock репозитории (для разработки/тестирования)
import '../../data/repositories/mock_climate_repository.dart';
import '../../data/repositories/mock_energy_repository.dart';
import '../../data/repositories/mock_smart_device_repository.dart';
import '../../data/repositories/mock_occupant_repository.dart';
import '../../data/repositories/mock_schedule_repository.dart';
import '../../data/repositories/mock_notification_repository.dart';
import '../../data/repositories/mock_graph_data_repository.dart';

// Data - Real репозитории (реальное API)
import '../../data/repositories/real_climate_repository.dart';
import '../../data/repositories/real_energy_repository.dart';
import '../../data/repositories/real_smart_device_repository.dart';
import '../../data/repositories/real_occupant_repository.dart';
import '../../data/repositories/real_schedule_repository.dart';
import '../../data/repositories/real_notification_repository.dart';
import '../../data/repositories/real_graph_data_repository.dart';

// Data - Cached репозитории (offline поддержка)
import '../../data/repositories/cached_climate_repository.dart';
import '../../data/repositories/cached_energy_repository.dart';
import '../../data/repositories/cached_smart_device_repository.dart';
import '../../data/repositories/cached_schedule_repository.dart';
import '../../data/repositories/cached_notification_repository.dart';
import '../../data/repositories/cached_graph_data_repository.dart';
import '../../data/repositories/cached_occupant_repository.dart';

// Data - HTTP Clients (для DI в repositories)
import '../../data/api/http/clients/hvac_http_client.dart';
import '../../data/api/websocket/signalr_hub_connection.dart';

final sl = GetIt.instance;

/// Feature Flag: Использовать реальное API (true) или Mock данные (false)
///
/// Установите в false для разработки UI без backend или для тестирования
/// Установите в true для работы с реальным backend (https://89.207.223.45)
const bool useRealApi = true;

/// Инициализация всех зависимостей
Future<void> init() async {
  //! Внешние зависимости (External Dependencies)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    webOptions: WebOptions(
      dbName: 'BreezApp',
      publicKey: 'BreezApp',
    ),
  );
  sl.registerLazySingleton(() => secureStorage);

  sl.registerLazySingleton(() => http.Client());

  //! Core - Основные сервисы
  sl.registerLazySingleton(() => LanguageService(sl()));
  sl.registerLazySingleton(() => ThemeService());
  sl.registerLazySingleton(() => VersionCheckService(sl()));
  sl.registerLazySingleton(() => AuthStorageService(sl()));
  await sl<LanguageService>().initializeDefaults();

  //! Auth Feature - Аутентификация (должен быть ПЕРЕД ApiClient)
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton(() => AuthBloc(
        authService: sl(),
        storageService: sl(),
      ));

  //! Offline Support - Сервисы кеширования и мониторинга сети
  sl.registerLazySingleton(() => ConnectivityService());
  sl.registerLazySingleton(() => CacheService());

  // Инициализация сервисов
  await sl<ConnectivityService>().initialize();
  await sl<CacheService>().initialize();

  //! API Client (Platform-specific: gRPC для mobile/desktop, HTTP для web)
  if (useRealApi) {
    sl.registerLazySingleton<ApiClient>(
      () => ApiClientFactory.create(
        sl<AuthStorageService>(),
        sl<AuthService>(),
      ),
    );

    //! Push Notifications - FCM сервисы
    sl.registerLazySingleton(() => PushNotificationService());
    sl.registerLazySingleton(() => FcmTokenService(
          apiClient: sl<ApiClient>(),
          pushService: sl<PushNotificationService>(),
        ));

    //! SignalR - Real-time соединение (общий для всех репозиториев)
    sl.registerLazySingleton<SignalRHubConnection>(
      () => SignalRHubConnection(sl<ApiClient>()),
    );
  }

  //! Dashboard Feature - Главный экран

  // Repositories - Условная регистрация Real или Mock (с кешированием)
  // SmartDevice Repository (Управление умными устройствами)
  if (useRealApi) {
    sl.registerLazySingleton<SmartDeviceRepository>(
      () => CachedSmartDeviceRepository(
        inner: RealSmartDeviceRepository(
          sl<ApiClient>(),
          sl<SignalRHubConnection>(), // Для fallback polling
        ),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<SmartDeviceRepository>(
      () => MockSmartDeviceRepository(),
    );
  }

  // Climate Repository (Управление климатом HVAC)
  if (useRealApi) {
    sl.registerLazySingleton<ClimateRepository>(
      () {
        final apiClient = sl<ApiClient>();
        final signalR = sl<SignalRHubConnection>();
        final realRepository = RealClimateRepository(
          apiClient,
          HvacHttpClient(apiClient),
          signalR,
        );
        // Инициализировать SignalR connection асинхронно
        realRepository.initialize();
        // Обернуть в кеширующий декоратор
        return CachedClimateRepository(
          inner: realRepository,
          cacheService: sl<CacheService>(),
          connectivity: sl<ConnectivityService>(),
        );
      },
    );
  } else {
    sl.registerLazySingleton<ClimateRepository>(
      () => MockClimateRepository(),
    );
  }

  // Energy Repository (Статистика энергопотребления)
  if (useRealApi) {
    sl.registerLazySingleton<EnergyRepository>(
      () => CachedEnergyRepository(
        inner: RealEnergyRepository(sl<ApiClient>()),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<EnergyRepository>(
      () => MockEnergyRepository(),
    );
  }

  // Occupant Repository (Управление жильцами)
  if (useRealApi) {
    sl.registerLazySingleton<OccupantRepository>(
      () => CachedOccupantRepository(
        inner: RealOccupantRepository(sl<ApiClient>()),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<OccupantRepository>(
      () => MockOccupantRepository(),
    );
  }

  // Schedule Repository (Расписания устройств)
  if (useRealApi) {
    sl.registerLazySingleton<ScheduleRepository>(
      () => CachedScheduleRepository(
        inner: RealScheduleRepository(sl<ApiClient>()),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<ScheduleRepository>(
      () => MockScheduleRepository(),
    );
  }

  // Notification Repository (Уведомления)
  if (useRealApi) {
    sl.registerLazySingleton<NotificationRepository>(
      () => CachedNotificationRepository(
        inner: RealNotificationRepository(sl<ApiClient>()),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<NotificationRepository>(
      () => MockNotificationRepository(),
    );
  }

  // GraphData Repository (Данные для графиков аналитики)
  if (useRealApi) {
    sl.registerLazySingleton<GraphDataRepository>(
      () => CachedGraphDataRepository(
        inner: RealGraphDataRepository(sl<ApiClient>()),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<GraphDataRepository>(
      () => MockGraphDataRepository(),
    );
  }

  //! Domain - Use Cases

  // Device Use Cases
  sl.registerLazySingleton(() => GetAllHvacDevices(sl()));
  sl.registerLazySingleton(() => WatchHvacDevices(sl()));
  sl.registerLazySingleton(() => RegisterDevice(sl()));
  sl.registerLazySingleton(() => DeleteDevice(sl()));
  sl.registerLazySingleton(() => RenameDevice(sl()));
  sl.registerLazySingleton(() => GetDeviceFullState(sl()));

  // Climate Use Cases
  sl.registerLazySingleton(() => GetCurrentClimateState(sl()));
  sl.registerLazySingleton(() => GetDeviceState(sl()));
  sl.registerLazySingleton(() => WatchCurrentClimate(sl()));
  sl.registerLazySingleton(() => WatchClimate(sl()));
  sl.registerLazySingleton(() => SetDevicePower(sl()));
  sl.registerLazySingleton(() => SetTemperature(sl()));
  sl.registerLazySingleton(() => SetHumidity(sl()));
  sl.registerLazySingleton(() => SetClimateMode(sl()));
  sl.registerLazySingleton(() => SetPreset(sl()));
  sl.registerLazySingleton(() => SetAirflow(sl()));

  //! Presentation - BLoCs

  // DevicesBloc (Управление списком HVAC устройств)
  sl.registerLazySingleton(
    () => DevicesBloc(
      getAllHvacDevices: sl(),
      watchHvacDevices: sl(),
      registerDevice: sl(),
      deleteDevice: sl(),
      renameDevice: sl(),
      setSelectedDevice: sl<ClimateRepository>().setSelectedDevice,
    ),
  );

  // ClimateBloc (Управление климатом текущего устройства)
  sl.registerLazySingleton(
    () => ClimateBloc(
      getCurrentClimateState: sl(),
      getDeviceState: sl(),
      getDeviceFullState: sl(),
      watchCurrentClimate: sl(),
      setDevicePower: sl(),
      setTemperature: sl(),
      setHumidity: sl(),
      setClimateMode: sl(),
      setPreset: sl(),
      setAirflow: sl(),
    ),
  );

  // NotificationsBloc (Уведомления устройств)
  sl.registerLazySingleton(
    () => NotificationsBloc(notificationRepository: sl()),
  );

  // AnalyticsBloc (Статистика и графики)
  sl.registerLazySingleton(
    () => AnalyticsBloc(
      energyRepository: sl(),
      graphDataRepository: sl(),
    ),
  );

  // ConnectivityBloc (Мониторинг сетевого соединения)
  sl.registerLazySingleton(
    () => ConnectivityBloc(connectivityService: sl()),
  );
}
