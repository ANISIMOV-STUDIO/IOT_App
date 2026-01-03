part of 'analytics_bloc.dart';

/// События для AnalyticsBloc
///
/// Именование по конвенции flutter_bloc:
/// - sealed class для базового события
/// - final class для конкретных событий
/// - Префикс Analytics + существительное + прошедшее время
sealed class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

// ============================================
// СОБЫТИЯ ЖИЗНЕННОГО ЦИКЛА
// ============================================

/// Запрос на подписку к данным аналитики (инициализация)
final class AnalyticsSubscriptionRequested extends AnalyticsEvent {
  const AnalyticsSubscriptionRequested();
}

/// Запрос на обновление данных аналитики
final class AnalyticsRefreshRequested extends AnalyticsEvent {
  const AnalyticsRefreshRequested();
}

/// Смена текущего устройства — перезагрузить графики
final class AnalyticsDeviceChanged extends AnalyticsEvent {
  final String deviceId;

  const AnalyticsDeviceChanged(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

// ============================================
// ОБНОВЛЕНИЯ ИЗ СТРИМА
// ============================================

/// Статистика энергопотребления обновлена (из стрима)
final class AnalyticsEnergyStatsUpdated extends AnalyticsEvent {
  final EnergyStats stats;

  const AnalyticsEnergyStatsUpdated(this.stats);

  @override
  List<Object?> get props => [stats];
}

/// Данные графика обновлены (из стрима)
final class AnalyticsGraphDataUpdated extends AnalyticsEvent {
  final List<GraphDataPoint> data;

  const AnalyticsGraphDataUpdated(this.data);

  @override
  List<Object?> get props => [data];
}

// ============================================
// ДЕЙСТВИЯ
// ============================================

/// Изменена метрика графика
final class AnalyticsGraphMetricChanged extends AnalyticsEvent {
  final GraphMetric metric;

  const AnalyticsGraphMetricChanged(this.metric);

  @override
  List<Object?> get props => [metric];
}
