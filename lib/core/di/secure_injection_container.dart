/// Secure Dependency Injection Container
///
/// Enhanced dependency injection with security services
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Services
import '../services/api_service.dart';
import '../services/secure_api_service.dart';
import '../services/secure_storage_service.dart';
import '../services/environment_config.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../utils/logger.dart';

// BLoCs
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/auth/secure_auth_bloc.dart';
// import '../../presentation/bloc/hvac_list/hvac_list_bloc.dart'; // Not used

// Repositories
// import '../../data/repositories/hvac_repository.dart'; // File doesn't exist
// import '../../data/repositories/analytics_repository.dart'; // File doesn't exist

// Use Cases
// import '../../domain/usecases/get_hvac_units.dart'; // File doesn't exist
// import '../../domain/usecases/control_hvac_unit.dart'; // File doesn't exist

final sl = GetIt.instance;

/// Initialize all dependencies with security enhancements
Future<void> init() async {
  // Initialize environment configuration first
  await EnvironmentConfig.initialize();

  //! External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());

  //! Core Services

  // Security Services
  sl.registerLazySingleton(() => SecureStorageService());
  sl.registerLazySingleton(() => EnvironmentConfig.instance);

  // API Services (use secure version)
  sl.registerLazySingleton<SecureApiService>(
    () => SecureApiService(
      secureStorage: sl(),
      envConfig: sl(),
    ),
  );

  // Legacy API Service (for backward compatibility)
  sl.registerLazySingleton<ApiService>(
    () => ApiService(sl()),
  );

  // Theme & Language Services
  sl.registerLazySingleton(() => ThemeService());
  sl.registerLazySingleton(() => LanguageService(sl()));

  //! Repositories
  // Commented out - files don't exist
  // sl.registerLazySingleton<HvacRepository>(
  //   () => HvacRepository(apiService: sl<ApiService>()),
  // );

  // sl.registerLazySingleton<AnalyticsRepository>(
  //   () => AnalyticsRepository(),
  // );

  //! Use Cases
  // Commented out - files don't exist
  // sl.registerLazySingleton(() => GetHvacUnits(sl()));
  // sl.registerLazySingleton(() => ControlHvacUnit(sl()));

  //! BLoCs

  // Use secure auth bloc
  sl.registerFactory<SecureAuthBloc>(
    () => SecureAuthBloc(
      apiService: sl<SecureApiService>(),
      secureStorage: sl<SecureStorageService>(),
    ),
  );

  // Register as AuthBloc for backward compatibility
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(apiService: sl<ApiService>()),
  );

  // Commented out - references non-existent use cases
  // sl.registerFactory(
  //   () => HvacListBloc(
  //     getHvacUnits: sl(),
  //     controlHvacUnit: sl(),
  //   ),
  // );

  // Initialize services that need early setup
  await _initializeServices();
}

/// Initialize services that require early setup
Future<void> _initializeServices() async {
  // Check if secure storage is available
  final secureStorage = sl<SecureStorageService>();
  final isAvailable = await secureStorage.isStorageAvailable();

  if (!isAvailable) {
    // Log warning but don't crash - fallback will be used
    Logger.warning('Secure storage not available on this device');
  }

  // Load theme and language preferences
  // ThemeService doesn't have a loadTheme method - it initializes in constructor
  // await sl<ThemeService>().loadTheme();
  // LanguageService loads saved language in constructor, not a separate method
  // await sl<LanguageService>().loadSavedLanguage();
}