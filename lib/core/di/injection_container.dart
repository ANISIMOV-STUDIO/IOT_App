/// Dependency Injection Container
///
/// This file sets up all dependencies using get_it service locator
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// Core
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../services/version_check_service.dart';
import '../services/auth_storage_service.dart';

// Data - Services
import '../../data/services/auth_service.dart';

// Domain - Repositories
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

// Data - Mock Repositories
import '../../data/repositories/mock_climate_repository.dart';
import '../../data/repositories/mock_energy_repository.dart';
import '../../data/repositories/mock_smart_device_repository.dart';
import '../../data/repositories/mock_occupant_repository.dart';
import '../../data/repositories/mock_schedule_repository.dart';
import '../../data/repositories/mock_notification_repository.dart';
import '../../data/repositories/mock_graph_data_repository.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  //! External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  sl.registerLazySingleton(() => secureStorage);

  sl.registerLazySingleton(() => http.Client());

  //! Core - Services
  sl.registerLazySingleton(() => LanguageService(sl()));
  sl.registerLazySingleton(() => ThemeService());
  sl.registerLazySingleton(() => VersionCheckService(sl()));
  sl.registerLazySingleton(() => AuthStorageService(sl()));
  await sl<LanguageService>().initializeDefaults();

  //! Auth Feature
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerFactory(() => AuthBloc(
        authService: sl(),
        storageService: sl(),
      ));

  //! Dashboard Feature

  // Repositories - Mock implementations
  sl.registerLazySingleton<SmartDeviceRepository>(
    () => MockSmartDeviceRepository(),
  );
  sl.registerLazySingleton<ClimateRepository>(
    () => MockClimateRepository(),
  );
  sl.registerLazySingleton<EnergyRepository>(
    () => MockEnergyRepository(),
  );
  sl.registerLazySingleton<OccupantRepository>(
    () => MockOccupantRepository(),
  );
  sl.registerLazySingleton<ScheduleRepository>(
    () => MockScheduleRepository(),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => MockNotificationRepository(),
  );
  sl.registerLazySingleton<GraphDataRepository>(
    () => MockGraphDataRepository(),
  );

  // Dashboard BLoC
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
