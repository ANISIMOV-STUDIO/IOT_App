/// ClimateBloc Unit Tests
///
/// Тестирование управления климатом устройства
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/domain/entities/climate.dart';
import 'package:hvac_control/domain/repositories/climate_repository.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';

// Mock classes
class MockClimateRepository extends Mock implements ClimateRepository {}

void main() {
  late MockClimateRepository mockRepository;

  // Test data
  const testClimate = ClimateState(
    roomId: 'room-1',
    deviceName: 'Бризер Гостиная',
    currentTemperature: 22.5,
    targetTemperature: 23.0,
    humidity: 45.0,
    mode: ClimateMode.auto,
    airQuality: AirQualityLevel.good,
    isOn: true,
  );

  const testClimateOff = ClimateState(
    roomId: 'room-1',
    deviceName: 'Бризер Гостиная',
    currentTemperature: 22.5,
    targetTemperature: 23.0,
    humidity: 45.0,
    mode: ClimateMode.auto,
    airQuality: AirQualityLevel.good,
    isOn: false,
  );

  setUp(() {
    mockRepository = MockClimateRepository();
  });

  setUpAll(() {
    registerFallbackValue(ClimateMode.auto);
  });

  group('ClimateBloc', () {
    group('Инициализация', () {
      test('начальное состояние - ClimateControlState с initial статусом', () {
        when(() => mockRepository.watchClimate())
            .thenAnswer((_) => const Stream.empty());

        final bloc = ClimateBloc(climateRepository: mockRepository);

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
          when(() => mockRepository.getCurrentState())
              .thenAnswer((_) async => testClimate);
          when(() => mockRepository.watchClimate())
              .thenAnswer((_) => const Stream.empty());
          return ClimateBloc(climateRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const ClimateSubscriptionRequested()),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          ClimateControlState(
            status: ClimateControlStatus.success,
            climate: testClimate,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getCurrentState()).called(1);
          verify(() => mockRepository.watchClimate()).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит [loading, failure] при ошибке загрузки',
        build: () {
          when(() => mockRepository.getCurrentState())
              .thenThrow(Exception('Network error'));
          return ClimateBloc(climateRepository: mockRepository);
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
          when(() => mockRepository.getDeviceState(any()))
              .thenAnswer((_) async => testClimate);
          when(() => mockRepository.getDeviceFullState(any()))
              .thenThrow(Exception('Not implemented')); // Опционально
          return ClimateBloc(climateRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const ClimateDeviceChanged('device-2')),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          ClimateControlState(
            status: ClimateControlStatus.success,
            climate: testClimate,
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.getDeviceState('device-2')).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит [loading, failure] при ошибке загрузки устройства',
        build: () {
          when(() => mockRepository.getDeviceState(any()))
              .thenThrow(Exception('Device not found'));
          return ClimateBloc(climateRepository: mockRepository);
        },
        act: (bloc) => bloc.add(const ClimateDeviceChanged('unknown')),
        expect: () => [
          const ClimateControlState(status: ClimateControlStatus.loading),
          isA<ClimateControlState>()
              .having((s) => s.status, 'status', ClimateControlStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', contains('Ошибка загрузки')),
        ],
      );
    });

    group('ClimateStateUpdated', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'обновляет состояние климата из стрима',
        build: () => ClimateBloc(climateRepository: mockRepository),
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(ClimateStateUpdated(testClimateOff)),
        expect: () => [
          ClimateControlState(
            status: ClimateControlStatus.success,
            climate: testClimateOff,
          ),
        ],
      );
    });

    group('ClimatePowerToggled', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setPower на репозитории',
        build: () {
          when(() => mockRepository.setPower(any()))
              .thenAnswer((_) async => testClimateOff);
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimatePowerToggled(false)),
        verify: (_) {
          verify(() => mockRepository.setPower(false)).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит ошибку при неудачном переключении',
        build: () {
          when(() => mockRepository.setPower(any()))
              .thenThrow(Exception('Device offline'));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimatePowerToggled(false)),
        expect: () => [
          isA<ClimateControlState>()
              .having((s) => s.errorMessage, 'errorMessage', contains('переключения питания')),
        ],
      );
    });

    group('ClimateTemperatureChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setTargetTemperature на репозитории',
        build: () {
          when(() => mockRepository.setTargetTemperature(any()))
              .thenAnswer((_) async => testClimate.copyWith(targetTemperature: 25.0));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateTemperatureChanged(25.0)),
        verify: (_) {
          verify(() => mockRepository.setTargetTemperature(25.0)).called(1);
        },
      );

      blocTest<ClimateBloc, ClimateControlState>(
        'эмитит ошибку при неудачной установке температуры',
        build: () {
          when(() => mockRepository.setTargetTemperature(any()))
              .thenThrow(Exception('Invalid value'));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateTemperatureChanged(100.0)),
        expect: () => [
          isA<ClimateControlState>()
              .having((s) => s.errorMessage, 'errorMessage', contains('температуры')),
        ],
      );
    });

    group('ClimateHumidityChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setHumidity на репозитории',
        build: () {
          when(() => mockRepository.setHumidity(any()))
              .thenAnswer((_) async => testClimate.copyWith(targetHumidity: 60.0));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateHumidityChanged(60.0)),
        verify: (_) {
          verify(() => mockRepository.setHumidity(60.0)).called(1);
        },
      );
    });

    group('ClimateModeChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setMode на репозитории',
        build: () {
          when(() => mockRepository.setMode(any()))
              .thenAnswer((_) async => testClimate.copyWith(mode: ClimateMode.cooling));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateModeChanged(ClimateMode.cooling)),
        verify: (_) {
          verify(() => mockRepository.setMode(ClimateMode.cooling)).called(1);
        },
      );
    });

    group('ClimatePresetChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setPreset на репозитории',
        build: () {
          when(() => mockRepository.setPreset(any()))
              .thenAnswer((_) async => testClimate.copyWith(preset: 'turbo'));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimatePresetChanged('turbo')),
        verify: (_) {
          verify(() => mockRepository.setPreset('turbo')).called(1);
        },
      );
    });

    group('ClimateSupplyAirflowChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setSupplyAirflow на репозитории',
        build: () {
          when(() => mockRepository.setSupplyAirflow(any()))
              .thenAnswer((_) async => testClimate.copyWith(supplyAirflow: 80.0));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateSupplyAirflowChanged(80.0)),
        verify: (_) {
          verify(() => mockRepository.setSupplyAirflow(80.0)).called(1);
        },
      );
    });

    group('ClimateExhaustAirflowChanged', () {
      blocTest<ClimateBloc, ClimateControlState>(
        'вызывает setExhaustAirflow на репозитории',
        build: () {
          when(() => mockRepository.setExhaustAirflow(any()))
              .thenAnswer((_) async => testClimate.copyWith(exhaustAirflow: 70.0));
          return ClimateBloc(climateRepository: mockRepository);
        },
        seed: () => ClimateControlState(
          status: ClimateControlStatus.success,
          climate: testClimate,
        ),
        act: (bloc) => bloc.add(const ClimateExhaustAirflowChanged(70.0)),
        verify: (_) {
          verify(() => mockRepository.setExhaustAirflow(70.0)).called(1);
        },
      );
    });

    group('ClimateControlState', () {
      test('геттеры возвращают значения из climate', () {
        final state = ClimateControlState(
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
          status: ClimateControlStatus.initial,
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
