/// Dependency Injection Container
///
/// This file sets up all dependencies using get_it service locator
library;

import 'package:get_it/get_it.dart';

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

/// Toggle between Mock and MQTT implementation
/// Set to true to use MQTT, false to use Mock data
const bool useMqtt = false;

/// Initialize all dependencies
Future<void> init() async {
  //! Features - HVAC
  // Bloc
  sl.registerFactory(
    () => HvacListBloc(
      getAllUnits: sl(),
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
  if (useMqtt) {
    // MQTT Implementation (Phase 5)
    sl.registerLazySingleton<MqttDatasource>(() => MqttDatasource());
    sl.registerLazySingleton<HvacRepository>(
      () => HvacRepositoryImpl(sl()),
    );
  } else {
    // Mock Implementation (for testing)
    sl.registerLazySingleton<HvacRepository>(
      () => MockHvacRepository(),
    );
  }

  // Connect to repository
  try {
    await sl<HvacRepository>().connect();
  } catch (e) {
    print('Failed to connect to repository: $e');
    // If MQTT fails, app will show error state
    // User can still see the UI
  }
}
