/// Тесты для DashboardBloc
///
/// Проверяет все события и состояния дашборда:
/// - DashboardStarted (загрузка всех данных)
/// - DeviceToggled / DevicePowerToggled
/// - TemperatureChanged / HumidityChanged
/// - ClimateModeChanged / PresetChanged
/// - SupplyAirflowChanged / ExhaustAirflowChanged
/// - HvacDeviceSelected
/// - ScheduleLoaded / ScheduleEntryToggled
/// - NotificationsLoaded / NotificationRead / NotificationDismissed
/// - GraphDataLoaded / GraphMetricChanged
library;

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';

import '../../fixtures/mock_repositories.dart';
import '../../fixtures/test_data.dart';

void main() {
  late MockSmartDeviceRepository mockDeviceRepository;
  late MockClimateRepository mockClimateRepository;
  late MockEnergyRepository mockEnergyRepository;
  late MockOccupantRepository mockOccupantRepository;
  late MockScheduleRepository mockScheduleRepository;
  late MockNotificationRepository mockNotificationRepository;
  late MockGraphDataRepository mockGraphDataRepository;

  setUpAll(() {
    // Регистрация fallback значений для mocktail
    registerFallbackValue(ClimateMode.auto);
    registerFallbackValue(GraphMetric.temperature);
  });

  setUp(() {
    mockDeviceRepository = MockSmartDeviceRepository();
    mockClimateRepository = MockClimateRepository();
    mockEnergyRepository = MockEnergyRepository();
    mockOccupantRepository = MockOccupantRepository();
    mockScheduleRepository = MockScheduleRepository();
    mockNotificationRepository = MockNotificationRepository();
    mockGraphDataRepository = MockGraphDataRepository();

    // Настройка стримов по умолчанию (пустые)
    when(() => mockDeviceRepository.watchDevices())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockClimateRepository.watchClimate())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockClimateRepository.watchHvacDevices())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockEnergyRepository.watchStats())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockOccupantRepository.watchOccupants())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockScheduleRepository.watchSchedule(any()))
        .thenAnswer((_) => const Stream.empty());
    when(() => mockNotificationRepository.watchNotifications(deviceId: any(named: 'deviceId')))
        .thenAnswer((_) => const Stream.empty());
    when(() => mockGraphDataRepository.watchGraphData(
          deviceId: any(named: 'deviceId'),
          metric: any(named: 'metric'),
        )).thenAnswer((_) => const Stream.empty());
  });

  DashboardBloc createBloc() => DashboardBloc(
        deviceRepository: mockDeviceRepository,
        climateRepository: mockClimateRepository,
        energyRepository: mockEnergyRepository,
        occupantRepository: mockOccupantRepository,
        scheduleRepository: mockScheduleRepository,
        notificationRepository: mockNotificationRepository,
        graphDataRepository: mockGraphDataRepository,
      );

  /// Настраивает моки для успешной загрузки DashboardStarted
  void setupSuccessfulLoad() {
    when(() => mockClimateRepository.getAllHvacDevices())
        .thenAnswer((_) async => TestData.testHvacDevices);
    when(() => mockClimateRepository.setSelectedDevice(any()))
        .thenReturn(null);
    when(() => mockDeviceRepository.getAllDevices())
        .thenAnswer((_) async => TestData.testSmartDevices);
    when(() => mockClimateRepository.getCurrentState())
        .thenAnswer((_) async => TestData.testClimateState);
    when(() => mockEnergyRepository.getTodayStats())
        .thenAnswer((_) async => TestData.testEnergyStats);
    when(() => mockEnergyRepository.getDevicePowerUsage())
        .thenAnswer((_) async => TestData.testDeviceEnergyUsage);
    when(() => mockOccupantRepository.getAllOccupants())
        .thenAnswer((_) async => TestData.testOccupants);
    when(() => mockScheduleRepository.getSchedule(any()))
        .thenAnswer((_) async => TestData.testWeeklySchedule);
    when(() => mockNotificationRepository.getNotifications(deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async => TestData.testNotifications);
    when(() => mockGraphDataRepository.getGraphData(
          deviceId: any(named: 'deviceId'),
          metric: any(named: 'metric'),
          from: any(named: 'from'),
          to: any(named: 'to'),
        )).thenAnswer((_) async => TestData.testGraphData);
  }

  group('DashboardBloc начальное состояние', () {
    test('имеет корректное начальное состояние', () {
      final bloc = createBloc();
      expect(bloc.state.status, equals(DashboardStatus.initial));
      expect(bloc.state.devices, isEmpty);
      expect(bloc.state.climate, isNull);
      expect(bloc.state.hvacDevices, isEmpty);
      bloc.close();
    });
  });

  group('DashboardBloc.DashboardStarted', () {
    blocTest<DashboardBloc, DashboardState>(
      'загружает все данные при успешном старте',
      setUp: setupSuccessfulLoad,
      build: createBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      expect: () => [
        // Состояние загрузки
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.loading),
        // Успешное состояние с данными
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.success)
            .having((s) => s.devices.length, 'devices', 2)
            .having((s) => s.hvacDevices.length, 'hvacDevices', 2)
            .having((s) => s.climate, 'climate', TestData.testClimateState)
            .having((s) => s.occupants.length, 'occupants', 2),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'устанавливает первое HVAC устройство как выбранное',
      setUp: setupSuccessfulLoad,
      build: createBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      verify: (_) {
        verify(() => mockClimateRepository.setSelectedDevice('hvac-device-1')).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит failure при ошибке загрузки',
      setUp: () {
        when(() => mockClimateRepository.getAllHvacDevices())
            .thenThrow(Exception('Ошибка сети'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const DashboardStarted()),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.loading),
        isA<DashboardState>()
            .having((s) => s.status, 'status', DashboardStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', contains('Ошибка')),
      ],
    );
  });

  group('DashboardBloc.DeviceToggled', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает toggleDevice в репозитории',
      setUp: () {
        when(() => mockDeviceRepository.toggleDevice(any(), any()))
            .thenAnswer((_) async => TestData.testSmartDevice);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const DeviceToggled('smart-device-1', true)),
      verify: (_) {
        verify(() => mockDeviceRepository.toggleDevice('smart-device-1', true)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит ошибку при неудачном переключении',
      setUp: () {
        when(() => mockDeviceRepository.toggleDevice(any(), any()))
            .thenThrow(Exception('Устройство недоступно'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const DeviceToggled('smart-device-1', true)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.errorMessage, 'errorMessage', contains('Ошибка переключения')),
      ],
    );
  });

  group('DashboardBloc.DevicePowerToggled', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setPower в climateRepository',
      setUp: () {
        when(() => mockClimateRepository.setPower(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const DevicePowerToggled(true)),
      verify: (_) {
        verify(() => mockClimateRepository.setPower(true)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит ошибку при неудачном переключении питания',
      setUp: () {
        when(() => mockClimateRepository.setPower(any()))
            .thenThrow(Exception('Ошибка'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const DevicePowerToggled(false)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.errorMessage, 'errorMessage', contains('питания')),
      ],
    );
  });

  group('DashboardBloc.TemperatureChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setTargetTemperature в репозитории',
      setUp: () {
        when(() => mockClimateRepository.setTargetTemperature(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const TemperatureChanged(24)),
      verify: (_) {
        verify(() => mockClimateRepository.setTargetTemperature(24)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит ошибку при неудачной установке температуры',
      setUp: () {
        when(() => mockClimateRepository.setTargetTemperature(any()))
            .thenThrow(Exception('Ошибка'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const TemperatureChanged(25)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.errorMessage, 'errorMessage', contains('температуры')),
      ],
    );
  });

  group('DashboardBloc.HumidityChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setHumidity в репозитории',
      setUp: () {
        when(() => mockClimateRepository.setHumidity(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const HumidityChanged(50)),
      verify: (_) {
        verify(() => mockClimateRepository.setHumidity(50)).called(1);
      },
    );
  });

  group('DashboardBloc.ClimateModeChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setMode в репозитории',
      setUp: () {
        when(() => mockClimateRepository.setMode(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const ClimateModeChanged(ClimateMode.cooling)),
      verify: (_) {
        verify(() => mockClimateRepository.setMode(ClimateMode.cooling)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит ошибку при неудачной смене режима',
      setUp: () {
        when(() => mockClimateRepository.setMode(any()))
            .thenThrow(Exception('Режим недоступен'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const ClimateModeChanged(ClimateMode.auto)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.errorMessage, 'errorMessage', contains('режима')),
      ],
    );
  });

  group('DashboardBloc.SupplyAirflowChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setSupplyAirflow в репозитории',
      setUp: () {
        when(() => mockClimateRepository.setSupplyAirflow(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const SupplyAirflowChanged(200)),
      verify: (_) {
        verify(() => mockClimateRepository.setSupplyAirflow(200)).called(1);
      },
    );
  });

  group('DashboardBloc.ExhaustAirflowChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setExhaustAirflow в репозитории',
      setUp: () {
        when(() => mockClimateRepository.setExhaustAirflow(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const ExhaustAirflowChanged(180)),
      verify: (_) {
        verify(() => mockClimateRepository.setExhaustAirflow(180)).called(1);
      },
    );
  });

  group('DashboardBloc.PresetChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает setPreset в репозитории',
      setUp: () {
        when(() => mockClimateRepository.setPreset(any()))
            .thenAnswer((_) async => TestData.testClimateState);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const PresetChanged('eco')),
      verify: (_) {
        verify(() => mockClimateRepository.setPreset('eco')).called(1);
      },
    );
  });

  group('DashboardBloc.HvacDeviceSelected', () {
    blocTest<DashboardBloc, DashboardState>(
      'выбирает устройство и загружает его состояние',
      setUp: () {
        when(() => mockClimateRepository.setSelectedDevice(any()))
            .thenReturn(null);
        when(() => mockClimateRepository.getDeviceState(any()))
            .thenAnswer((_) async => TestData.testClimateStateCooling);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const HvacDeviceSelected('hvac-device-2')),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.selectedHvacDeviceId, 'selectedHvacDeviceId', 'hvac-device-2')
            .having((s) => s.climate?.mode, 'climate.mode', ClimateMode.cooling),
      ],
      verify: (_) {
        verify(() => mockClimateRepository.setSelectedDevice('hvac-device-2')).called(1);
        verify(() => mockClimateRepository.getDeviceState('hvac-device-2')).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит ошибку при неудачном выборе устройства',
      setUp: () {
        when(() => mockClimateRepository.setSelectedDevice(any()))
            .thenReturn(null);
        when(() => mockClimateRepository.getDeviceState(any()))
            .thenThrow(Exception('Устройство offline'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const HvacDeviceSelected('offline-device')),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.errorMessage, 'errorMessage', contains('устройства')),
      ],
    );
  });

  group('DashboardBloc.AllDevicesOff', () {
    blocTest<DashboardBloc, DashboardState>(
      'выключает все устройства',
      seed: () => DashboardState(devices: TestData.testSmartDevices),
      setUp: () {
        when(() => mockClimateRepository.setPower(any()))
            .thenAnswer((_) async => TestData.testClimateState);
        when(() => mockDeviceRepository.toggleDevice(any(), any()))
            .thenAnswer((_) async => TestData.testSmartDevice);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const AllDevicesOff()),
      verify: (_) {
        verify(() => mockClimateRepository.setPower(false)).called(1);
        // Только включённое устройство будет выключено
        verify(() => mockDeviceRepository.toggleDevice('smart-device-1', false)).called(1);
      },
    );
  });

  group('DashboardBloc.DevicesUpdated', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет список устройств',
      build: createBloc,
      act: (bloc) => bloc.add(DevicesUpdated(TestData.testSmartDevices)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.devices, 'devices', TestData.testSmartDevices),
      ],
    );
  });

  group('DashboardBloc.ClimateUpdated', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет состояние климата',
      build: createBloc,
      act: (bloc) => bloc.add(ClimateUpdated(TestData.testClimateState)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.climate, 'climate', TestData.testClimateState),
      ],
    );
  });

  group('DashboardBloc.EnergyUpdated', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет статистику энергопотребления',
      build: createBloc,
      act: (bloc) => bloc.add(EnergyUpdated(TestData.testEnergyStats)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.energyStats, 'energyStats', TestData.testEnergyStats),
      ],
    );
  });

  group('DashboardBloc.OccupantsUpdated', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет список жителей',
      build: createBloc,
      act: (bloc) => bloc.add(OccupantsUpdated(TestData.testOccupants)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.occupants, 'occupants', TestData.testOccupants),
      ],
    );
  });

  group('DashboardBloc.HvacDevicesUpdated', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет список HVAC устройств',
      build: createBloc,
      act: (bloc) => bloc.add(HvacDevicesUpdated(TestData.testHvacDevices)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.hvacDevices, 'hvacDevices', TestData.testHvacDevices),
      ],
    );
  });

  group('DashboardBloc.ScheduleLoaded', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет расписание',
      build: createBloc,
      act: (bloc) => bloc.add(ScheduleLoaded(TestData.testWeeklySchedule)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.weeklySchedule, 'weeklySchedule', TestData.testWeeklySchedule),
      ],
    );
  });

  group('DashboardBloc.ScheduleEntryToggled', () {
    blocTest<DashboardBloc, DashboardState>(
      'вызывает toggleEntry в репозитории',
      setUp: () {
        when(() => mockScheduleRepository.toggleEntry(any(), any()))
            .thenAnswer((_) async => TestData.testScheduleEntryActive);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const ScheduleEntryToggled('schedule-1', false)),
      verify: (_) {
        verify(() => mockScheduleRepository.toggleEntry('schedule-1', false)).called(1);
      },
    );

    blocTest<DashboardBloc, DashboardState>(
      'эмитит ошибку при неудачном изменении расписания',
      setUp: () {
        when(() => mockScheduleRepository.toggleEntry(any(), any()))
            .thenThrow(Exception('Ошибка'));
      },
      build: createBloc,
      act: (bloc) => bloc.add(const ScheduleEntryToggled('schedule-1', true)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.errorMessage, 'errorMessage', contains('расписания')),
      ],
    );
  });

  group('DashboardBloc.NotificationsLoaded', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет список уведомлений',
      build: createBloc,
      act: (bloc) => bloc.add(NotificationsLoaded(TestData.testNotifications)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.unitNotifications, 'unitNotifications', TestData.testNotifications),
      ],
    );
  });

  group('DashboardBloc.NotificationRead', () {
    blocTest<DashboardBloc, DashboardState>(
      'помечает уведомление как прочитанное',
      setUp: () {
        when(() => mockNotificationRepository.markAsRead(any()))
            .thenAnswer((_) async {});
      },
      build: createBloc,
      act: (bloc) => bloc.add(const NotificationRead('notif-1')),
      verify: (_) {
        verify(() => mockNotificationRepository.markAsRead('notif-1')).called(1);
      },
    );
  });

  group('DashboardBloc.NotificationDismissed', () {
    blocTest<DashboardBloc, DashboardState>(
      'удаляет уведомление',
      setUp: () {
        when(() => mockNotificationRepository.dismiss(any()))
            .thenAnswer((_) async {});
      },
      build: createBloc,
      act: (bloc) => bloc.add(const NotificationDismissed('notif-2')),
      verify: (_) {
        verify(() => mockNotificationRepository.dismiss('notif-2')).called(1);
      },
    );
  });

  group('DashboardBloc.GraphDataLoaded', () {
    blocTest<DashboardBloc, DashboardState>(
      'обновляет данные графика',
      build: createBloc,
      act: (bloc) => bloc.add(GraphDataLoaded(TestData.testGraphData)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.graphData, 'graphData', TestData.testGraphData),
      ],
    );
  });

  group('DashboardBloc.GraphMetricChanged', () {
    blocTest<DashboardBloc, DashboardState>(
      'меняет метрику и загружает новые данные',
      seed: () => const DashboardState(selectedHvacDeviceId: 'hvac-device-1'),
      setUp: () {
        when(() => mockGraphDataRepository.getGraphData(
              deviceId: any(named: 'deviceId'),
              metric: any(named: 'metric'),
              from: any(named: 'from'),
              to: any(named: 'to'),
            )).thenAnswer((_) async => TestData.testGraphData);
      },
      build: createBloc,
      act: (bloc) => bloc.add(const GraphMetricChanged(GraphMetric.humidity)),
      expect: () => [
        // Сначала меняется метрика
        isA<DashboardState>()
            .having((s) => s.selectedGraphMetric, 'selectedGraphMetric', GraphMetric.humidity),
        // Затем загружаются данные
        isA<DashboardState>()
            .having((s) => s.graphData, 'graphData', TestData.testGraphData),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'не загружает данные если устройство не выбрано',
      build: createBloc,
      act: (bloc) => bloc.add(const GraphMetricChanged(GraphMetric.airflow)),
      expect: () => [
        isA<DashboardState>()
            .having((s) => s.selectedGraphMetric, 'selectedGraphMetric', GraphMetric.airflow),
      ],
      verify: (_) {
        verifyNever(() => mockGraphDataRepository.getGraphData(
              deviceId: any(named: 'deviceId'),
              metric: any(named: 'metric'),
              from: any(named: 'from'),
              to: any(named: 'to'),
            ));
      },
    );
  });

  group('DashboardState helpers', () {
    test('unreadNotificationCount подсчитывает непрочитанные уведомления', () {
      final state = DashboardState(unitNotifications: TestData.testNotifications);
      expect(state.unreadNotificationCount, equals(1));
    });

    test('selectedHvacDevice возвращает выбранное устройство', () {
      final state = DashboardState(
        hvacDevices: TestData.testHvacDevices,
        selectedHvacDeviceId: 'hvac-device-2',
      );
      expect(state.selectedHvacDevice?.id, equals('hvac-device-2'));
      expect(state.selectedHvacDevice?.name, equals('Бризер Спальня'));
    });

    test('selectedHvacDevice возвращает null если нет устройств', () {
      const state = DashboardState(
        hvacDevices: [],
        selectedHvacDeviceId: 'hvac-device-1',
      );
      expect(state.selectedHvacDevice, isNull);
    });

    test('airQuality возвращает качество воздуха из climate', () {
      final state = DashboardState(climate: TestData.testClimateState);
      expect(state.airQuality, equals(AirQualityLevel.good));
    });

    test('co2Ppm возвращает уровень CO2 из climate', () {
      final state = DashboardState(climate: TestData.testClimateState);
      expect(state.co2Ppm, equals(650));
    });
  });
}
