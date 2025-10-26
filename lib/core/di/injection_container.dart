/// Dependency Injection Container
///
/// This file sets up all dependencies using get_it service locator
library;

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../services/mqtt_settings_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../config/env_config.dart';

// Data
import '../../data/datasources/mqtt_datasource.dart';
import '../../data/repositories/mock_hvac_repository.dart';
import '../../data/repositories/hvac_repository_impl.dart';

// Domain
import '../../domain/repositories/hvac_repository.dart';
import '../../domain/usecases/get_all_units.dart';
import '../../domain/usecases/get_unit_by_id.dart';
import '../../domain/usecases/update_unit.dart';
import '../../domain/usecases/get_temperature_history.dart';

// Presentation
import '../../presentation/bloc/hvac_list/hvac_list_bloc.dart';
import '../../presentation/bloc/hvac_detail/hvac_detail_bloc.dart';

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
  // Initialize theme service
  sl.registerLazySingleton(() => ThemeService());

  // Initialize language service with SharedPreferences
  sl.registerLazySingleton(() => LanguageService(sl()));

  // Initialize MQTT settings from environment or UI
  final settingsService = MqttSettingsService();
  sl.registerLazySingleton(() => settingsService);

  // Load environment settings if not already set
  if (EnvConfig.mqttBrokerHost != 'localhost' ||
      EnvConfig.mqttUsername != null) {
    settingsService.updateSettings(MqttSettings(
      host: EnvConfig.mqttBrokerHost,
      port: EnvConfig.mqttBrokerPort,
      clientId: EnvConfig.mqttClientId,
      username: EnvConfig.mqttUsername,
      password: EnvConfig.mqttPassword,
      useSsl: EnvConfig.mqttUseSsl,
    ));
  }

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
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllUnits(sl()));
  sl.registerLazySingleton(() => GetUnitById(sl()));
  sl.registerLazySingleton(() => UpdateUnit(sl()));
  sl.registerLazySingleton(() => GetTemperatureHistory(sl()));

  // Repository
  final useMqtt = EnvConfig.useMqtt;

  // Always register MqttDatasource (needed for device management)
  sl.registerLazySingleton<MqttDatasource>(() => MqttDatasource());

  if (useMqtt) {
    // MQTT Implementation
    debugPrint('Initializing MQTT mode...');
    sl.registerLazySingleton<HvacRepository>(
      () => HvacRepositoryImpl(sl()),
    );
  } else {
    // Mock Implementation (for testing)
    debugPrint('Initializing Mock mode...');
    sl.registerLazySingleton<HvacRepository>(
      () => MockHvacRepository(),
    );
  }

  // Connect to repository
  try {
    await sl<HvacRepository>().connect();
  } catch (e) {
    debugPrint('Failed to connect to repository: $e');
    // If MQTT fails, app will show error state
    // User can still see the UI
  }
}
