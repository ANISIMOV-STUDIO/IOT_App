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
import '../../presentation/bloc/dashboard/dashboard_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

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
  sl.registerFactory(() => AuthBloc(
        authService: sl(),
        storageService: sl(),
      ));

  //! API Client (Platform-specific: gRPC для mobile/desktop, HTTP для web)
  if (useRealApi) {
    sl.registerLazySingleton<ApiClient>(
      () => ApiClientFactory.create(
        sl<AuthStorageService>(),
        sl<AuthService>(),
      ),
    );
  }

  //! Dashboard Feature - Главный экран

  // Repositories - Условная регистрация Real или Mock
  // SmartDevice Repository (Управление умными устройствами)
  if (useRealApi) {
    sl.registerLazySingleton<SmartDeviceRepository>(
      () => RealSmartDeviceRepository(sl<ApiClient>()),
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
        final repository = RealClimateRepository(
          apiClient,
          HvacHttpClient(apiClient),
          SignalRHubConnection(apiClient),
        );
        // Инициализировать SignalR connection асинхронно
        repository.initialize();
        return repository;
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
      () => RealEnergyRepository(sl<ApiClient>()),
    );
  } else {
    sl.registerLazySingleton<EnergyRepository>(
      () => MockEnergyRepository(),
    );
  }

  // Occupant Repository (Управление жильцами)
  if (useRealApi) {
    sl.registerLazySingleton<OccupantRepository>(
      () => RealOccupantRepository(sl<ApiClient>()),
    );
  } else {
    sl.registerLazySingleton<OccupantRepository>(
      () => MockOccupantRepository(),
    );
  }

  // Schedule Repository (Расписания устройств)
  if (useRealApi) {
    sl.registerLazySingleton<ScheduleRepository>(
      () => RealScheduleRepository(sl<ApiClient>()),
    );
  } else {
    sl.registerLazySingleton<ScheduleRepository>(
      () => MockScheduleRepository(),
    );
  }

  // Notification Repository (Уведомления)
  if (useRealApi) {
    sl.registerLazySingleton<NotificationRepository>(
      () => RealNotificationRepository(sl<ApiClient>()),
    );
  } else {
    sl.registerLazySingleton<NotificationRepository>(
      () => MockNotificationRepository(),
    );
  }

  // GraphData Repository (Данные для графиков аналитики)
  if (useRealApi) {
    sl.registerLazySingleton<GraphDataRepository>(
      () => RealGraphDataRepository(sl<ApiClient>()),
    );
  } else {
    sl.registerLazySingleton<GraphDataRepository>(
      () => MockGraphDataRepository(),
    );
  }

  // Dashboard BLoC (Главный экран с виджетами)
  sl.registerFactory(
    () => DashboardBloc(
      deviceRepository: sl(),
      climateRepository: sl(),
      energyRepository: sl(),
      occupantRepository: sl(),
      scheduleRepository: sl(),
      notificationRepository: sl(),
      graphDataRepository: sl(),
    ),
  );
}
