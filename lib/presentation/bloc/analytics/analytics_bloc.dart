/// Analytics BLoC — статистика энергопотребления и графики
///
/// Отвечает за:
/// - Загрузку статистики энергопотребления
/// - Загрузку данных для графиков
/// - Смену метрики графика
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/energy_stats.dart';
import '../../../domain/entities/graph_data.dart';
import '../../../domain/usecases/usecases.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

/// BLoC для аналитики и статистики
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetTodayStats _getTodayStats;
  final GetDevicePowerUsage _getDevicePowerUsage;
  final WatchEnergyStats _watchEnergyStats;
  final GetGraphData _getGraphData;
  final WatchGraphData _watchGraphData;

  StreamSubscription<EnergyStats>? _energySubscription;
  StreamSubscription<List<GraphDataPoint>>? _graphDataSubscription;

  AnalyticsBloc({
    required GetTodayStats getTodayStats,
    required GetDevicePowerUsage getDevicePowerUsage,
    required WatchEnergyStats watchEnergyStats,
    required GetGraphData getGraphData,
    required WatchGraphData watchGraphData,
  })  : _getTodayStats = getTodayStats,
        _getDevicePowerUsage = getDevicePowerUsage,
        _watchEnergyStats = watchEnergyStats,
        _getGraphData = getGraphData,
        _watchGraphData = watchGraphData,
        super(const AnalyticsState()) {
    // События жизненного цикла
    on<AnalyticsSubscriptionRequested>(_onSubscriptionRequested);
    on<AnalyticsRefreshRequested>(_onRefreshRequested);
    on<AnalyticsDeviceChanged>(_onDeviceChanged);

    // Обновления из стрима
    on<AnalyticsEnergyStatsUpdated>(_onEnergyStatsUpdated);
    on<AnalyticsGraphDataUpdated>(_onGraphDataUpdated);

    // Действия
    on<AnalyticsGraphMetricChanged>(_onGraphMetricChanged);
  }

  /// Запрос на подписку к данным аналитики
  Future<void> _onSubscriptionRequested(
    AnalyticsSubscriptionRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading));

    try {
      // Загружаем статистику энергопотребления через Use Cases
      final results = await Future.wait([
        _getTodayStats(),
        _getDevicePowerUsage(),
      ]);

      emit(state.copyWith(
        status: AnalyticsStatus.success,
        energyStats: results[0] as EnergyStats,
        powerUsage: results[1] as List<DeviceEnergyUsage>,
      ));

      // Подписываемся на обновления через Use Case
      await _energySubscription?.cancel();
      _energySubscription = _watchEnergyStats().listen(
        (stats) => add(AnalyticsEnergyStatsUpdated(stats)),
      );
    } catch (e) {
      emit(state.copyWith(
        status: AnalyticsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Обновление данных аналитики
  Future<void> _onRefreshRequested(
    AnalyticsRefreshRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    add(const AnalyticsSubscriptionRequested());
  }

  /// Смена устройства — перезагружаем графики для него
  Future<void> _onDeviceChanged(
    AnalyticsDeviceChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(currentDeviceId: event.deviceId));

    // Загружаем график для нового устройства
    await _loadGraphData(event.deviceId, state.selectedMetric, emit);

    // Переподписываемся на графики для нового устройства
    await _graphDataSubscription?.cancel();
    _graphDataSubscription = _watchGraphData(WatchGraphDataParams(
      deviceId: event.deviceId,
      metric: state.selectedMetric,
    )).listen((data) => add(AnalyticsGraphDataUpdated(data)));
  }

  /// Обновление статистики энергопотребления из стрима
  void _onEnergyStatsUpdated(
    AnalyticsEnergyStatsUpdated event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(energyStats: event.stats));
  }

  /// Обновление данных графика из стрима
  void _onGraphDataUpdated(
    AnalyticsGraphDataUpdated event,
    Emitter<AnalyticsState> emit,
  ) {
    emit(state.copyWith(graphData: event.data));
  }

  /// Смена метрики графика
  Future<void> _onGraphMetricChanged(
    AnalyticsGraphMetricChanged event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(selectedMetric: event.metric));

    // Перезагружаем график для новой метрики
    final deviceId = state.currentDeviceId;
    if (deviceId != null) {
      await _loadGraphData(deviceId, event.metric, emit);
    }
  }

  /// Вспомогательный метод для загрузки графика
  Future<void> _loadGraphData(
    String deviceId,
    GraphMetric metric,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      final data = await _getGraphData(GetGraphDataParams(
        deviceId: deviceId,
        metric: metric,
        from: DateTime.now().subtract(const Duration(days: 7)),
        to: DateTime.now(),
      ));
      emit(state.copyWith(graphData: data));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Ошибка загрузки графика: $e'));
    }
  }

  @override
  Future<void> close() {
    _energySubscription?.cancel();
    _graphDataSubscription?.cancel();
    return super.close();
  }
}
