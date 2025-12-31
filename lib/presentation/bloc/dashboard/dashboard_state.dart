part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

/// Элемент расписания
class ScheduleItem extends Equatable {
  final String time;
  final String event;
  final double temperature;
  final bool isActive;

  const ScheduleItem({
    required this.time,
    required this.event,
    required this.temperature,
    this.isActive = false,
  });

  @override
  List<Object?> get props => [time, event, temperature, isActive];
}

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<SmartDevice> devices;
  final ClimateState? climate;
  final EnergyStats? energyStats;
  final List<DeviceEnergyUsage> powerUsage;
  final List<Occupant> occupants;
  final List<ScheduleItem> schedule;
  final String? errorMessage;

  // HVAC устройства
  final List<HvacDevice> hvacDevices;
  final String? selectedHvacDeviceId;

  // Schedule (weekly)
  final List<ScheduleEntry> weeklySchedule;

  // Notifications
  final List<UnitNotification> unitNotifications;

  // Graph data
  final List<GraphDataPoint> graphData;
  final GraphMetric selectedGraphMetric;

  // Connectivity
  final bool isOffline;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.devices = const [],
    this.climate,
    this.energyStats,
    this.powerUsage = const [],
    this.occupants = const [],
    this.schedule = const [],
    this.errorMessage,
    this.hvacDevices = const [],
    this.selectedHvacDeviceId,
    this.weeklySchedule = const [],
    this.unitNotifications = const [],
    this.graphData = const [],
    this.selectedGraphMetric = GraphMetric.temperature,
    this.isOffline = false,
  });

  /// Получить выбранное HVAC устройство
  HvacDevice? get selectedHvacDevice {
    if (selectedHvacDeviceId == null || hvacDevices.isEmpty) return null;
    return hvacDevices.firstWhere(
      (d) => d.id == selectedHvacDeviceId,
      orElse: () => hvacDevices.first,
    );
  }

  // Default schedule for demo
  static const defaultSchedule = [
    ScheduleItem(time: '07:00', event: 'Подъём', temperature: 22, isActive: true),
    ScheduleItem(time: '09:00', event: 'Уход', temperature: 18),
    ScheduleItem(time: '18:00', event: 'Возвращение', temperature: 21),
    ScheduleItem(time: '22:00', event: 'Сон', temperature: 19),
  ];

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
    List<ScheduleItem>? schedule,
    String? errorMessage,
    List<HvacDevice>? hvacDevices,
    String? selectedHvacDeviceId,
    List<ScheduleEntry>? weeklySchedule,
    List<UnitNotification>? unitNotifications,
    List<GraphDataPoint>? graphData,
    GraphMetric? selectedGraphMetric,
    bool? isOffline,
  }) {
    return DashboardState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      climate: climate ?? this.climate,
      energyStats: energyStats ?? this.energyStats,
      powerUsage: powerUsage ?? this.powerUsage,
      occupants: occupants ?? this.occupants,
      schedule: schedule ?? this.schedule,
      errorMessage: errorMessage,
      hvacDevices: hvacDevices ?? this.hvacDevices,
      selectedHvacDeviceId: selectedHvacDeviceId ?? this.selectedHvacDeviceId,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      unitNotifications: unitNotifications ?? this.unitNotifications,
      graphData: graphData ?? this.graphData,
      selectedGraphMetric: selectedGraphMetric ?? this.selectedGraphMetric,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  /// Get unread notification count
  int get unreadNotificationCount =>
      unitNotifications.where((n) => !n.isRead).length;

  @override
  List<Object?> get props => [
    status, devices, climate, energyStats, powerUsage,
    occupants, schedule, errorMessage, hvacDevices, selectedHvacDeviceId,
    weeklySchedule, unitNotifications, graphData, selectedGraphMetric,
    isOffline,
  ];
}
