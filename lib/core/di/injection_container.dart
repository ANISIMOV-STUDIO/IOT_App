/// Контейнер внедрения зависимостей (Dependency Injection)
///
/// Настройка всех зависимостей с использованием get_it service locator
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/core/services/cache_service.dart';
import 'package:hvac_control/core/services/connectivity_service.dart';
import 'package:hvac_control/core/services/fcm_token_service.dart';
// Core - Основные сервисы
import 'package:hvac_control/core/services/language_service.dart';
import 'package:hvac_control/core/services/push_notification_service.dart';
import 'package:hvac_control/core/services/theme_service.dart';
import 'package:hvac_control/core/services/token_refresh_service.dart';
import 'package:hvac_control/core/services/version_check_service.dart';
// Data - HTTP Clients (для DI в repositories)
import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/data/api/http/clients/user_http_client.dart';
// Data - API Client (Platform-specific)
import 'package:hvac_control/data/api/platform/api_client.dart';
import 'package:hvac_control/data/api/platform/api_client_factory.dart';
import 'package:hvac_control/data/api/websocket/signalr_hub_connection.dart';
// Data - DataSources (Strategy Pattern: HTTP/gRPC в зависимости от платформы)
import 'package:hvac_control/data/datasources/analytics/analytics_data_source.dart';
import 'package:hvac_control/data/datasources/analytics/analytics_data_source_factory.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source.dart';
import 'package:hvac_control/data/datasources/notification/notification_data_source_factory.dart';
// Data - Cached репозитории (offline поддержка)
import 'package:hvac_control/data/repositories/cached_climate_repository.dart';
import 'package:hvac_control/data/repositories/cached_energy_repository.dart';
import 'package:hvac_control/data/repositories/cached_graph_data_repository.dart';
import 'package:hvac_control/data/repositories/cached_notification_repository.dart';
import 'package:hvac_control/data/repositories/cached_schedule_repository.dart';
import 'package:hvac_control/data/repositories/cached_smart_device_repository.dart';
// Data - Mock репозитории (для разработки/тестирования)
import 'package:hvac_control/data/repositories/mock_climate_repository.dart';
import 'package:hvac_control/data/repositories/mock_energy_repository.dart';
import 'package:hvac_control/data/repositories/mock_graph_data_repository.dart';
import 'package:hvac_control/data/repositories/mock_notification_repository.dart';
import 'package:hvac_control/data/repositories/mock_schedule_repository.dart';
import 'package:hvac_control/data/repositories/mock_smart_device_repository.dart';
// Data - Real репозитории (реальное API)
import 'package:hvac_control/data/repositories/real_climate_repository.dart';
import 'package:hvac_control/data/repositories/real_energy_repository.dart';
import 'package:hvac_control/data/repositories/real_graph_data_repository.dart';
import 'package:hvac_control/data/repositories/real_notification_repository.dart';
import 'package:hvac_control/data/repositories/real_schedule_repository.dart';
import 'package:hvac_control/data/repositories/real_smart_device_repository.dart';
// Data - Сервисы данных
import 'package:hvac_control/data/services/auth_service.dart';
// Domain - Интерфейсы репозиториев
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/domain/repositories/energy_repository.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';
import 'package:hvac_control/domain/repositories/notification_repository.dart';
import 'package:hvac_control/domain/repositories/schedule_repository.dart';
import 'package:hvac_control/domain/repositories/smart_device_repository.dart';
// Domain - Use Cases
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
// Presentation - BLoCs
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:hvac_control/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

/// Feature Flag: Использовать реальное API (true) или Mock данные (false)
///
/// Установите в false для разработки UI без backend или для тестирования
/// Установите в true для работы с реальным backend (https://89.207.223.45)
const bool useRealApi = true;

/// Инициализация всех зависимостей
Future<void> init() async {
  // Hot restart cleanup: сбрасываем stateful singletons
  // чтобы старые BLoC не продолжали получать события
  await _resetStatefulSingletons();

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
  sl..registerLazySingleton(() => secureStorage)

  ..registerLazySingleton(http.Client.new)

  //! Core - Основные сервисы
  ..registerLazySingleton(() => LanguageService(sl()))
  ..registerLazySingleton(ThemeService.new)
  ..registerLazySingleton(() => AuthStorageService(sl()));

  await sl<LanguageService>().initializeDefaults();

  //! Auth Feature - Аутентификация (должен быть ПЕРЕД ApiClient)
  sl
    ..registerLazySingleton(() => AuthService(sl()))
    ..registerLazySingleton(() => TokenRefreshService(
          authStorage: sl(),
          authService: sl(),
        ))

    //! Offline Support - Сервисы кеширования и мониторинга сети
    ..registerLazySingleton(ConnectivityService.new)
    ..registerLazySingleton(CacheService.new);

  // Инициализация сервисов
  await sl<ConnectivityService>().initialize();
  await sl<CacheService>().initialize();

  //! API Client (Platform-specific: gRPC для mobile/desktop, HTTP для web)
  if (useRealApi) {
    sl..registerLazySingleton<ApiClient>(
      () => ApiClientFactory.create(
        sl<AuthStorageService>(),
        sl<AuthService>(),
      ),
    )

    //! Push Notifications - FCM сервисы
    ..registerLazySingleton(
      PushNotificationService.new,
      dispose: (s) => s.dispose(),
    )
    ..registerLazySingleton(() => FcmTokenService(
          apiClient: sl<ApiClient>(),
          pushService: sl<PushNotificationService>(),
        ))

    //! SignalR - Real-time соединение (общий для всех репозиториев)
    ..registerLazySingleton<SignalRHubConnection>(
      () => SignalRHubConnection(sl<ApiClient>()),
      dispose: (s) => s.dispose(),
    )

    //! VersionCheckService - с SignalR для real-time обновлений
    ..registerLazySingleton(
      () => VersionCheckService(sl<http.Client>(), sl<SignalRHubConnection>()),
      dispose: (s) => s.dispose(),
    );
  } else {
    //! VersionCheckService - только HTTP polling (без SignalR)
    sl.registerLazySingleton(
      () => VersionCheckService(sl<http.Client>()),
      dispose: (s) => s.dispose(),
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
      MockSmartDeviceRepository.new,
    );
  }

  // HVAC HTTP Client (для прямых вызовов API)
  if (useRealApi) {
    sl
      ..registerLazySingleton<HvacHttpClient>(
        () => HvacHttpClient(sl<ApiClient>()),
      )
      // User HTTP Client (настройки пользователя)
      ..registerLazySingleton<UserHttpClient>(
        () => UserHttpClient(sl<ApiClient>()),
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
          sl<HvacHttpClient>(),
          signalR,
        )
        // Инициализировать SignalR connection асинхронно
        ..initialize();
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
      MockClimateRepository.new,
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
      MockEnergyRepository.new,
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
      MockScheduleRepository.new,
    );
  }

  // DataSources - автоматический выбор HTTP/gRPC в зависимости от платформы
  if (useRealApi) {
    sl..registerLazySingleton<AnalyticsDataSource>(
      () => AnalyticsDataSourceFactory.create(sl<ApiClient>()),
    )
    ..registerLazySingleton<NotificationDataSource>(
      () => NotificationDataSourceFactory.create(sl<ApiClient>()),
    );
  }

  // Notification Repository (Уведомления с gRPC streaming / SignalR fallback)
  if (useRealApi) {
    sl.registerLazySingleton<NotificationRepository>(
      () => CachedNotificationRepository(
        inner: RealNotificationRepository(
          sl<NotificationDataSource>(),
          sl<SignalRHubConnection>(), // Fallback для web
        ),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<NotificationRepository>(
      MockNotificationRepository.new,
    );
  }

  // GraphData Repository (Данные для графиков - gRPC на mobile, HTTP на web)
  if (useRealApi) {
    sl.registerLazySingleton<GraphDataRepository>(
      () => CachedGraphDataRepository(
        inner: RealGraphDataRepository(sl<AnalyticsDataSource>()),
        cacheService: sl<CacheService>(),
        connectivity: sl<ConnectivityService>(),
      ),
    );
  } else {
    sl.registerLazySingleton<GraphDataRepository>(
      MockGraphDataRepository.new,
    );
  }

  //! Domain - Use Cases

  // Device Use Cases
  sl..registerLazySingleton(() => GetAllHvacDevices(sl()))
  ..registerLazySingleton(() => WatchHvacDevices(sl()))
  ..registerLazySingleton(() => RegisterDevice(sl()))
  ..registerLazySingleton(() => DeleteDevice(sl()))
  ..registerLazySingleton(() => RenameDevice(sl()))
  ..registerLazySingleton(() => SetDeviceTime(sl()))
  ..registerLazySingleton(() => RequestDeviceUpdate(sl()))
  ..registerLazySingleton(() => GetDeviceFullState(sl()))
  ..registerLazySingleton(() => GetAlarmHistory(sl()))
  ..registerLazySingleton(() => ResetAlarm(sl()))
  ..registerLazySingleton(() => WatchDeviceFullState(sl<ClimateRepository>()))

  // Climate Use Cases
  ..registerLazySingleton(() => GetCurrentClimateState(sl()))
  ..registerLazySingleton(() => GetDeviceState(sl()))
  ..registerLazySingleton(() => WatchCurrentClimate(sl()))
  ..registerLazySingleton(() => SetDevicePower(sl()))
  ..registerLazySingleton(() => SetTemperature(sl()))
  ..registerLazySingleton(() => SetCoolingTemperature(sl()))
  ..registerLazySingleton(() => SetHumidity(sl()))
  ..registerLazySingleton(() => SetClimateMode(sl()))
  ..registerLazySingleton(() => SetOperatingMode(sl()))
  ..registerLazySingleton(() => SetPreset(sl()))
  ..registerLazySingleton(() => SetAirflow(sl()))
  ..registerLazySingleton(() => SetScheduleEnabled(sl<ScheduleRepository>()))
  ..registerLazySingleton(() => SetModeSettings(sl()))
  ..registerLazySingleton(() => SetQuickMode(sl()))

  // Analytics Use Cases
  ..registerLazySingleton(() => GetTodayStats(sl()))
  ..registerLazySingleton(() => GetDevicePowerUsage(sl()))
  ..registerLazySingleton(() => WatchEnergyStats(sl()))
  ..registerLazySingleton(() => GetGraphData(sl()))
  ..registerLazySingleton(() => WatchGraphData(sl()))

  // Notifications Use Cases
  ..registerLazySingleton(() => GetNotifications(sl()))
  ..registerLazySingleton(() => WatchNotifications(sl()))
  ..registerLazySingleton(() => MarkNotificationAsRead(sl()))
  ..registerLazySingleton(() => DismissNotification(sl()))

  //! Presentation - BLoCs

  // AuthBloc (Аутентификация - регистрируется здесь чтобы иметь доступ к UserHttpClient)
  ..registerLazySingleton(
    () => AuthBloc(
      authService: sl(),
      storageService: sl(),
      tokenRefreshService: sl(),
      userHttpClient: useRealApi ? sl<UserHttpClient>() : null,
    ),
    dispose: (b) => b.close(),
  )

  // DevicesBloc (Управление списком HVAC устройств)
  ..registerLazySingleton(
    () => DevicesBloc(
      getAllHvacDevices: sl(),
      watchHvacDevices: sl(),
      registerDevice: sl(),
      deleteDevice: sl(),
      renameDevice: sl(),
      setDevicePower: sl(),
      setDeviceTime: sl(),
      setScheduleEnabled: sl(),
      setSelectedDevice: sl<ClimateRepository>().setSelectedDevice,
    ),
    dispose: (b) => b.close(),
  )

  // ClimateBloc (Управление климатом текущего устройства)
  ..registerLazySingleton(
    () => ClimateBloc(
      getCurrentClimateState: sl(),
      getDeviceFullState: sl(),
      getAlarmHistory: sl(),
      resetAlarm: sl(),
      watchCurrentClimate: sl(),
      setDevicePower: sl(),
      setTemperature: sl(),
      setCoolingTemperature: sl(),
      setHumidity: sl(),
      setClimateMode: sl(),
      setOperatingMode: sl(),
      setPreset: sl(),
      setAirflow: sl(),
      setScheduleEnabled: sl(),
      setModeSettings: sl(),
      watchDeviceFullState: sl(),
      requestDeviceUpdate: sl(),
      setQuickMode: sl(),
    ),
    dispose: (b) => b.close(),
  )

  // NotificationsBloc (Уведомления устройств)
  ..registerLazySingleton(
    () => NotificationsBloc(
      getNotifications: sl(),
      watchNotifications: sl(),
      markNotificationAsRead: sl(),
      dismissNotification: sl(),
    ),
    dispose: (b) => b.close(),
  )

  // AnalyticsBloc (Статистика и графики)
  ..registerLazySingleton(
    () => AnalyticsBloc(
      getTodayStats: sl(),
      getDevicePowerUsage: sl(),
      watchEnergyStats: sl(),
      getGraphData: sl(),
      watchGraphData: sl(),
    ),
    dispose: (b) => b.close(),
  )

  // ConnectivityBloc (Мониторинг сетевого соединения)
  ..registerLazySingleton(
    () => ConnectivityBloc(connectivityService: sl()),
    dispose: (b) => b.close(),
  )

  // ScheduleBloc (Расписание устройств)
  ..registerLazySingleton(
    () => ScheduleBloc(repository: sl()),
    dispose: (b) => b.close(),
  );
}

/// Сброс stateful singletons при hot restart
///
/// При hot restart старые BLoC не получают dispose и продолжают
/// получать события от SignalR, что приводит к ошибкам рендеринга.
Future<void> _resetStatefulSingletons() async {
  // Сбрасываем BLoC с подписками на streams
  if (sl.isRegistered<ClimateBloc>()) {
    final bloc = sl<ClimateBloc>();
    await bloc.close();
    await sl.resetLazySingleton<ClimateBloc>();
  }

  if (sl.isRegistered<NotificationsBloc>()) {
    final bloc = sl<NotificationsBloc>();
    await bloc.close();
    await sl.resetLazySingleton<NotificationsBloc>();
  }

  if (sl.isRegistered<AnalyticsBloc>()) {
    final bloc = sl<AnalyticsBloc>();
    await bloc.close();
    await sl.resetLazySingleton<AnalyticsBloc>();
  }

  if (sl.isRegistered<ScheduleBloc>()) {
    final bloc = sl<ScheduleBloc>();
    await bloc.close();
    await sl.resetLazySingleton<ScheduleBloc>();
  }

  // Сбрасываем ClimateRepository (содержит подписки на SignalR)
  if (sl.isRegistered<ClimateRepository>()) {
    final repo = sl<ClimateRepository>();
    await repo.dispose();
    await sl.resetLazySingleton<ClimateRepository>();
  }

  // Сбрасываем SignalR соединение
  if (sl.isRegistered<SignalRHubConnection>()) {
    final signalR = sl<SignalRHubConnection>();
    await signalR.dispose();
    await sl.resetLazySingleton<SignalRHubConnection>();
  }
}
