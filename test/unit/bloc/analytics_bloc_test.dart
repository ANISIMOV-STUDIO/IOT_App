/// AnalyticsBloc Unit Tests
///
/// Тестирование статистики и графиков
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/domain/entities/energy_stats.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';
import 'package:hvac_control/domain/repositories/energy_repository.dart';
import 'package:hvac_control/domain/repositories/graph_data_repository.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';

// Mock classes
class MockEnergyRepository extends Mock implements EnergyRepository {}

class MockGraphDataRepository extends Mock implements GraphDataRepository {}

void main() {
  late MockEnergyRepository mockEnergyRepository;
  late MockGraphDataRepository mockGraphDataRepository;

  // Test data - using late final to avoid const issues with DateTime
  late EnergyStats testEnergyStats;
  late List<DeviceEnergyUsage> testPowerUsage;
  const testGraphData = <GraphDataPoint>[
    GraphDataPoint(label: '10:00', value: 22.5),
    GraphDataPoint(label: '11:00', value: 23.0),
    GraphDataPoint(label: '12:00', value: 22.8),
  ];

  setUp(() {
    mockEnergyRepository = MockEnergyRepository();
    mockGraphDataRepository = MockGraphDataRepository();

    testEnergyStats = EnergyStats(
      totalKwh: 15.5,
      totalHours: 120,
      date: DateTime(2024, 1, 15),
    );

    testPowerUsage = const [
      DeviceEnergyUsage(
        deviceId: 'device-1',
        deviceName: 'Бризер',
        deviceType: 'ventilation',
        unitCount: 1,
        totalKwh: 10.0,
      ),
      DeviceEnergyUsage(
        deviceId: 'device-2',
        deviceName: 'Кондиционер',
        deviceType: 'airConditioner',
        unitCount: 1,
        totalKwh: 5.5,
      ),
    ];
  });

  setUpAll(() {
    registerFallbackValue(GraphMetric.temperature);
    registerFallbackValue(DateTime.now());
  });

  group('AnalyticsBloc', () {
    group('Инициализация', () {
      test('начальное состояние - AnalyticsState с initial статусом', () {
        when(() => mockEnergyRepository.watchStats())
            .thenAnswer((_) => const Stream.empty());

        final bloc = AnalyticsBloc(
          energyRepository: mockEnergyRepository,
          graphDataRepository: mockGraphDataRepository,
        );

        expect(bloc.state.status, AnalyticsStatus.initial);
        expect(bloc.state.energyStats, isNull);
        expect(bloc.state.graphData, isEmpty);

        bloc.close();
      });
    });

    group('AnalyticsSubscriptionRequested', () {
      blocTest<AnalyticsBloc, AnalyticsState>(
        'эмитит [loading, success] при успешной загрузке',
        setUp: () {
          testEnergyStats = EnergyStats(
            totalKwh: 15.5,
            totalHours: 120,
            date: DateTime(2024, 1, 15),
          );
        },
        build: () {
          when(() => mockEnergyRepository.getTodayStats())
              .thenAnswer((_) async => testEnergyStats);
          when(() => mockEnergyRepository.getDevicePowerUsage())
              .thenAnswer((_) async => testPowerUsage);
          when(() => mockEnergyRepository.watchStats())
              .thenAnswer((_) => const Stream.empty());
          return AnalyticsBloc(
            energyRepository: mockEnergyRepository,
            graphDataRepository: mockGraphDataRepository,
          );
        },
        act: (bloc) => bloc.add(const AnalyticsSubscriptionRequested()),
        expect: () => [
          const AnalyticsState(status: AnalyticsStatus.loading),
          isA<AnalyticsState>()
              .having((s) => s.status, 'status', AnalyticsStatus.success)
              .having((s) => s.energyStats?.totalKwh, 'totalKwh', 15.5)
              .having((s) => s.powerUsage.length, 'powerUsage length', 2),
        ],
        verify: (_) {
          verify(() => mockEnergyRepository.getTodayStats()).called(1);
          verify(() => mockEnergyRepository.getDevicePowerUsage()).called(1);
          verify(() => mockEnergyRepository.watchStats()).called(1);
        },
      );

      blocTest<AnalyticsBloc, AnalyticsState>(
        'эмитит [loading, failure] при ошибке',
        build: () {
          when(() => mockEnergyRepository.getTodayStats())
              .thenThrow(Exception('Network error'));
          when(() => mockEnergyRepository.getDevicePowerUsage())
              .thenAnswer((_) async => []);
          return AnalyticsBloc(
            energyRepository: mockEnergyRepository,
            graphDataRepository: mockGraphDataRepository,
          );
        },
        act: (bloc) => bloc.add(const AnalyticsSubscriptionRequested()),
        expect: () => [
          const AnalyticsState(status: AnalyticsStatus.loading),
          isA<AnalyticsState>()
              .having((s) => s.status, 'status', AnalyticsStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('AnalyticsDeviceChanged', () {
      blocTest<AnalyticsBloc, AnalyticsState>(
        'загружает график для выбранного устройства',
        build: () {
          when(() => mockGraphDataRepository.getGraphData(
                deviceId: any(named: 'deviceId'),
                metric: any(named: 'metric'),
                from: any(named: 'from'),
                to: any(named: 'to'),
              )).thenAnswer((_) async => testGraphData);
          when(() => mockGraphDataRepository.watchGraphData(
                deviceId: any(named: 'deviceId'),
                metric: any(named: 'metric'),
              )).thenAnswer((_) => const Stream.empty());
          return AnalyticsBloc(
            energyRepository: mockEnergyRepository,
            graphDataRepository: mockGraphDataRepository,
          );
        },
        seed: () => const AnalyticsState(status: AnalyticsStatus.success),
        act: (bloc) => bloc.add(const AnalyticsDeviceChanged('device-1')),
        expect: () => [
          const AnalyticsState(
            status: AnalyticsStatus.success,
            currentDeviceId: 'device-1',
          ),
          const AnalyticsState(
            status: AnalyticsStatus.success,
            currentDeviceId: 'device-1',
            graphData: testGraphData,
          ),
        ],
      );
    });

    group('AnalyticsGraphMetricChanged', () {
      blocTest<AnalyticsBloc, AnalyticsState>(
        'обновляет метрику и перезагружает график',
        build: () {
          when(() => mockGraphDataRepository.getGraphData(
                deviceId: any(named: 'deviceId'),
                metric: any(named: 'metric'),
                from: any(named: 'from'),
                to: any(named: 'to'),
              )).thenAnswer((_) async => testGraphData);
          return AnalyticsBloc(
            energyRepository: mockEnergyRepository,
            graphDataRepository: mockGraphDataRepository,
          );
        },
        seed: () => const AnalyticsState(
          status: AnalyticsStatus.success,
          currentDeviceId: 'device-1',
          selectedMetric: GraphMetric.temperature,
        ),
        act: (bloc) => bloc.add(const AnalyticsGraphMetricChanged(GraphMetric.humidity)),
        expect: () => [
          const AnalyticsState(
            status: AnalyticsStatus.success,
            currentDeviceId: 'device-1',
            selectedMetric: GraphMetric.humidity,
          ),
          const AnalyticsState(
            status: AnalyticsStatus.success,
            currentDeviceId: 'device-1',
            selectedMetric: GraphMetric.humidity,
            graphData: testGraphData,
          ),
        ],
      );
    });

    group('AnalyticsEnergyStatsUpdated', () {
      blocTest<AnalyticsBloc, AnalyticsState>(
        'обновляет статистику из стрима',
        setUp: () {
          testEnergyStats = EnergyStats(
            totalKwh: 15.5,
            totalHours: 120,
            date: DateTime(2024, 1, 15),
          );
        },
        build: () => AnalyticsBloc(
          energyRepository: mockEnergyRepository,
          graphDataRepository: mockGraphDataRepository,
        ),
        seed: () => AnalyticsState(
          status: AnalyticsStatus.success,
          energyStats: EnergyStats(
            totalKwh: 10.0,
            totalHours: 100,
            date: DateTime(2024, 1, 14),
          ),
        ),
        act: (bloc) => bloc.add(AnalyticsEnergyStatsUpdated(testEnergyStats)),
        expect: () => [
          isA<AnalyticsState>()
              .having((s) => s.status, 'status', AnalyticsStatus.success)
              .having((s) => s.energyStats?.totalKwh, 'totalKwh', 15.5),
        ],
      );
    });

    group('AnalyticsGraphDataUpdated', () {
      blocTest<AnalyticsBloc, AnalyticsState>(
        'обновляет данные графика из стрима',
        build: () => AnalyticsBloc(
          energyRepository: mockEnergyRepository,
          graphDataRepository: mockGraphDataRepository,
        ),
        seed: () => const AnalyticsState(status: AnalyticsStatus.success),
        act: (bloc) => bloc.add(const AnalyticsGraphDataUpdated(testGraphData)),
        expect: () => [
          const AnalyticsState(
            status: AnalyticsStatus.success,
            graphData: testGraphData,
          ),
        ],
      );
    });

    group('AnalyticsState', () {
      test('totalKwh возвращает значение из energyStats', () {
        final state = AnalyticsState(
          status: AnalyticsStatus.success,
          energyStats: testEnergyStats,
        );

        expect(state.totalKwh, 15.5);
      });

      test('totalKwh возвращает 0 когда energyStats null', () {
        const state = AnalyticsState(status: AnalyticsStatus.initial);

        expect(state.totalKwh, 0.0);
      });

      test('hasGraphData возвращает true когда есть данные', () {
        const state = AnalyticsState(
          status: AnalyticsStatus.success,
          graphData: testGraphData,
        );

        expect(state.hasGraphData, isTrue);
      });

      test('hasGraphData возвращает false для пустого списка', () {
        const state = AnalyticsState(
          status: AnalyticsStatus.success,
          graphData: [],
        );

        expect(state.hasGraphData, isFalse);
      });

      test('isLoading возвращает true при загрузке', () {
        const state = AnalyticsState(status: AnalyticsStatus.loading);

        expect(state.isLoading, isTrue);
      });
    });
  });
}
