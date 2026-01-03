part of 'schedule_bloc.dart';

/// События для ScheduleBloc
///
/// Именование по конвенции flutter_bloc:
/// - sealed class для базового события
/// - final class для конкретных событий
/// - Префикс Schedule + существительное + прошедшее время
sealed class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// Устройство изменено - загружаем расписание для нового устройства
final class ScheduleDeviceChanged extends ScheduleEvent {
  final String deviceId;

  const ScheduleDeviceChanged(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

/// Список записей обновлён (из стрима)
final class ScheduleEntriesUpdated extends ScheduleEvent {
  final List<ScheduleEntry> entries;

  const ScheduleEntriesUpdated(this.entries);

  @override
  List<Object?> get props => [entries];
}

/// Запрошено добавление записи расписания
final class ScheduleEntryAdded extends ScheduleEvent {
  final ScheduleEntry entry;

  const ScheduleEntryAdded(this.entry);

  @override
  List<Object?> get props => [entry];
}

/// Запрошено обновление записи расписания
final class ScheduleEntryUpdated extends ScheduleEvent {
  final ScheduleEntry entry;

  const ScheduleEntryUpdated(this.entry);

  @override
  List<Object?> get props => [entry];
}

/// Запрошено удаление записи расписания
final class ScheduleEntryDeleted extends ScheduleEvent {
  final String entryId;

  const ScheduleEntryDeleted(this.entryId);

  @override
  List<Object?> get props => [entryId];
}

/// Запрошено переключение активности записи
final class ScheduleEntryToggled extends ScheduleEvent {
  final String entryId;
  final bool isActive;

  const ScheduleEntryToggled({
    required this.entryId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [entryId, isActive];
}
