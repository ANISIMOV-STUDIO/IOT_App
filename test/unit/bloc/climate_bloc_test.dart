/// ClimateBloc Unit Tests
///
/// Тестирование управления климатом устройства
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes for Use Cases
class MockGetCurrentClimateState extends Mock
    implements GetCurrentClimateState {}

class MockGetDeviceState extends Mock implements GetDeviceState {}

class MockGetDeviceFullState extends Mock implements GetDeviceFullState {}

class MockGetAlarmHistory extends Mock implements GetAlarmHistory {}

class MockWatchCurrentClimate extends Mock implements WatchCurrentClimate {}

class MockSetDevicePower extends Mock implements SetDevicePower {}

class MockSetTemperature extends Mock implements SetTemperature {}

class MockSetCoolingTemperature extends Mock implements SetCoolingTemperature {}

class MockSetHumidity extends Mock implements SetHumidity {}

class MockSetClimateMode extends Mock implements SetClimateMode {}

class MockSetOperatingMode extends Mock implements SetOperatingMode {}

class MockSetPreset extends Mock implements SetPreset {}

class MockSetAirflow extends Mock implements SetAirflow {}

class MockSetScheduleEnabled extends Mock implements SetScheduleEnabled {}

class MockWatchDeviceFullState extends Mock implements WatchDeviceFullState {}

class MockRequestDeviceUpdate extends Mock implements RequestDeviceUpdate {}

void main() {
  late MockGetCurrentClimateState mockGetCurrentClimateState;
  late MockGetDeviceState mockGetDeviceState;
  late MockGetDeviceFullState mockGetDeviceFullState;
  late MockGetAlarmHistory mockGetAlarmHistory;
  late MockWatchCurrentClimate mockWatchCurrentClimate;
  late MockSetDevicePower mockSetDevicePower;
  late MockSetTemperature mockSetTemperature;
  late MockSetCoolingTemperature mockSetCoolingTemperature;
  late MockSetHumidity mockSetHumidity;
  late MockSetClimateMode mockSetClimateMode;
  late MockSetOperatingMode mockSetOperatingMode;
  late MockSetPreset mockSetPreset;
  late MockSetAirflow mockSetAirflow;
  late MockSetScheduleEnabled mockSetScheduleEnabled;
  late MockWatchDeviceFullState mockWatchDeviceFullState;
  late MockRequestDeviceUpdate mockRequestDeviceUpdate;

  // Test data
  const testClimate = ClimateState(
    roomId: 'room-1',
    deviceName: 'Бризер Гостиная',
    currentTemperature: 22.5,
    targetTemperature: 23,
    humidity: 45,
    mode: ClimateMode.auto,
    airQuality: AirQualityLevel.good,
  );

  const testClimateOff = ClimateState(
    roomId: 'room-1',
    deviceName: 'Бризер Гостиная',
    currentTemperature: 22.5,
    targetTemperature: 23,
    humidity: 45,
    mode: ClimateMode.auto,
    airQuality: AirQualityLevel.good,
    isOn: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetDeviceStateParams(deviceId: ''));
    registerFallbackValue(const GetDeviceFullStateParams(deviceId: ''));
    registerFallbackValue(const SetDevicePowerParams(isOn: false));
    registerFallbackValue(const SetTemperatureParams(temperature: 20));
    registerFallbackValue(const SetCoolingTemperatureParams(temperature: 24));
    registerFallbackValue(const SetHumidityParams(humidity: 50));
    registerFallbackValue(const SetClimateModeParams(mode: ClimateMode.auto));
    registerFallbackValue(const SetOperatingModeParams(mode: 'basic'));
    registerFallbackValue(const SetPresetParams(preset: 'auto'));
    registerFallbackValue(
        const SetAirflowParams(type: AirflowType.supply, value: 50));
    registerFallbackValue(
        const SetScheduleEnabledParams(deviceId: '', enabled: false));
    registerFallbackValue(
        const WatchDeviceFullStateParams(deviceId: ''));
  });

  setUp(() {
    mockGetCurrentClimateState = MockGetCurrentClimateState();
    mockGetDeviceState = MockGetDeviceState();
    mockGetDeviceFullState = MockGetDeviceFullState();
    mockWatchCurrentClimate = MockWatchCurrentClimate();
    mockSetDevicePower = MockSetDevicePower();
    mockSetTemperature = MockSetTemperature();
    mockSetCoolingTemperature = MockSetCoolingTemperature();
    mockSetHumidity = MockSetHumidity();
    mockSetClimateMode = MockSetClimateMode();
    mockSetOperatingMode = MockSetOperatingMode();
    mockSetPreset = MockSetPreset();
    mockSetAirflow = MockSetAirflow();
    mockSetScheduleEnabled = MockSetScheduleEnabled();
    mockWatchDeviceFullState = MockWatchDeviceFullState();
    mockGetAlarmHistory = MockGetAlarmHistory();
    mockRequestDeviceUpdate = MockRequestDeviceUpdate();

    // Default stub for requestDeviceUpdate (fire-and-forget)
    when(() => mockRequestDeviceUpdate(any())).thenAnswer((_) async {});
  });

  ClimateBloc createBloc() => ClimateBloc(
        getCurrentClimateState: mockGetCurrentClimateState,
        getDeviceFullState: mockGetDeviceFullState,
        getAlarmHistory: mockGetAlarmHistory,
        watchCurrentClimate: mockWatchCurrentClimate,
        setDevicePower: mockSetDevicePower,
        setTemperature: mockSetTemperature,
        setCoolingTemperature: mockSetCoolingTemperature,
        setHumidity: mockSetHumidity,
        setClimateMode: mockSetClimateMode,
        setOperatingMode: mockSetOperatingMode,
        setPreset: mockSetPreset,
        setAirflow: mockSetAirflow,
        setScheduleEnabled: mockSetScheduleEnabled,
        watchDeviceFullState: mockWatchDeviceFullState,
        requestDeviceUpdate: mockRequestDeviceUpdate,
      );

  group('ClimateBloc', () {
    group('Инициализация', () {
      test('начальное состояние - ClimateControlState с initial статусом', () {
        when(() => mockWatchCurrentClimate())
            .thenAnswer((_) => const Stream.empty());

        final bloc = createBloc();

        expect(bloc.state.status, ClimateControlStatus.initial);
        expect(bloc.state.climate, isNull);
        expect(bloc.state.isOn, isFalse);

        bloc.close();
      });
    });

    group('ClimateSubscriptionRequested', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит [loading, success] с климатом при успешной загрузке',
        build: () {
          when(() => mockGetCurrentClimateState())
              .thenAnswer((_) async => testClimate);
          when(() => mockWatchCurrentClimate())
              .thenAnswer((_) => const Stream.empty());
          return createBloc();
        },
        act: (bloc) => bloc.add(const ClimateSubscriptionRequested()),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          const ClimateControlState(
            status: ClimateControlStatus.success,
            climate: testClimate,
          ),
        ],
        verify: (_) {
          verify(() => mockGetCurrentClimateState()).called(1);
          verify(() => mockWatchCurrentClimate()).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит [loading, failure] при ошибке загрузки',
        build: () {
          when(() => mockGetCurrentClimateState())
              .thenThrow(Exception('Network error'));
          return createBloc();
        },
        act: (bloc) => bloc.add(const ClimateSubscriptionRequested()),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          isA<ClimateControlState>()
              .having((s) => s.status, 'status', ClimateControlStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('ClimateDeviceChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит [loading, success] при смене устройства',
        build: () {
          // when(() => mockGetDeviceState(any())) -> Removed from bloc
          when(() => mockGetDeviceFullState(any()))
              .thenAnswer((_) async => const DeviceFullState(
                    id: 'device-2',
                    name: 'Device 2',
                    // Add other necessary fields if needed by mapping logic
                  ));
          when(() => mockWatchDeviceFullState(any()))
              .thenAnswer((_) => const Stream.empty());
          return createBloc();
        },
        act: (bloc) => bloc.add(const ClimateDeviceChanged('device-2')),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          isA<ClimateControlState>()
              .having((s) => s.status, 'status', ClimateControlStatus.success)
              .having((s) => s.climate?.deviceName, 'climate.deviceName', 'Device 2'),
        ],
        verify: (_) {
          verify(() => mockGetDeviceFullState(any())).called(1);
          verifyNever(() => mockGetDeviceState(any()));
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит [loading, failure] при ошибке загрузки устройства',
        build: () {
          when(() => mockGetDeviceFullState(any()))
              .thenThrow(Exception('Device not found'));
          return createBloc();
        },
        act: (bloc) => bloc.add(const ClimateDeviceChanged('unknown')),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          isA<ClimateControlState>()
              .having((s) => s.status, 'status', ClimateControlStatus.failure)
              .having(
                  (s) => s.errorMessage, 'errorMessage', contains('State loading error')),
        ],
      );
    });

    group('ClimateStateUpdated', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'обновляет состояние климата из стрима',
        build: createBloc,
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateStateUpdated(testClimateOff)),
        expect: () => [
          const ClimateControlState(
            status: ClimateControlStatus.success,
            climate: testClimateOff,
          ),
        ],
      );
    });

    group('ClimatePowerToggled', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setDevicePower use case',
        build: () {
          when(() => mockSetDevicePower(any()))
              .thenAnswer((_) async => testClimateOff);
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimatePowerToggled(false)),
        verify: (_) {
          verify(() => mockSetDevicePower(any())).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит ошибку при неудачном переключении',
        build: () {
          when(() => mockSetDevicePower(any()))
              .thenThrow(Exception('Device offline'));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimatePowerToggled(false)),
        expect: () => [
          // Первый emit: isTogglingPower = true (optimistic update)
          isA<ClimateControlState>()
              .having((s) => s.isTogglingPower, 'isTogglingPower', true),
          // Второй emit: ошибка + isTogglingPower = false
          isA<ClimateControlState>()
              .having((s) => s.errorMessage, 'errorMessage',
                  contains('Power toggle error'))
              .having((s) => s.isTogglingPower, 'isTogglingPower', false),
        ],
      );
    });

    group('ClimateTemperatureChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setTemperature use case',
        build: () {
          when(() => mockSetTemperature(any()))
              .thenAnswer((_) async => testClimate.copyWith(targetTemperature: 25));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateTemperatureChanged(25)),
        wait: const Duration(milliseconds: 600), // Ждём debounce
        verify: (_) {
          verify(() => mockSetTemperature(any())).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит ошибку и откатывает изменения при неудачной установке температуры',
        build: () {
          when(() => mockSetTemperature(any()))
              .thenThrow(Exception('Invalid value'));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateTemperatureChanged(100)),
        wait: const Duration(milliseconds: 600), // Ждём debounce
        expect: () => [
          // Optimistic update - сразу обновляем температуру
          isA<ClimateControlState>()
              .having((s) => s.climate?.targetTemperature, 'targetTemperature', 100.0),
          // Откат при ошибке - возвращаем исходное значение
          isA<ClimateControlState>()
              .having((s) => s.climate?.targetTemperature, 'targetTemperature', 23.0)
              .having((s) => s.errorMessage, 'errorMessage', contains('Temperature setting error')),
        ],
      );
    });

    group('ClimateHumidityChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setHumidity use case',
        build: () {
          when(() => mockSetHumidity(any()))
              .thenAnswer((_) async => testClimate.copyWith(targetHumidity: 60));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateHumidityChanged(60)),
        verify: (_) {
          verify(() => mockSetHumidity(any())).called(1);
        },
      );
    });

    group('ClimateModeChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setClimateMode use case',
        build: () {
          when(() => mockSetClimateMode(any()))
              .thenAnswer((_) async => testClimate.copyWith(mode: ClimateMode.cooling));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateModeChanged(ClimateMode.cooling)),
        verify: (_) {
          verify(() => mockSetClimateMode(any())).called(1);
        },
      );
    });

    group('ClimatePresetChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setPreset use case',
        build: () {
          when(() => mockSetPreset(any()))
              .thenAnswer((_) async => testClimate.copyWith(preset: 'turbo'));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimatePresetChanged('turbo')),
        verify: (_) {
          verify(() => mockSetPreset(any())).called(1);
        },
      );
    });

    group('ClimateSupplyAirflowChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'мгновенно обновляет UI и вызывает setAirflow use case после debounce',
        build: () {
          when(() => mockSetAirflow(any()))
              .thenAnswer((_) async => testClimate.copyWith(supplyAirflow: 80));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) async {
          bloc.add(const ClimateSupplyAirflowChanged(80));
          // Ждём 600мс чтобы debounce сработал
          await Future<void>.delayed(const Duration(milliseconds: 600));
        },
        expect: () => [
          // 1. Мгновенное обновление UI + pending
          isA<ClimateControlState>()
              .having((s) => s.isPendingSupplyFan, 'isPendingSupplyFan', true)
              .having((s) => s.climate?.supplyAirflow, 'supplyAirflow', 80.0),
        ],
        verify: (_) {
          verify(() => mockSetAirflow(any())).called(1);
        },
      );
    });

    group('ClimateExhaustAirflowChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'мгновенно обновляет UI и вызывает setAirflow use case после debounce',
        build: () {
          when(() => mockSetAirflow(any()))
              .thenAnswer((_) async => testClimate.copyWith(exhaustAirflow: 70));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) async {
          bloc.add(const ClimateExhaustAirflowChanged(70));
          // Ждём 600мс чтобы debounce сработал
          await Future<void>.delayed(const Duration(milliseconds: 600));
        },
        expect: () => [
           // 1. Мгновенное обновление UI + pending
          isA<ClimateControlState>()
              .having((s) => s.isPendingExhaustFan, 'isPendingExhaustFan', true)
              .having((s) => s.climate?.exhaustAirflow, 'exhaustAirflow', 70.0),
        ],
        verify: (_) {
          verify(() => mockSetAirflow(any())).called(1);
        },
      );
    });

    group('ClimateHeatingTempChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'мгновенно обновляет UI и вызывает setTemperature use case после debounce',
        build: () {
          when(() => mockSetTemperature(any()))
              .thenAnswer((_) async => testClimate.copyWith(targetTemperature: 21));
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          deviceFullState: DeviceFullState(
            id: '1',
            name: 'Device 1',
            heatingTemperature: 20,
          ),
        ),
        act: (bloc) async {
          bloc.add(const ClimateHeatingTempChanged(21));
          // Ждём 600мс чтобы debounce сработал
          await Future<void>.delayed(const Duration(milliseconds: 600));
        },
        expect: () => [
          // 1. Мгновенное обновление UI + pending
          isA<ClimateControlState>()
              .having((s) => s.isPendingHeatingTemperature, 'isPendingHeatingTemperature', true)
              .having((s) => s.deviceFullState?.heatingTemperature, 'heatingTemperature', 21),
        ],
        verify: (_) {
          verify(() => mockSetTemperature(any())).called(1);
        },
      );
    });

    group('ClimateCoolingTempChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'мгновенно обновляет UI и вызывает setCoolingTemperature use case после debounce',
        build: () {
          when(() => mockSetCoolingTemperature(any()))
              .thenAnswer((_) async => testClimate.copyWith());
          return createBloc();
        },
        seed: () => const ClimateControlState(
          status: ClimateControlStatus.success,
          deviceFullState: DeviceFullState(
            id: '1',
            name: 'Device 1',
            coolingTemperature: 24,
          ),
        ),
        act: (bloc) async {
          bloc.add(const ClimateCoolingTempChanged(25));
          // Ждём 600мс чтобы debounce сработал
          await Future<void>.delayed(const Duration(milliseconds: 600));
        },
        expect: () => [
          // 1. Мгновенное обновление UI + pending
          isA<ClimateControlState>()
              .having((s) => s.isPendingCoolingTemperature, 'isPendingCoolingTemperature', true)
              .having((s) => s.deviceFullState?.coolingTemperature, 'coolingTemperature', 25),
        ],
        verify: (_) {
          verify(() => mockSetCoolingTemperature(any())).called(1);
        },
      );
    });

    group('ClimateControlState', () {
      test('геттеры возвращают значения из climate', () {
        const state = ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        );

        expect(state.isOn, isTrue);
        expect(state.currentTemperature, 22.5);
        expect(state.targetTemperature, 23.0);
        expect(state.humidity, 45.0);
        expect(state.mode, ClimateMode.auto);
        expect(state.preset, 'auto');
        expect(state.airQuality, AirQualityLevel.good);
      });

      test('геттеры возвращают null/false когда climate null', () {
        const state = ClimateControlState(

        );

        expect(state.isOn, isFalse);
        expect(state.currentTemperature, isNull);
        expect(state.targetTemperature, isNull);
        expect(state.mode, isNull);
      });

      test('hasAlarms возвращает false когда deviceFullState null', () {
        const state = ClimateControlState(
          status: ClimateControlStatus.success,
        );

        expect(state.hasAlarms, isFalse);
        expect(state.alarmCount, 0);
        expect(state.activeAlarms, isEmpty);
      });
    });
  });
}
