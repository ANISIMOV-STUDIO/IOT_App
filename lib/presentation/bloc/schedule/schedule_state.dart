part of 'schedule_bloc.dart';

/// Статус загрузки ScheduleBloc
enum ScheduleStatus {
  /// Начальное состояние
  initial,

  /// Загрузка расписания
  loading,

  /// Успешная загрузка
  success,

  /// Ошибка загрузки
  failure,
}

/// Состояние расписания устройства
final class ScheduleState extends Equatable {
  /// Статус загрузки
  final ScheduleStatus status;

  /// ID текущего устройства
  final String? deviceId;

  /// Список записей расписания
  final List<ScheduleEntry> entries;

  /// Идёт отправка изменений
  final bool isSubmitting;

  /// Сообщение об ошибке
  final String? errorMessage;

  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.deviceId,
    this.entries = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });

  /// Проверка наличия записей расписания
  bool get hasEntries => entries.isNotEmpty;

  /// Количество записей
  int get entryCount => entries.length;

  /// Количество активных записей
  int get activeCount => entries.where((e) => e.isActive).length;

  ScheduleState copyWith({
    ScheduleStatus? status,
    String? deviceId,
    List<ScheduleEntry>? entries,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      deviceId: deviceId ?? this.deviceId,
      entries: entries ?? this.entries,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        deviceId,
        entries,
        isSubmitting,
        errorMessage,
      ];
}
