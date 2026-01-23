/// Analytics BLoC — статистика энергопотребления и графики
///
/// Отвечает за:
/// - Загрузку статистики энергопотребления
/// - Загрузку данных для графиков
/// - Смену метрики графика
library;

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/domain/entities/energy_stats.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

/// BLoC для аналитики и статистики
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {

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
    // restartable: отменяет предыдущий запрос при быстром переключении устройств
    on<AnalyticsDeviceChanged>(_onDeviceChanged, transformer: restartable());

    // Обновления из стрима
    on<AnalyticsEnergyStatsUpdated>(_onEnergyStatsUpdated);
    on<AnalyticsGraphDataUpdated>(_onGraphDataUpdated);

    // Действия
    on<AnalyticsGraphMetricChanged>(_onGraphMetricChanged);
  }
  final GetTodayStats _getTodayStats;
  final GetDevicePowerUsage _getDevicePowerUsage;
  final WatchEnergyStats _watchEnergyStats;
  final GetGraphData _getGraphData;
  final WatchGraphData _watchGraphData;

  StreamSubscription<EnergyStats>? _energySubscription;
  StreamSubscription<List<GraphDataPoint>>? _graphDataSubscription;

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

      // Безопасное извлечение с проверкой типов
      final energyStats = results[0] is EnergyStats ? results[0] as EnergyStats : null;
      final powerUsage = results[1] is List<DeviceEnergyUsage>
          ? results[1] as List<DeviceEnergyUsage>
          : <DeviceEnergyUsage>[];

      emit(state.copyWith(
        status: AnalyticsStatus.success,
        energyStats: energyStats,
        powerUsage: powerUsage,
      ));

      // Подписываемся на обновления через Use Case
      await _energySubscription?.cancel();
      _energySubscription = _watchEnergyStats().listen(
        (stats) => add(AnalyticsEnergyStatsUpdated(stats)),
        onError: (error) {
          // Игнорируем ошибки стрима - данные уже загружены
        },
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

    await _loadGraphData(event.deviceId, state.selectedMetric, emit);
    await _subscribeToGraphData(event.deviceId, state.selectedMetric);
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

    final deviceId = state.currentDeviceId;
    if (deviceId != null) {
      await _loadGraphData(deviceId, event.metric, emit);
      await _subscribeToGraphData(deviceId, event.metric);
    }
  }

  /// Подписка на обновления данных графика
  Future<void> _subscribeToGraphData(String deviceId, GraphMetric metric) async {
    await _graphDataSubscription?.cancel();
    _graphDataSubscription = _watchGraphData(WatchGraphDataParams(
      deviceId: deviceId,
      metric: metric,
    )).listen(
      (data) => add(AnalyticsGraphDataUpdated(data)),
      onError: (error) {
        // Игнорируем ошибки стрима - данные уже загружены
      },
    );
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
      emit(state.copyWith(errorMessage: 'Graph loading error: $e'));
    }
  }

  @override
  Future<void> close() {
    _energySubscription?.cancel();
    _graphDataSubscription?.cancel();
    return super.close();
  }
}
