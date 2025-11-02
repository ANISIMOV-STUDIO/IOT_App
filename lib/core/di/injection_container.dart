/// Dependency Injection Container
///
/// This file sets up all dependencies using get_it service locator
library;

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../services/api_service.dart';
import '../services/grpc_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/cache_service.dart';
import '../config/env_config.dart';

// Data
import '../../data/repositories/mock_hvac_repository.dart';

// Domain
import '../../domain/repositories/hvac_repository.dart';
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

// Presentation
import '../../presentation/bloc/hvac_list/hvac_list_bloc.dart';
import '../../presentation/bloc/hvac_detail/hvac_detail_bloc.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // Print environment configuration
  EnvConfig.printConfig();

  //! External Dependencies
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Core - Services
  // Initialize gRPC service
  sl.registerLazySingleton(() => GrpcService());

  // Initialize API service (REST)
  sl.registerLazySingleton(() => ApiService(sl()));

  // Initialize theme service
  sl.registerLazySingleton(() => ThemeService());

  // Initialize language service with SharedPreferences
  sl.registerLazySingleton(() => LanguageService(sl()));

  // Initialize cache service
  sl.registerLazySingleton(() => CacheService());

  // Initialize gRPC connection
  try {
    await sl<GrpcService>().initialize();
  } catch (e) {
    debugPrint('⚠️  gRPC initialization failed (will use Mock/REST): $e');
  }

  //! Features - Auth
  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(apiService: sl()),
  );

  //! Features - HVAC
  // Bloc
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

  // Repository - Using Mock for now, will be replaced with REST implementation
  sl.registerLazySingleton<HvacRepository>(
    () => MockHvacRepository(),
  );

  // Connect to repository (for compatibility)
  try {
    await sl<HvacRepository>().connect();
  } catch (e) {
    debugPrint('Repository connection: $e');
  }
}
