/// Climate BLoCs Unit Tests
///
/// Tests for the 4 climate BLoCs: Core, Power, Parameters, Alarms
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/entities/device_full_state.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/climate/alarms/climate_alarms_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/core/climate_core_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/parameters/climate_parameters_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/power/climate_power_bloc.dart';
import 'package:mocktail/mocktail.dart';

// =============================================================================
// MOCK CLASSES
// =============================================================================

// Core BLoC mocks
class MockGetCurrentClimateState extends Mock
    implements GetCurrentClimateState {}

class MockGetDeviceFullState extends Mock implements GetDeviceFullState {}

class MockWatchCurrentClimate extends Mock implements WatchCurrentClimate {}

class MockWatchDeviceFullState extends Mock implements WatchDeviceFullState {}

class MockRequestDeviceUpdate extends Mock implements RequestDeviceUpdate {}

// Power BLoC mocks
class MockSetDevicePower extends Mock implements SetDevicePower {}

class MockSetScheduleEnabled extends Mock implements SetScheduleEnabled {}

// Parameters BLoC mocks
class MockSetTemperature extends Mock implements SetTemperature {}

class MockSetCoolingTemperature extends Mock implements SetCoolingTemperature {}

class MockSetHumidity extends Mock implements SetHumidity {}

class MockSetClimateMode extends Mock implements SetClimateMode {}

class MockSetOperatingMode extends Mock implements SetOperatingMode {}

class MockSetPreset extends Mock implements SetPreset {}

class MockSetAirflow extends Mock implements SetAirflow {}

class MockSetModeSettings extends Mock implements SetModeSettings {}

class MockSetQuickMode extends Mock implements SetQuickMode {}

// Alarms BLoC mocks
class MockGetAlarmHistory extends Mock implements GetAlarmHistory {}

class MockResetAlarm extends Mock implements ResetAlarm {}

// =============================================================================
// TEST DATA
// =============================================================================

const testClimate = ClimateState(
  roomId: 'room-1',
  deviceName: 'Breezer',
  currentTemperature: 22.5,
  targetTemperature: 23,
  humidity: 45,
  mode: ClimateMode.auto,
  airQuality: AirQualityLevel.good,
);

const testClimateOff = ClimateState(
  roomId: 'room-1',
  deviceName: 'Breezer',
  currentTemperature: 22.5,
  targetTemperature: 23,
  humidity: 45,
  mode: ClimateMode.auto,
  airQuality: AirQualityLevel.good,
  isOn: false,
);

// =============================================================================
// TESTS
// =============================================================================

void main() {
  // ---------------------------------------------------------------------------
  // SETUP
  // ---------------------------------------------------------------------------

  setUpAll(() {
    registerFallbackValue(const GetDeviceFullStateParams(deviceId: ''));
    registerFallbackValue(const SetDevicePowerParams(isOn: false));
    registerFallbackValue(const SetTemperatureParams(temperature: 20));
    registerFallbackValue(
        const SetCoolingTemperatureParams(temperature: 24));
    registerFallbackValue(const SetHumidityParams(humidity: 50));
    registerFallbackValue(
        const SetClimateModeParams(mode: ClimateMode.auto));
    registerFallbackValue(const SetOperatingModeParams(mode: 'basic'));
    registerFallbackValue(const SetPresetParams(preset: 'auto'));
    registerFallbackValue(
        const SetAirflowParams(type: AirflowType.supply, value: 50));
    registerFallbackValue(
        const SetScheduleEnabledParams(deviceId: '', enabled: false));
    registerFallbackValue(const WatchDeviceFullStateParams(deviceId: ''));
    registerFallbackValue(const SetModeSettingsParams(
      modeName: '',
      settings:
          ModeSettings(heatingTemperature: 22, coolingTemperature: 24),
    ));
    registerFallbackValue(
        const GetAlarmHistoryParams(deviceId: ''));
  });

  // ===========================================================================
  // CLIMATE CORE BLOC
  // ===========================================================================

  group('ClimateCoreBloc', () {
    late MockGetCurrentClimateState mockGetCurrentClimateState;
    late MockGetDeviceFullState mockGetDeviceFullState;
    late MockWatchCurrentClimate mockWatchCurrentClimate;
    late MockWatchDeviceFullState mockWatchDeviceFullState;
    late MockRequestDeviceUpdate mockRequestDeviceUpdate;

    setUp(() {
      mockGetCurrentClimateState = MockGetCurrentClimateState();
      mockGetDeviceFullState = MockGetDeviceFullState();
      mockWatchCurrentClimate = MockWatchCurrentClimate();
      mockWatchDeviceFullState = MockWatchDeviceFullState();
      mockRequestDeviceUpdate = MockRequestDeviceUpdate();

      when(() => mockRequestDeviceUpdate(any()))
          .thenAnswer((_) async {});
    });

    ClimateCoreBloc createCoreBloc() => ClimateCoreBloc(
          getCurrentClimateState: mockGetCurrentClimateState,
          getDeviceFullState: mockGetDeviceFullState,
          watchCurrentClimate: mockWatchCurrentClimate,
          watchDeviceFullState: mockWatchDeviceFullState,
          requestDeviceUpdate: mockRequestDeviceUpdate,
        );

    group('initialization', () {
      test('initial state has initial status', () {
        when(() => mockWatchCurrentClimate())
            .thenAnswer((_) => const Stream.empty());

        final bloc = createCoreBloc();

        expect(bloc.state.status, ClimateCoreStatus.initial);
        expect(bloc.state.climate, isNull);
        expect(bloc.state.isOn, isFalse);

        bloc.close();
      });
    });

    group('ClimateCoreSubscriptionRequested', () {
      blocTest<ClimateCoreBloc, ClimateCoreState>(
        'emits [loading, success] on successful subscription',
        build: () {
          when(() => mockGetCurrentClimateState())
              .thenAnswer((_) async => testClimate);
          when(() => mockWatchCurrentClimate())
              .thenAnswer((_) => const Stream.empty());
          return createCoreBloc();
        },
        act: (bloc) =>
            bloc.add(const ClimateCoreSubscriptionRequested()),
        expect: () => [
          const ClimateCoreState(status: ClimateCoreStatus.loading),
          const ClimateCoreState(
            status: ClimateCoreStatus.success,
            climate: testClimate,
          ),
        ],
        verify: (_) {
          verify(() => mockGetCurrentClimateState()).called(1);
          verify(() => mockWatchCurrentClimate()).called(1);
        },
      );

      blocTest<ClimateCoreBloc, ClimateCoreState>(
        'emits [loading, failure] on error',
        build: () {
          when(() => mockGetCurrentClimateState())
              .thenThrow(Exception('Network error'));
          return createCoreBloc();
        },
        act: (bloc) =>
            bloc.add(const ClimateCoreSubscriptionRequested()),
        expect: () => [
          const ClimateCoreState(status: ClimateCoreStatus.loading),
          isA<ClimateCoreState>()
              .having(
                  (s) => s.status, 'status', ClimateCoreStatus.failure)
              .having(
                  (s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('ClimateCoreDeviceChanged', () {
      blocTest<ClimateCoreBloc, ClimateCoreState>(
        'emits [loading, success] on device change',
        build: () {
          when(() => mockGetDeviceFullState(any()))
              .thenAnswer((_) async => const DeviceFullState(
                    id: 'device-2',
                    name: 'Device 2',
                  ));
          when(() => mockWatchDeviceFullState(any()))
              .thenAnswer((_) => const Stream.empty());
          return createCoreBloc();
        },
        act: (bloc) =>
            bloc.add(const ClimateCoreDeviceChanged('device-2')),
        expect: () => [
          const ClimateCoreState(status: ClimateCoreStatus.loading),
          isA<ClimateCoreState>().having(
              (s) => s.status, 'status', ClimateCoreStatus.success),
        ],
        verify: (_) {
          verify(() => mockGetDeviceFullState(any())).called(1);
        },
      );

      blocTest<ClimateCoreBloc, ClimateCoreState>(
        'emits [loading, failure] on device load error',
        build: () {
          when(() => mockGetDeviceFullState(any()))
              .thenThrow(Exception('Device not found'));
          return createCoreBloc();
        },
        act: (bloc) =>
            bloc.add(const ClimateCoreDeviceChanged('unknown')),
        expect: () => [
          const ClimateCoreState(status: ClimateCoreStatus.loading),
          isA<ClimateCoreState>()
              .having(
                  (s) => s.status, 'status', ClimateCoreStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage',
                  contains('State loading error')),
        ],
      );
    });

    group('ClimateCoreStateUpdated', () {
      blocTest<ClimateCoreBloc, ClimateCoreState>(
        'updates climate state from stream',
        build: createCoreBloc,
        seed: () => const ClimateCoreState(
          status: ClimateCoreStatus.success,
          climate: testClimate,
        ),
        act: (bloc) =>
            bloc.add(const ClimateCoreStateUpdated(testClimateOff)),
        expect: () => [
          const ClimateCoreState(
            status: ClimateCoreStatus.success,
            climate: testClimateOff,
          ),
        ],
      );
    });

    group('ClimateCoreState getters', () {
      test('getters return values from climate', () {
        const state = ClimateCoreState(
          status: ClimateCoreStatus.success,
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

      test('getters return null/false when climate is null', () {
        const state = ClimateCoreState();

        expect(state.isOn, isFalse);
        expect(state.currentTemperature, isNull);
        expect(state.targetTemperature, isNull);
        expect(state.mode, isNull);
      });

      test('hasAlarms returns false when deviceFullState is null', () {
        const state = ClimateCoreState(
          status: ClimateCoreStatus.success,
        );

        expect(state.hasAlarms, isFalse);
        expect(state.alarmCount, 0);
        expect(state.activeAlarms, isEmpty);
      });
    });
  });

  // ===========================================================================
  // CLIMATE POWER BLOC
  // ===========================================================================

  group('ClimatePowerBloc', () {
    late MockSetDevicePower mockSetDevicePower;
    late MockSetScheduleEnabled mockSetScheduleEnabled;

    setUp(() {
      mockSetDevicePower = MockSetDevicePower();
      mockSetScheduleEnabled = MockSetScheduleEnabled();
    });

    ClimatePowerBloc createPowerBloc() => ClimatePowerBloc(
          setDevicePower: mockSetDevicePower,
          setScheduleEnabled: mockSetScheduleEnabled,
        );

    group('initialization', () {
      test('initial state is not toggling', () {
        final bloc = createPowerBloc();

        expect(bloc.state.isTogglingPower, isFalse);
        expect(bloc.state.pendingPowerState, isNull);
        expect(bloc.state.isTogglingSchedule, isFalse);
        expect(bloc.state.pendingScheduleState, isNull);

        bloc.close();
      });
    });

    group('ClimatePowerToggleRequested', () {
      blocTest<ClimatePowerBloc, ClimatePowerState>(
        'calls setDevicePower and sets pending state',
        build: () {
          when(() => mockSetDevicePower(any()))
              .thenAnswer((_) async => testClimateOff);
          return createPowerBloc();
        },
        act: (bloc) => bloc
            .add(const ClimatePowerToggleRequested(isOn: false)),
        expect: () => [
          isA<ClimatePowerState>()
              .having(
                  (s) => s.isTogglingPower, 'isTogglingPower', true)
              .having((s) => s.pendingPowerState, 'pendingPowerState',
                  false),
        ],
        verify: (_) {
          verify(() => mockSetDevicePower(any())).called(1);
        },
      );

      blocTest<ClimatePowerBloc, ClimatePowerState>(
        'emits error on power toggle failure',
        build: () {
          when(() => mockSetDevicePower(any()))
              .thenThrow(Exception('Device offline'));
          return createPowerBloc();
        },
        act: (bloc) => bloc
            .add(const ClimatePowerToggleRequested(isOn: false)),
        expect: () => [
          // First emit: isTogglingPower = true (optimistic)
          isA<ClimatePowerState>()
              .having(
                  (s) => s.isTogglingPower, 'isTogglingPower', true),
          // Second emit: error + isTogglingPower = false
          isA<ClimatePowerState>()
              .having((s) => s.errorMessage, 'errorMessage',
                  contains('Power toggle error'))
              .having(
                  (s) => s.isTogglingPower, 'isTogglingPower', false),
        ],
      );
    });

    group('ClimatePowerSignalRReceived', () {
      blocTest<ClimatePowerBloc, ClimatePowerState>(
        'confirms pending power state on SignalR',
        build: createPowerBloc,
        seed: () => const ClimatePowerState(
          isTogglingPower: true,
          pendingPowerState: false,
        ),
        act: (bloc) => bloc.add(const ClimatePowerSignalRReceived(
          power: false,
          isScheduleEnabled: false,
        )),
        expect: () => [
          isA<ClimatePowerState>()
              .having(
                  (s) => s.isTogglingPower, 'isTogglingPower', false)
              .having(
                  (s) => s.pendingPowerState, 'pendingPowerState', isNull),
        ],
      );
    });

    group('ClimatePowerReset', () {
      blocTest<ClimatePowerBloc, ClimatePowerState>(
        'resets to initial state',
        build: createPowerBloc,
        seed: () => const ClimatePowerState(
          isTogglingPower: true,
          pendingPowerState: true,
          isTogglingSchedule: true,
          pendingScheduleState: true,
        ),
        act: (bloc) => bloc.add(const ClimatePowerReset()),
        expect: () => [const ClimatePowerState()],
      );
    });
  });

  // ===========================================================================
  // CLIMATE PARAMETERS BLOC
  // ===========================================================================

  group('ClimateParametersBloc', () {
    late MockSetTemperature mockSetTemperature;
    late MockSetCoolingTemperature mockSetCoolingTemperature;
    late MockSetHumidity mockSetHumidity;
    late MockSetClimateMode mockSetClimateMode;
    late MockSetOperatingMode mockSetOperatingMode;
    late MockSetPreset mockSetPreset;
    late MockSetAirflow mockSetAirflow;
    late MockSetModeSettings mockSetModeSettings;
    late MockSetQuickMode mockSetQuickMode;

    setUp(() {
      mockSetTemperature = MockSetTemperature();
      mockSetCoolingTemperature = MockSetCoolingTemperature();
      mockSetHumidity = MockSetHumidity();
      mockSetClimateMode = MockSetClimateMode();
      mockSetOperatingMode = MockSetOperatingMode();
      mockSetPreset = MockSetPreset();
      mockSetAirflow = MockSetAirflow();
      mockSetModeSettings = MockSetModeSettings();
      mockSetQuickMode = MockSetQuickMode();
    });

    ClimateParametersBloc createParametersBloc() =>
        ClimateParametersBloc(
          setTemperature: mockSetTemperature,
          setCoolingTemperature: mockSetCoolingTemperature,
          setHumidity: mockSetHumidity,
          setClimateMode: mockSetClimateMode,
          setOperatingMode: mockSetOperatingMode,
          setPreset: mockSetPreset,
          setAirflow: mockSetAirflow,
          setModeSettings: mockSetModeSettings,
          setQuickMode: mockSetQuickMode,
          getQuickModeParams: () => null,
        );

    group('initialization', () {
      test('initial state has no pending flags', () {
        final bloc = createParametersBloc();

        expect(bloc.state.isPendingHeatingTemperature, isFalse);
        expect(bloc.state.isPendingCoolingTemperature, isFalse);
        expect(bloc.state.isPendingSupplyFan, isFalse);
        expect(bloc.state.isPendingExhaustFan, isFalse);
        expect(bloc.state.isPendingOperatingMode, isFalse);

        bloc.close();
      });
    });

    group('ClimateParametersHeatingTempChanged', () {
      blocTest<ClimateParametersBloc, ClimateParametersState>(
        'sets pending heating temperature on UI change',
        build: createParametersBloc,
        act: (bloc) => bloc
            .add(const ClimateParametersHeatingTempChanged(21)),
        expect: () => [
          isA<ClimateParametersState>().having(
              (s) => s.pendingHeatingTemp,
              'pendingHeatingTemp',
              21),
        ],
      );
    });

    group('ClimateParametersCoolingTempChanged', () {
      blocTest<ClimateParametersBloc, ClimateParametersState>(
        'sets pending cooling temperature on UI change',
        build: createParametersBloc,
        act: (bloc) => bloc
            .add(const ClimateParametersCoolingTempChanged(25)),
        expect: () => [
          isA<ClimateParametersState>().having(
              (s) => s.pendingCoolingTemp,
              'pendingCoolingTemp',
              25),
        ],
      );
    });

    group('ClimateParametersSupplyAirflowChanged', () {
      blocTest<ClimateParametersBloc, ClimateParametersState>(
        'sets pending supply fan on UI change',
        build: createParametersBloc,
        act: (bloc) => bloc
            .add(const ClimateParametersSupplyAirflowChanged(80)),
        expect: () => [
          isA<ClimateParametersState>().having(
              (s) => s.pendingSupplyFan, 'pendingSupplyFan', 80),
        ],
      );
    });

    group('ClimateParametersExhaustAirflowChanged', () {
      blocTest<ClimateParametersBloc, ClimateParametersState>(
        'sets pending exhaust fan on UI change',
        build: createParametersBloc,
        act: (bloc) => bloc
            .add(const ClimateParametersExhaustAirflowChanged(70)),
        expect: () => [
          isA<ClimateParametersState>().having(
              (s) => s.pendingExhaustFan, 'pendingExhaustFan', 70),
        ],
      );
    });

    group('ClimateParametersSignalRReceived', () {
      blocTest<ClimateParametersBloc, ClimateParametersState>(
        'clears pending flags when SignalR confirms values',
        build: createParametersBloc,
        seed: () => const ClimateParametersState(
          isPendingHeatingTemperature: true,
          pendingHeatingTemp: 21,
          isPendingCoolingTemperature: true,
          pendingCoolingTemp: 25,
        ),
        act: (bloc) =>
            bloc.add(const ClimateParametersSignalRReceived(
          operatingMode: 'basic',
          modeSettings: {
            'basic': ModeSettings(
                heatingTemperature: 21, coolingTemperature: 25),
          },
        )),
        expect: () => [
          isA<ClimateParametersState>()
              .having((s) => s.isPendingHeatingTemperature,
                  'isPendingHeatingTemperature', false)
              .having((s) => s.isPendingCoolingTemperature,
                  'isPendingCoolingTemperature', false)
              .having((s) => s.pendingHeatingTemp,
                  'pendingHeatingTemp', isNull)
              .having((s) => s.pendingCoolingTemp,
                  'pendingCoolingTemp', isNull),
        ],
      );
    });

    group('ClimateParametersReset', () {
      blocTest<ClimateParametersBloc, ClimateParametersState>(
        'resets to initial state',
        build: createParametersBloc,
        seed: () => const ClimateParametersState(
          isPendingHeatingTemperature: true,
          pendingHeatingTemp: 21,
          isPendingSupplyFan: true,
          pendingSupplyFan: 80,
        ),
        act: (bloc) => bloc.add(const ClimateParametersReset()),
        expect: () => [const ClimateParametersState()],
      );
    });
  });

  // ===========================================================================
  // CLIMATE ALARMS BLOC
  // ===========================================================================

  group('ClimateAlarmsBloc', () {
    late MockGetAlarmHistory mockGetAlarmHistory;
    late MockResetAlarm mockResetAlarm;

    setUp(() {
      mockGetAlarmHistory = MockGetAlarmHistory();
      mockResetAlarm = MockResetAlarm();
    });

    ClimateAlarmsBloc createAlarmsBloc() => ClimateAlarmsBloc(
          getAlarmHistory: mockGetAlarmHistory,
          resetAlarm: mockResetAlarm,
        );

    group('initialization', () {
      test('initial state has empty history and alarms', () {
        final bloc = createAlarmsBloc();

        expect(bloc.state.alarmHistory, isEmpty);
        expect(bloc.state.activeAlarms, isEmpty);
        expect(bloc.state.isLoading, isFalse);
        expect(bloc.state.hasAlarms, isFalse);
        expect(bloc.state.alarmCount, 0);

        bloc.close();
      });
    });

    group('ClimateAlarmsHistoryRequested', () {
      blocTest<ClimateAlarmsBloc, ClimateAlarmsState>(
        'emits [loading, loaded] on successful history load',
        build: () {
          when(() => mockGetAlarmHistory(any()))
              .thenAnswer((_) async => <AlarmHistory>[]);
          return createAlarmsBloc();
        },
        act: (bloc) => bloc
            .add(const ClimateAlarmsHistoryRequested('device-1')),
        expect: () => [
          const ClimateAlarmsState(isLoading: true),
          const ClimateAlarmsState(),
        ],
        verify: (_) {
          verify(() => mockGetAlarmHistory(any())).called(1);
        },
      );

      blocTest<ClimateAlarmsBloc, ClimateAlarmsState>(
        'emits error on history load failure',
        build: () {
          when(() => mockGetAlarmHistory(any()))
              .thenThrow(Exception('Network error'));
          return createAlarmsBloc();
        },
        act: (bloc) => bloc
            .add(const ClimateAlarmsHistoryRequested('device-1')),
        expect: () => [
          const ClimateAlarmsState(isLoading: true),
          isA<ClimateAlarmsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage',
                  isNotNull),
        ],
      );
    });

    group('ClimateAlarmsActiveUpdated', () {
      blocTest<ClimateAlarmsBloc, ClimateAlarmsState>(
        'updates active alarms from SignalR',
        build: createAlarmsBloc,
        act: (bloc) => bloc.add(const ClimateAlarmsActiveUpdated({
          'alarm-1': AlarmInfo(code: 1, description: 'Test alarm'),
        })),
        expect: () => [
          isA<ClimateAlarmsState>()
              .having((s) => s.hasAlarms, 'hasAlarms', true)
              .having((s) => s.alarmCount, 'alarmCount', 1),
        ],
      );
    });

    group('ClimateAlarmsResetRequested', () {
      blocTest<ClimateAlarmsBloc, ClimateAlarmsState>(
        'resets active alarms after successful API call',
        build: () {
          when(() => mockResetAlarm(any()))
              .thenAnswer((_) async {});
          return createAlarmsBloc();
        },
        seed: () => const ClimateAlarmsState(
          activeAlarms: {
            'alarm-1':
                AlarmInfo(code: 1, description: 'Test alarm'),
          },
        ),
        act: (bloc) => bloc
            .add(const ClimateAlarmsResetRequested('device-1')),
        expect: () => [
          isA<ClimateAlarmsState>()
              .having((s) => s.hasAlarms, 'hasAlarms', false)
              .having((s) => s.activeAlarms, 'activeAlarms', isEmpty),
        ],
        verify: (_) {
          verify(() => mockResetAlarm(any())).called(1);
        },
      );
    });

    group('ClimateAlarmsReset', () {
      blocTest<ClimateAlarmsBloc, ClimateAlarmsState>(
        'resets to initial state',
        build: createAlarmsBloc,
        seed: () => const ClimateAlarmsState(
          activeAlarms: {
            'alarm-1':
                AlarmInfo(code: 1, description: 'Test alarm'),
          },
          isLoading: true,
        ),
        act: (bloc) => bloc.add(const ClimateAlarmsReset()),
        expect: () => [const ClimateAlarmsState()],
      );
    });
  });
}
