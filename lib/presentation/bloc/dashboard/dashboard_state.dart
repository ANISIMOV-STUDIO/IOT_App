part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<SmartDevice> devices;
  final ClimateState? climate;
  final EnergyStats? energyStats;
  final List<DeviceEnergyUsage> powerUsage;
  final List<Occupant> occupants;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.devices = const [],
    this.climate,
    this.energyStats,
    this.powerUsage = const [],
    this.occupants = const [],
    this.errorMessage,
  });

  // Helpers
  AirQualityLevel? get airQuality => climate?.airQuality;
  int? get co2Ppm => climate?.co2Ppm;
  int? get pollutantsAqi => climate?.pollutantsAqi;

  DashboardState copyWith({
    DashboardStatus? status,
    List<SmartDevice>? devices,
    ClimateState? climate,
    EnergyStats? energyStats,
    List<DeviceEnergyUsage>? powerUsage,
    List<Occupant>? occupants,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      climate: climate ?? this.climate,
      energyStats: energyStats ?? this.energyStats,
      powerUsage: powerUsage ?? this.powerUsage,
      occupants: occupants ?? this.occupants,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, devices, climate, energyStats, powerUsage, occupants, errorMessage];
}
