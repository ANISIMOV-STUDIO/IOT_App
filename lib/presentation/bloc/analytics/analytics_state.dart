part of 'analytics_bloc.dart';

/// Статус загрузки AnalyticsBloc
enum AnalyticsStatus {
  /// Начальное состояние
  initial,

  /// Загрузка данных
  loading,

  /// Успешная загрузка
  success,

  /// Ошибка загрузки
  failure,
}

/// Состояние аналитики
final class AnalyticsState extends Equatable {
  /// Статус загрузки
  final AnalyticsStatus status;

  /// Статистика энергопотребления за сегодня
  final EnergyStats? energyStats;

  /// Потребление по устройствам
  final List<DeviceEnergyUsage> powerUsage;

  /// Данные для графика
  final List<GraphDataPoint> graphData;

  /// Выбранная метрика графика
  final GraphMetric selectedMetric;

  /// ID текущего устройства для графиков
  final String? currentDeviceId;

  /// Сообщение об ошибке
  final String? errorMessage;

  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.energyStats,
    this.powerUsage = const [],
    this.graphData = const [],
    this.selectedMetric = GraphMetric.temperature,
    this.currentDeviceId,
    this.errorMessage,
  });

  // ============================================
  // ГЕТТЕРЫ ДЛЯ УДОБСТВА
  // ============================================

  /// Общее потребление за сегодня в кВт⋅ч
  double get totalKwh => energyStats?.totalKwh ?? 0.0;

  /// Общее время работы в часах
  int get totalHours => energyStats?.totalHours ?? 0;

  /// Есть ли данные для графика
  bool get hasGraphData => graphData.isNotEmpty;

  /// Идёт ли загрузка
  bool get isLoading => status == AnalyticsStatus.loading;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    EnergyStats? energyStats,
    List<DeviceEnergyUsage>? powerUsage,
    List<GraphDataPoint>? graphData,
    GraphMetric? selectedMetric,
    String? currentDeviceId,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      energyStats: energyStats ?? this.energyStats,
      powerUsage: powerUsage ?? this.powerUsage,
      graphData: graphData ?? this.graphData,
      selectedMetric: selectedMetric ?? this.selectedMetric,
      currentDeviceId: currentDeviceId ?? this.currentDeviceId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        energyStats,
        powerUsage,
        graphData,
        selectedMetric,
        currentDeviceId,
        errorMessage,
      ];
}
