part of 'climate_bloc.dart';

// BLoC events используют позиционные параметры по конвенции
// ignore_for_file: avoid_positional_boolean_parameters

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

  const ClimateDeviceChanged(this.deviceId);
  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

// ============================================
// ОБНОВЛЕНИЯ ИЗ СТРИМА
// ============================================

/// Состояние климата обновлено (из стрима)
final class ClimateStateUpdated extends ClimateEvent {

  const ClimateStateUpdated(this.climate);
  final ClimateState climate;

  @override
  List<Object?> get props => [climate];
}

/// Загружено полное состояние устройства (с авариями)
final class ClimateFullStateLoaded extends ClimateEvent {

  const ClimateFullStateLoaded(this.fullState);
  final DeviceFullState fullState;

  @override
  List<Object?> get props => [fullState];
}

/// Запрос на загрузку истории аварий
final class ClimateAlarmHistoryRequested extends ClimateEvent {

  const ClimateAlarmHistoryRequested(this.deviceId);
  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

/// История аварий загружена
final class ClimateAlarmHistoryLoaded extends ClimateEvent {

  const ClimateAlarmHistoryLoaded(this.history);
  final List<AlarmHistory> history;

  @override
  List<Object?> get props => [history];
}

// ============================================
// УПРАВЛЕНИЕ УСТРОЙСТВОМ
// ============================================

/// Питание устройства включено/выключено
final class ClimatePowerToggled extends ClimateEvent {

  const ClimatePowerToggled(this.isOn);
  final bool isOn;

  @override
  List<Object?> get props => [isOn];
}

/// Изменена целевая температура
final class ClimateTemperatureChanged extends ClimateEvent {

  const ClimateTemperatureChanged(this.temperature);
  final double temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Изменена температура нагрева
final class ClimateHeatingTempChanged extends ClimateEvent {

  const ClimateHeatingTempChanged(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Изменена температура охлаждения
final class ClimateCoolingTempChanged extends ClimateEvent {

  const ClimateCoolingTempChanged(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Изменена целевая влажность
final class ClimateHumidityChanged extends ClimateEvent {

  const ClimateHumidityChanged(this.humidity);
  final double humidity;

  @override
  List<Object?> get props => [humidity];
}

/// Изменён режим климата (enum: heating, cooling, auto, etc.)
final class ClimateModeChanged extends ClimateEvent {

  const ClimateModeChanged(this.mode);
  final ClimateMode mode;

  @override
  List<Object?> get props => [mode];
}

/// Изменён режим работы установки (String: basic, intensive, economy, etc.)
final class ClimateOperatingModeChanged extends ClimateEvent {

  const ClimateOperatingModeChanged(this.mode);
  final String mode;

  @override
  List<Object?> get props => [mode];
}

/// Изменён пресет
final class ClimatePresetChanged extends ClimateEvent {

  const ClimatePresetChanged(this.preset);
  final String preset;

  @override
  List<Object?> get props => [preset];
}

/// Изменён приток воздуха
final class ClimateSupplyAirflowChanged extends ClimateEvent {

  const ClimateSupplyAirflowChanged(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Изменена вытяжка воздуха
final class ClimateExhaustAirflowChanged extends ClimateEvent {

  const ClimateExhaustAirflowChanged(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Расписание устройства включено/выключено
final class ClimateScheduleToggled extends ClimateEvent {

  const ClimateScheduleToggled(this.enabled);
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

// ============================================
// ВНУТРЕННИЕ СОБЫТИЯ (Debounced API Calls)
// ============================================

/// Внутреннее событие для отправки температуры нагрева (после debounce)
final class ClimateHeatingTempCommit extends ClimateEvent {

  const ClimateHeatingTempCommit(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Внутреннее событие для отправки температуры охлаждения (после debounce)
final class ClimateCoolingTempCommit extends ClimateEvent {

  const ClimateCoolingTempCommit(this.temperature);
  final int temperature;

  @override
  List<Object?> get props => [temperature];
}

/// Внутреннее событие для отправки притока воздуха (после debounce)
final class ClimateSupplyAirflowCommit extends ClimateEvent {

  const ClimateSupplyAirflowCommit(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

/// Внутреннее событие для отправки вытяжки воздуха (после debounce)
final class ClimateExhaustAirflowCommit extends ClimateEvent {

  const ClimateExhaustAirflowCommit(this.value);
  final double value;

  @override
  List<Object?> get props => [value];
}

// ============================================
// ОБНОВЛЕНИЕ ЛОКАЛЬНОГО СОСТОЯНИЯ
// ============================================

/// Обновлены быстрые показатели (локально, после успешного сохранения)
final class ClimateQuickSensorsUpdated extends ClimateEvent {

  const ClimateQuickSensorsUpdated(this.quickSensors);
  final List<String> quickSensors;

  @override
  List<Object?> get props => [quickSensors];
}
