/// Dependency Injection Container
///
/// This file sets up all dependencies using get_it service locator
library;

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../services/grpc_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/cache_service.dart';
import '../services/secure_api_service.dart';
import '../services/secure_storage_service.dart';
import '../services/environment_config.dart';
import '../config/env_config.dart';

// Domain - Repositories
import '../../domain/repositories/hvac_repository.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/repositories/smart_device_repository.dart';
import '../../domain/repositories/climate_repository.dart';
import '../../domain/repositories/energy_repository.dart';
import '../../domain/repositories/occupant_repository.dart';

// Domain - Use Cases
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

// Presentation - BLoCs
import '../../presentation/bloc/hvac_list/hvac_list_bloc.dart';
import '../../presentation/bloc/hvac_detail/hvac_detail_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/statistics/statistics_bloc.dart';
import '../../presentation/bloc/dashboard/dashboard_bloc.dart';

// Data - Mock Repositories
import '../../data/repositories/mock_hvac_repository.dart';
import '../../data/repositories/mock_history_repository.dart';
import '../../data/repositories/mock_smart_device_repository.dart';
import '../../data/repositories/mock_climate_repository.dart';
import '../../data/repositories/mock_energy_repository.dart';
import '../../data/repositories/mock_occupant_repository.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // Print environment configuration
  EnvConfig.printConfig();

  //! External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Core - Services
  sl.registerLazySingleton(() => GrpcService());
  sl.registerLazySingleton(() => SecureStorageService());
  sl.registerLazySingleton(() => EnvironmentConfig.instance);
  sl.registerLazySingleton(() => SecureApiService(
    secureStorage: sl(),
    envConfig: sl(),
  ));
  sl.registerLazySingleton(() => ThemeService());
  sl.registerLazySingleton(() => LanguageService(sl()));
  await sl<LanguageService>().initializeDefaults();
  sl.registerLazySingleton(() => CacheService());

  // Initialize gRPC connection
  try {
    await sl<GrpcService>().initialize();
  } catch (e) {
    debugPrint('⚠️  gRPC initialization failed (will use Mock/REST): $e');
  }

  //! =====================================================
  //! DASHBOARD FEATURE (NEW)
  //! =====================================================
  
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

  // Dashboard BLoC
  sl.registerFactory(
    () => DashboardBloc(
      deviceRepository: sl(),
      climateRepository: sl(),
      energyRepository: sl(),
      occupantRepository: sl(),
    ),
  );

  //! =====================================================
  //! AUTH FEATURE
  //! =====================================================
  sl.registerFactory(
    () => AuthBloc(apiService: sl<SecureApiService>()),
  );

  //! =====================================================
  //! HVAC FEATURE
  //! =====================================================
  
  // Repository
  sl.registerLazySingleton<HvacRepository>(
    () => MockHvacRepository(),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => MockHistoryRepository(),
  );

  // Use cases
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

  // BLoCs
  sl.registerFactory(
    () => HvacListBloc(
      getAllUnits: sl(),
      repository: sl(),
    ),
  );

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

  // Statistics Bloc
  sl.registerFactory(
    () => StatisticsBloc(repository: sl()),
  );

  // Connect to repository
  try {
    await sl<HvacRepository>().connect();
  } catch (e) {
    debugPrint('Repository connection: $e');
  }
}
