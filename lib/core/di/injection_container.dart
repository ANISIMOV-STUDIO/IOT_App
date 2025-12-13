/// Dependency Injection Container
///
/// This file sets up all dependencies using get_it service locator
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../services/language_service.dart';

// Domain - Repositories
import '../../domain/repositories/climate_repository.dart';
import '../../domain/repositories/energy_repository.dart';
import '../../domain/repositories/smart_device_repository.dart';
import '../../domain/repositories/occupant_repository.dart';

// Presentation - BLoCs
import '../../presentation/bloc/dashboard/dashboard_bloc.dart';

// Data - Mock Repositories
import '../../data/repositories/mock_climate_repository.dart';
import '../../data/repositories/mock_energy_repository.dart';
import '../../data/repositories/mock_smart_device_repository.dart';
import '../../data/repositories/mock_occupant_repository.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  //! External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  //! Core - Services
  sl.registerLazySingleton(() => LanguageService(sl()));
  await sl<LanguageService>().initializeDefaults();

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

  // Dashboard BLoC
  sl.registerFactory(
    () => DashboardBloc(
      deviceRepository: sl(),
      climateRepository: sl(),
      energyRepository: sl(),
      occupantRepository: sl(),
    ),
  );
}
