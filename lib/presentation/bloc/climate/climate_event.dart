part of 'climate_bloc.dart';

/// События для ClimateBloc
///
/// Именование по конвенции flutter_bloc:
/// - sealed class для базового события
/// - final class для конкретных событий
/// - Префикс Climate + существительное + прошедшее время
sealed class ClimateEvent extends Equatable {
  const ClimateEvent();

  @override
  List<Object?> get props => [];
}

// ============================================
// СОБЫТИЯ ЖИЗНЕННОГО ЦИКЛА
// ============================================

/// Запрос на подписку к состоянию климата (инициализация)
final class ClimateSubscriptionRequested extends ClimateEvent {
  const ClimateSubscriptionRequested();
}

/// Смена текущего устройства — перезагрузить состояние
final class ClimateDeviceChanged extends ClimateEvent {
  final String deviceId;

  const ClimateDeviceChanged(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

// ============================================
// ОБНОВЛЕНИЯ ИЗ СТРИМА
// ============================================

/// Состояние климата обновлено (из стрима)
final class ClimateStateUpdated extends ClimateEvent {
  final ClimateState climate;

  const ClimateStateUpdated(this.climate);

  @override
  List<Object?> get props => [climate];
}

/// Загружено полное состояние устройства (с авариями)
final class ClimateFullStateLoaded extends ClimateEvent {
  final DeviceFullState fullState;

  const ClimateFullStateLoaded(this.fullState);

  @override
  List<Object?> get props => [fullState];
}

/// Запрос на загрузку истории аварий
final class ClimateAlarmHistoryRequested extends ClimateEvent {
  final String deviceId;

  const ClimateAlarmHistoryRequested(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

/// История аварий загружена
final class ClimateAlarmHistoryLoaded extends ClimateEvent {
  final List<AlarmHistory> history;

  const ClimateAlarmHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

// ============================================
// УПРАВЛЕНИЕ УСТРОЙСТВОМ
// ============================================

/// Питание устройства включено/выключено
final class ClimatePowerToggled extends ClimateEvent {
  final bool isOn;

  const ClimatePowerToggled(this.isOn);

  @override
  List<Object?> get props => [isOn];
}

/// Изменена целевая температура
final class ClimateTemperatureChanged extends ClimateEvent {
  final double temperature;

  const ClimateTemperatureChanged(this.temperature);

  @override
  List<Object?> get props => [temperature];
}

/// Изменена температура нагрева
final class ClimateHeatingTempChanged extends ClimateEvent {
  final int temperature;

  const ClimateHeatingTempChanged(this.temperature);

  @override
  List<Object?> get props => [temperature];
}

/// Изменена температура охлаждения
final class ClimateCoolingTempChanged extends ClimateEvent {
  final int temperature;

  const ClimateCoolingTempChanged(this.temperature);

  @override
  List<Object?> get props => [temperature];
}

/// Изменена целевая влажность
final class ClimateHumidityChanged extends ClimateEvent {
  final double humidity;

  const ClimateHumidityChanged(this.humidity);

  @override
  List<Object?> get props => [humidity];
}

/// Изменён режим климата (enum: heating, cooling, auto, etc.)
final class ClimateModeChanged extends ClimateEvent {
  final ClimateMode mode;

  const ClimateModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Изменён режим работы установки (String: basic, intensive, economy, etc.)
final class ClimateOperatingModeChanged extends ClimateEvent {
  final String mode;

  const ClimateOperatingModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Изменён пресет
final class ClimatePresetChanged extends ClimateEvent {
  final String preset;

  const ClimatePresetChanged(this.preset);

  @override
  List<Object?> get props => [preset];
}

/// Изменён приток воздуха
final class ClimateSupplyAirflowChanged extends ClimateEvent {
  final double value;

  const ClimateSupplyAirflowChanged(this.value);

  @override
  List<Object?> get props => [value];
}

/// Изменена вытяжка воздуха
final class ClimateExhaustAirflowChanged extends ClimateEvent {
  final double value;

  const ClimateExhaustAirflowChanged(this.value);

  @override
  List<Object?> get props => [value];
}

/// Расписание устройства включено/выключено
final class ClimateScheduleToggled extends ClimateEvent {
  final bool enabled;

  const ClimateScheduleToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}
