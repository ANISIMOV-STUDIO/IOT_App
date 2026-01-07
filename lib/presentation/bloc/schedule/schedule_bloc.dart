/// Schedule BLoC — управление расписанием устройства
///
/// Отвечает за:
/// - Загрузку расписания устройства
/// - Добавление/редактирование записей расписания
/// - Удаление записей расписания
/// - Активацию/деактивацию записей
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/api_exception.dart';
import '../../../domain/entities/schedule_entry.dart';
import '../../../domain/repositories/schedule_repository.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

/// BLoC для управления расписанием устройства
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository _repository;

  StreamSubscription<List<ScheduleEntry>>? _scheduleSubscription;

  ScheduleBloc({
    required ScheduleRepository repository,
  })  : _repository = repository,
        super(const ScheduleState()) {
    // События жизненного цикла
    on<ScheduleDeviceChanged>(_onDeviceChanged);
    on<ScheduleEntriesUpdated>(_onEntriesUpdated);

    // События управления расписанием
    on<ScheduleEntryAdded>(_onEntryAdded);
    on<ScheduleEntryUpdated>(_onEntryUpdated);
    on<ScheduleEntryDeleted>(_onEntryDeleted);
    on<ScheduleEntryToggled>(_onEntryToggled);
  }

  /// Смена устройства - загружаем расписание для нового устройства
  Future<void> _onDeviceChanged(
    ScheduleDeviceChanged event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));

    try {
      // Загружаем расписание
      final entries = await _repository.getSchedule(event.deviceId);
      emit(state.copyWith(
        status: ScheduleStatus.success,
        entries: entries,
        deviceId: event.deviceId,
      ));

      // Подписываемся на обновления
      await _scheduleSubscription?.cancel();
      _scheduleSubscription = _repository.watchSchedule(event.deviceId).listen(
        (entries) => add(ScheduleEntriesUpdated(entries)),
        onError: (error) {
          // Игнорируем ошибки стрима - данные уже загружены
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: ScheduleStatus.failure,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  /// Обновление списка записей из стрима
  void _onEntriesUpdated(
    ScheduleEntriesUpdated event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(entries: event.entries));
  }

  /// Добавление новой записи расписания
  Future<void> _onEntryAdded(
    ScheduleEntryAdded event,
    Emitter<ScheduleState> emit,
  ) async {
    final previousEntries = List<ScheduleEntry>.from(state.entries);

    // Optimistic update - сразу добавляем в UI
    emit(state.copyWith(
      isSubmitting: true,
      entries: [...state.entries, event.entry],
    ));

    try {
      final newEntry = await _repository.addEntry(event.entry);

      // Заменяем временную запись на реальную с сервера
      final updatedEntries = state.entries.map((e) {
        if (e.id == event.entry.id) return newEntry;
        return e;
      }).toList();

      emit(state.copyWith(
        isSubmitting: false,
        entries: updatedEntries,
      ));
    } catch (e) {
      // Откат при ошибке
      emit(state.copyWith(
        isSubmitting: false,
        entries: previousEntries,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  /// Обновление записи расписания
  Future<void> _onEntryUpdated(
    ScheduleEntryUpdated event,
    Emitter<ScheduleState> emit,
  ) async {
    final previousEntries = List<ScheduleEntry>.from(state.entries);

    // Optimistic update - сразу обновляем в UI
    final optimisticEntries = state.entries.map((e) {
      if (e.id == event.entry.id) return event.entry;
      return e;
    }).toList();

    emit(state.copyWith(
      isSubmitting: true,
      entries: optimisticEntries,
    ));

    try {
      final updatedEntry = await _repository.updateEntry(event.entry);

      // Обновляем с данными с сервера
      final updatedEntries = state.entries.map((e) {
        if (e.id == updatedEntry.id) return updatedEntry;
        return e;
      }).toList();

      emit(state.copyWith(
        isSubmitting: false,
        entries: updatedEntries,
      ));
    } catch (e) {
      // Откат при ошибке
      emit(state.copyWith(
        isSubmitting: false,
        entries: previousEntries,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  /// Удаление записи расписания
  Future<void> _onEntryDeleted(
    ScheduleEntryDeleted event,
    Emitter<ScheduleState> emit,
  ) async {
    final previousEntries = List<ScheduleEntry>.from(state.entries);

    // Optimistic update - сразу удаляем из UI
    final optimisticEntries = state.entries
        .where((e) => e.id != event.entryId)
        .toList();

    emit(state.copyWith(
      isSubmitting: true,
      entries: optimisticEntries,
    ));

    try {
      await _repository.deleteEntry(event.entryId);

      emit(state.copyWith(isSubmitting: false));
    } catch (e) {
      // Откат при ошибке
      emit(state.copyWith(
        isSubmitting: false,
        entries: previousEntries,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  /// Переключение активности записи
  Future<void> _onEntryToggled(
    ScheduleEntryToggled event,
    Emitter<ScheduleState> emit,
  ) async {
    final previousEntries = List<ScheduleEntry>.from(state.entries);

    // Optimistic update - сразу переключаем в UI
    final optimisticEntries = state.entries.map((e) {
      if (e.id == event.entryId) {
        return ScheduleEntry(
          id: e.id,
          deviceId: e.deviceId,
          day: e.day,
          mode: e.mode,
          timeRange: e.timeRange,
          tempDay: e.tempDay,
          tempNight: e.tempNight,
          isActive: event.isActive,
        );
      }
      return e;
    }).toList();

    emit(state.copyWith(entries: optimisticEntries));

    try {
      final toggledEntry = await _repository.toggleEntry(
        event.entryId,
        event.isActive,
      );

      // Обновляем с данными с сервера
      final updatedEntries = state.entries.map((e) {
        if (e.id == toggledEntry.id) return toggledEntry;
        return e;
      }).toList();

      emit(state.copyWith(entries: updatedEntries));
    } catch (e) {
      // Откат при ошибке
      emit(state.copyWith(
        entries: previousEntries,
        errorMessage: _getErrorMessage(e),
      ));
    }
  }

  String _getErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'Schedule operation error';
  }

  @override
  Future<void> close() {
    _scheduleSubscription?.cancel();
    return super.close();
  }
}
