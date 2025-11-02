/// Dependency Injection Container - Clean Architecture Version
///
/// Refactored dependency injection following clean architecture principles
/// Proper layer separation and dependency flow
library;

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core Services
import '../services/api_service.dart';
import '../services/grpc_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/cache_service.dart';
import '../config/env_config.dart';

// Domain - Repositories (Interfaces)
import '../../domain/repositories/hvac_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/device_repository.dart';

// Domain - Use Cases - Authentication
import '../../domain/usecases/auth/login.dart';
import '../../domain/usecases/auth/logout.dart';
import '../../domain/usecases/auth/register.dart';
import '../../domain/usecases/auth/check_auth_status.dart';
import '../../domain/usecases/auth/skip_auth.dart';

// Domain - Use Cases - Device Management
import '../../domain/usecases/device/add_device.dart';
import '../../domain/usecases/device/remove_device.dart';
import '../../domain/usecases/device/connect_to_devices.dart';
import '../../domain/usecases/device/disconnect_from_devices.dart';
import '../../domain/usecases/device/scan_for_devices.dart';

// Domain - Use Cases - HVAC Operations
import '../../domain/usecases/get_all_units.dart';
import '../../domain/usecases/get_unit_by_id.dart';
import '../../domain/usecases/update_unit.dart';
import '../../domain/usecases/get_temperature_history.dart';
import '../../domain/usecases/update_ventilation_mode.dart';
import '../../domain/usecases/update_fan_speeds.dart';
import '../../domain/usecases/update_schedule.dart';
import '../../domain/usecases/apply_preset.dart';
import '../../domain/usecases/group_power_control.dart';
import '../../domain/usecases/sync_settings_to_all.dart';
import '../../domain/usecases/apply_schedule_to_all.dart';

// Data - Repository Implementations
import '../../data/repositories/mock_hvac_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/device_repository_impl.dart';

// Presentation - BLoCs (Refactored versions)
import '../../presentation/bloc/auth/auth_bloc_refactored.dart' as auth_bloc;
import '../../presentation/bloc/hvac_list/hvac_list_bloc_refactored.dart';
import '../../presentation/bloc/hvac_detail/hvac_detail_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies with proper layer separation
Future<void> init() async {
  // Print environment configuration
  EnvConfig.printConfig();

  //! ============================================================================
  //! External Dependencies
  //! ============================================================================

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! ============================================================================
  //! Core Services (Infrastructure Layer)
  //! ============================================================================

  // gRPC Service for device communication
  sl.registerLazySingleton(() => GrpcService());

  // REST API Service
  sl.registerLazySingleton(() => ApiService(sl()));

  // Theme Service for app theming
  sl.registerLazySingleton(() => ThemeService());

  // Language Service for internationalization
  sl.registerLazySingleton(() => LanguageService(sl()));

  // Cache Service for local caching
  sl.registerLazySingleton(() => CacheService());

  // Initialize gRPC connection (non-critical, can fail)
  try {
    await sl<GrpcService>().initialize();
  } catch (e) {
    debugPrint('⚠️ gRPC initialization failed (will use Mock/REST): $e');
  }

  //! ============================================================================
  //! Data Layer - Repository Implementations
  //! ============================================================================

  // Authentication Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: sl(),
      prefs: sl(),
    ),
  );

  // HVAC Repository (using Mock for now, replace with real implementation)
  sl.registerLazySingleton<HvacRepository>(
    () => MockHvacRepository(),
  );

  // Device Repository
  sl.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      apiService: sl(),
      hvacRepository: sl(),
    ),
  );

  //! ============================================================================
  //! Domain Layer - Use Cases
  //! ============================================================================

  // Authentication Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => const SkipAuth());

  // Device Management Use Cases
  sl.registerLazySingleton(() => AddDevice(sl()));
  sl.registerLazySingleton(() => RemoveDevice(sl()));
  sl.registerLazySingleton(() => ConnectToDevices(sl()));
  sl.registerLazySingleton(() => DisconnectFromDevices(sl()));
  sl.registerLazySingleton(() => ScanForDevices(sl()));

  // HVAC Operations Use Cases
  sl.registerLazySingleton(() => GetAllUnits(sl()));
  sl.registerLazySingleton(() => GetUnitById(sl()));
  // ignore: deprecated_member_use_from_same_package
  sl.registerLazySingleton(() => UpdateUnit(sl()));
  sl.registerLazySingleton(() => GetTemperatureHistory(sl()));
  sl.registerLazySingleton(() => UpdateVentilationMode(sl()));
  sl.registerLazySingleton(() => UpdateFanSpeeds(sl()));
  sl.registerLazySingleton(() => UpdateSchedule(sl()));
  sl.registerLazySingleton(() => ApplyPreset(sl()));
  sl.registerLazySingleton(() => GroupPowerControl(sl()));
  sl.registerLazySingleton(() => SyncSettingsToAll(sl()));
  sl.registerLazySingleton(() => ApplyScheduleToAll(sl()));

  //! ============================================================================
  //! Presentation Layer - BLoCs
  //! ============================================================================

  // Auth BLoC - Using clean architecture version
  sl.registerFactory(
    () => auth_bloc.AuthBloc(
      login: sl(),
      logout: sl(),
      register: sl(),
      checkAuthStatus: sl(),
      skipAuth: sl(),
    ),
  );

  // HVAC List BLoC - Using clean architecture version
  sl.registerFactory(
    () => HvacListBloc(
      getAllUnits: sl(),
      addDevice: sl(),
      removeDevice: sl(),
      connectToDevices: sl(),
    ),
  );

  // HVAC Detail BLoC - With parameters
  sl.registerFactoryParam<HvacDetailBloc, String, void>(
    (unitId, _) => HvacDetailBloc(
      unitId: unitId,
      getUnitById: sl(),
      updateUnit: sl(),
      getTemperatureHistory: sl(),
      updateVentilationMode: sl(),
      updateFanSpeeds: sl(),
      updateSchedule: sl(),
    ),
  );

  //! ============================================================================
  //! Initialization
  //! ============================================================================

  // Connect to repository (for compatibility with existing code)
  try {
    await sl<HvacRepository>().connect();
  } catch (e) {
    debugPrint('Repository connection: $e');
  }
}

/// Clean up resources and connections
Future<void> dispose() async {
  try {
    // Disconnect from device communication system
    await sl<DeviceRepository>().disconnect();
    await sl<HvacRepository>().disconnect();
  } catch (e) {
    debugPrint('Cleanup error: $e');
  }
}

/// Reset all registrations (useful for testing)
void reset() {
  sl.reset();
}