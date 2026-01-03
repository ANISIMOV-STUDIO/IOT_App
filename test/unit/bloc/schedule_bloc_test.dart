/// Тесты для ScheduleBloc
///
/// Проверяет все сценарии управления расписанием:
/// - Загрузка расписания
/// - Добавление записи
/// - Редактирование записи
/// - Удаление записи
/// - Переключение активности
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/core/error/api_exception.dart';

import '../../fixtures/mock_services.dart';
import '../../fixtures/test_data.dart';

void main() {
  late MockScheduleRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(TestData.testScheduleEntryActive);
  });

  setUp(() {
    mockRepository = MockScheduleRepository();
  });

  ScheduleBloc createBloc() {
    return ScheduleBloc(repository: mockRepository);
  }

  group('ScheduleBloc - Инициализация', () {
    test('начальное состояние - ScheduleState с initial status', () {
      final bloc = createBloc();
      expect(bloc.state.status, ScheduleStatus.initial);
      expect(bloc.state.entries, isEmpty);
      expect(bloc.state.deviceId, isNull);
      bloc.close();
    });
  });

  group('ScheduleBloc - ScheduleDeviceChanged', () {
    blocTest<ScheduleBloc, ScheduleState>(
      'эмитит [loading, success] при успешной загрузке расписания',
      build: () {
        when(() => mockRepository.getSchedule(any()))
            .thenAnswer((_) async => TestData.testWeeklySchedule);
        when(() => mockRepository.watchSchedule(any()))
            .thenAnswer((_) => const Stream.empty());
        return createBloc();
      },
      act: (bloc) => bloc.add(const ScheduleDeviceChanged('hvac-device-1')),
      expect: () => [
        isA<ScheduleState>()
            .having((s) => s.status, 'status', ScheduleStatus.loading),
        isA<ScheduleState>()
            .having((s) => s.status, 'status', ScheduleStatus.success)
            .having((s) => s.entries.length, 'entries.length', 2)
            .having((s) => s.deviceId, 'deviceId', 'hvac-device-1'),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'эмитит [loading, failure] при ошибке загрузки',
      build: () {
        when(() => mockRepository.getSchedule(any()))
            .thenThrow(const ApiException(
              type: ApiErrorType.serverError,
              message: 'Ошибка загрузки расписания',
            ));
        return createBloc();
      },
      act: (bloc) => bloc.add(const ScheduleDeviceChanged('hvac-device-1')),
      expect: () => [
        isA<ScheduleState>()
            .having((s) => s.status, 'status', ScheduleStatus.loading),
        isA<ScheduleState>()
            .having((s) => s.status, 'status', ScheduleStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Ошибка загрузки расписания'),
      ],
    );
  });

  group('ScheduleBloc - ScheduleEntryAdded', () {
    blocTest<ScheduleBloc, ScheduleState>(
      'добавляет запись в список при успехе',
      build: () {
        when(() => mockRepository.addEntry(any()))
            .thenAnswer((_) async => TestData.testScheduleEntryActive);
        return createBloc();
      },
      act: (bloc) => bloc.add(ScheduleEntryAdded(TestData.testScheduleEntryActive)),
      expect: () => [
        isA<ScheduleState>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ScheduleState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.entries.length, 'entries.length', 1),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'эмитит ошибку при неуспешном добавлении',
      build: () {
        when(() => mockRepository.addEntry(any()))
            .thenThrow(const ApiException(
              type: ApiErrorType.serverError,
              message: 'Ошибка добавления',
            ));
        return createBloc();
      },
      act: (bloc) => bloc.add(ScheduleEntryAdded(TestData.testScheduleEntryActive)),
      expect: () => [
        isA<ScheduleState>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ScheduleState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Ошибка добавления'),
      ],
    );
  });

  group('ScheduleBloc - ScheduleEntryUpdated', () {
    final updatedEntry = const ScheduleEntry(
      id: 'schedule-1',
      deviceId: 'hvac-device-1',
      day: 'Понедельник',
      mode: 'eco',
      timeRange: '09:00-19:00',
      tempDay: 21,
      tempNight: 18,
      isActive: true,
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'обновляет запись в списке при успехе',
      seed: () => ScheduleState(
        status: ScheduleStatus.success,
        entries: TestData.testWeeklySchedule,
      ),
      build: () {
        when(() => mockRepository.updateEntry(any()))
            .thenAnswer((_) async => updatedEntry);
        return createBloc();
      },
      act: (bloc) => bloc.add(ScheduleEntryUpdated(updatedEntry)),
      expect: () => [
        isA<ScheduleState>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ScheduleState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having(
              (s) => s.entries.firstWhere((e) => e.id == 'schedule-1').mode,
              'updated mode',
              'eco',
            ),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'эмитит ошибку при неуспешном обновлении',
      seed: () => ScheduleState(
        status: ScheduleStatus.success,
        entries: TestData.testWeeklySchedule,
      ),
      build: () {
        when(() => mockRepository.updateEntry(any()))
            .thenThrow(const ApiException(
              type: ApiErrorType.serverError,
              message: 'Ошибка обновления',
            ));
        return createBloc();
      },
      act: (bloc) => bloc.add(ScheduleEntryUpdated(updatedEntry)),
      expect: () => [
        isA<ScheduleState>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ScheduleState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Ошибка обновления'),
      ],
    );
  });

  group('ScheduleBloc - ScheduleEntryDeleted', () {
    blocTest<ScheduleBloc, ScheduleState>(
      'удаляет запись из списка при успехе',
      seed: () => ScheduleState(
        status: ScheduleStatus.success,
        entries: TestData.testWeeklySchedule,
      ),
      build: () {
        when(() => mockRepository.deleteEntry(any()))
            .thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const ScheduleEntryDeleted('schedule-1')),
      expect: () => [
        isA<ScheduleState>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ScheduleState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.entries.length, 'entries.length', 1)
            .having(
              (s) => s.entries.any((e) => e.id == 'schedule-1'),
              'schedule-1 removed',
              false,
            ),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'эмитит ошибку при неуспешном удалении',
      seed: () => ScheduleState(
        status: ScheduleStatus.success,
        entries: TestData.testWeeklySchedule,
      ),
      build: () {
        when(() => mockRepository.deleteEntry(any()))
            .thenThrow(const ApiException(
              type: ApiErrorType.serverError,
              message: 'Ошибка удаления',
            ));
        return createBloc();
      },
      act: (bloc) => bloc.add(const ScheduleEntryDeleted('schedule-1')),
      expect: () => [
        isA<ScheduleState>().having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ScheduleState>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having((s) => s.errorMessage, 'errorMessage', 'Ошибка удаления'),
      ],
    );
  });

  group('ScheduleBloc - ScheduleEntryToggled', () {
    final toggledEntry = TestData.testScheduleEntryActive.copyWith(isActive: false);

    blocTest<ScheduleBloc, ScheduleState>(
      'переключает активность записи при успехе',
      seed: () => ScheduleState(
        status: ScheduleStatus.success,
        entries: [TestData.testScheduleEntryActive],
      ),
      build: () {
        when(() => mockRepository.toggleEntry(any(), any()))
            .thenAnswer((_) async => toggledEntry);
        return createBloc();
      },
      act: (bloc) => bloc.add(const ScheduleEntryToggled(
        entryId: 'schedule-1',
        isActive: false,
      )),
      expect: () => [
        isA<ScheduleState>().having(
          (s) => s.entries.first.isActive,
          'isActive',
          false,
        ),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'эмитит ошибку при неуспешном переключении',
      seed: () => ScheduleState(
        status: ScheduleStatus.success,
        entries: [TestData.testScheduleEntryActive],
      ),
      build: () {
        when(() => mockRepository.toggleEntry(any(), any()))
            .thenThrow(const ApiException(
              type: ApiErrorType.serverError,
              message: 'Ошибка переключения',
            ));
        return createBloc();
      },
      act: (bloc) => bloc.add(const ScheduleEntryToggled(
        entryId: 'schedule-1',
        isActive: false,
      )),
      expect: () => [
        isA<ScheduleState>()
            .having((s) => s.errorMessage, 'errorMessage', 'Ошибка переключения'),
      ],
    );
  });

  group('ScheduleBloc - ScheduleEntriesUpdated', () {
    blocTest<ScheduleBloc, ScheduleState>(
      'обновляет список записей из стрима',
      build: createBloc,
      act: (bloc) => bloc.add(ScheduleEntriesUpdated(TestData.testWeeklySchedule)),
      expect: () => [
        isA<ScheduleState>()
            .having((s) => s.entries.length, 'entries.length', 2),
      ],
    );
  });
}
