import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Domain - Repositories (интерфейсы)
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/climate_repository.dart';
import '../../domain/repositories/energy_repository.dart';
import '../../domain/repositories/home_repository.dart';

// Data - Mock Repositories
import '../../data/repositories/mock_device_repository.dart';
import '../../data/repositories/mock_climate_repository.dart';
import '../../data/repositories/mock_energy_repository.dart';
import '../../data/repositories/mock_home_repository.dart';

// Application - BLoCs
import '../../application/blocs/devices_cubit.dart';
import '../../application/blocs/climate_cubit.dart';
import '../../application/blocs/energy_cubit.dart';
import '../../application/blocs/home_cubit.dart';

/// Провайдер зависимостей — внедряет репозитории и BLoC'и
class AppProviders extends StatelessWidget {
  final Widget child;
  
  /// Используем моки (true) или реальный бэкенд (false)
  final bool useMocks;

  const AppProviders({
    super.key,
    required this.child,
    this.useMocks = true, // По умолчанию моки!
  });

  @override
  Widget build(BuildContext context) {
    // Создаём репозитории
    final DeviceRepository deviceRepo = useMocks 
        ? MockDeviceRepository() 
        : MockDeviceRepository(); // TODO: заменить на RealDeviceRepository

    final ClimateRepository climateRepo = useMocks 
        ? MockClimateRepository() 
        : MockClimateRepository(); // TODO: заменить на RealClimateRepository

    final EnergyRepository energyRepo = useMocks 
        ? MockEnergyRepository() 
        : MockEnergyRepository(); // TODO: заменить на RealEnergyRepository

    final HomeRepository homeRepo = useMocks 
        ? MockHomeRepository() 
        : MockHomeRepository(); // TODO: заменить на RealHomeRepository

    // Внедряем BLoC'и
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DeviceRepository>.value(value: deviceRepo),
        RepositoryProvider<ClimateRepository>.value(value: climateRepo),
        RepositoryProvider<EnergyRepository>.value(value: energyRepo),
        RepositoryProvider<HomeRepository>.value(value: homeRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DevicesCubit(deviceRepo)..loadDevices(),
          ),
          BlocProvider(
            create: (context) => ClimateCubit(climateRepo)..loadClimate(),
          ),
          BlocProvider(
            create: (context) => EnergyCubit(energyRepo)..loadTodayStats(),
          ),
          BlocProvider(
            create: (context) => HomeCubit(homeRepo)..loadHome(),
          ),
        ],
        child: child,
      ),
    );
  }
}

/// Extension для удобного доступа к Cubit'ам
extension BlocContextExtension on BuildContext {
  DevicesCubit get devicesCubit => read<DevicesCubit>();
  ClimateCubit get climateCubit => read<ClimateCubit>();
  EnergyCubit get energyCubit => read<EnergyCubit>();
  HomeCubit get homeCubit => read<HomeCubit>();
}
