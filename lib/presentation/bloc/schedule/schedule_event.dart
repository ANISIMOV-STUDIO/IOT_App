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

  const ScheduleDeviceChanged(this.deviceId);
  final String deviceId;

  @override
  List<Object?> get props => [deviceId];
}

/// Список записей обновлён (из стрима)
final class ScheduleEntriesUpdated extends ScheduleEvent {

  const ScheduleEntriesUpdated(this.entries);
  final List<ScheduleEntry> entries;

  @override
  List<Object?> get props => [entries];
}

/// Запрошено добавление записи расписания
final class ScheduleEntryAdded extends ScheduleEvent {

  const ScheduleEntryAdded(this.entry);
  final ScheduleEntry entry;

  @override
  List<Object?> get props => [entry];
}

/// Запрошено обновление записи расписания
final class ScheduleEntryUpdated extends ScheduleEvent {

  const ScheduleEntryUpdated(this.entry);
  final ScheduleEntry entry;

  @override
  List<Object?> get props => [entry];
}

/// Запрошено удаление записи расписания
final class ScheduleEntryDeleted extends ScheduleEvent {

  const ScheduleEntryDeleted(this.entryId);
  final String entryId;

  @override
  List<Object?> get props => [entryId];
}

/// Запрошено переключение активности записи
final class ScheduleEntryToggled extends ScheduleEvent {

  const ScheduleEntryToggled({
    required this.entryId,
    required this.isActive,
  });
  final String entryId;
  final bool isActive;

  @override
  List<Object?> get props => [entryId, isActive];
}
