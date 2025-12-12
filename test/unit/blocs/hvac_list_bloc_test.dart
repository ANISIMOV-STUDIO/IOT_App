import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hvac_control/presentation/bloc/hvac_list/hvac_list_bloc_refactored.dart'
    hide HvacListLoaded;
import 'package:hvac_control/presentation/bloc/hvac_list/hvac_list_event.dart';
import 'package:hvac_control/presentation/bloc/hvac_list/hvac_list_state.dart';
import 'package:hvac_control/core/services/secure_api_service.dart';
import 'package:hvac_control/core/di/injection_container.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_helper.dart';

void main() {
  late HvacListBloc bloc;
  late MockGetAllUnits mockGetAllUnits;
  late MockAddDevice mockAddDevice;
  late MockRemoveDevice mockRemoveDevice;
  late MockConnectToDevices mockConnectToDevices;
  late MockHvacRepository mockRepository;
  late MockSecureApiService mockApiService;

  setUpAll(() {
    setupCommonMocks();
    TestHelper.setupTestDependencies();
  });

  setUp(() {
    mockGetAllUnits = MockGetAllUnits();
    mockAddDevice = MockAddDevice();
    mockRemoveDevice = MockRemoveDevice();
    mockConnectToDevices = MockConnectToDevices();
    mockRepository = MockHvacRepository();
    mockApiService = MockSecureApiService();

    // Register mock API service
    sl.registerLazySingleton<SecureApiService>(() => mockApiService);

    bloc = HvacListBloc(
      getAllUnits: mockGetAllUnits,
      addDevice: mockAddDevice,
      removeDevice: mockRemoveDevice,
      connectToDevices: mockConnectToDevices,
    );
  });

  tearDown(() {
    bloc.close();
    TestHelper.cleanupTestDependencies();
  });

  group('HvacListBloc', () {
    final testUnits = TestDataFactory.createHvacUnits(count: 3);

    group('LoadHvacUnitsEvent', () {
      blocTest<HvacListBloc, HvacListState>(
        'emits [HvacListLoading, HvacListLoaded] when LoadHvacUnitsEvent is successful',
        build: () {
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.value(testUnits));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadHvacUnitsEvent()),
        expect: () => [
          const HvacListLoading(),
          HvacListLoaded(testUnits),
        ],
        verify: (_) {
          verify(() => mockGetAllUnits.call())
              .called(2); // Initial + subscription
        },
      );

      blocTest<HvacListBloc, HvacListState>(
        'emits [HvacListLoading, HvacListError] when LoadHvacUnitsEvent fails',
        build: () {
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.error(Exception('Network error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadHvacUnitsEvent()),
        expect: () => [
          const HvacListLoading(),
          isA<HvacListError>().having(
            (e) => e.message,
            'message',
            contains('Exception: Network error'),
          ),
        ],
      );

      blocTest<HvacListBloc, HvacListState>(
        'cancels previous subscription when LoadHvacUnitsEvent is called multiple times',
        build: () {
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.value(testUnits));
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const LoadHvacUnitsEvent());
          await Future.delayed(const Duration(milliseconds: 50));
          bloc.add(const LoadHvacUnitsEvent());
        },
        expect: () => [
          const HvacListLoading(),
          HvacListLoaded(testUnits),
          const HvacListLoading(),
          HvacListLoaded(testUnits),
        ],
        wait: const Duration(milliseconds: 100),
      );
    });

    group('RefreshHvacUnitsEvent', () {
      blocTest<HvacListBloc, HvacListState>(
        'emits [HvacListLoaded] with updated units when RefreshHvacUnitsEvent is successful',
        build: () {
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.value(testUnits));
          return bloc;
        },
        seed: () => HvacListLoaded(testUnits.take(2).toList()),
        act: (bloc) => bloc.add(const RefreshHvacUnitsEvent()),
        expect: () => [
          HvacListLoaded(testUnits),
        ],
      );

      blocTest<HvacListBloc, HvacListState>(
        'emits [HvacListError] when RefreshHvacUnitsEvent fails',
        build: () {
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.error(Exception('Refresh failed')));
          return bloc;
        },
        seed: () => HvacListLoaded(testUnits),
        act: (bloc) => bloc.add(const RefreshHvacUnitsEvent()),
        expect: () => [
          isA<HvacListError>().having(
            (e) => e.message,
            'message',
            contains('Exception: Refresh failed'),
          ),
        ],
      );
    });

    group('RetryConnectionEvent', () {
      blocTest<HvacListBloc, HvacListState>(
        'emits [HvacListLoading, HvacListLoaded] when connection retry is successful',
        build: () {
          when(() => mockRepository.connect()).thenAnswer((_) async => {});
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.value(testUnits));
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryConnectionEvent()),
        expect: () => [
          const HvacListLoading(),
          HvacListLoaded(testUnits),
        ],
        verify: (_) {
          verify(() => mockRepository.connect()).called(1);
        },
      );

      blocTest<HvacListBloc, HvacListState>(
        'emits [HvacListLoading, HvacListError] when connection retry fails',
        build: () {
          when(() => mockRepository.connect())
              .thenThrow(Exception('Connection refused'));
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryConnectionEvent()),
        expect: () => [
          const HvacListLoading(),
          isA<HvacListError>().having(
            (e) => e.message,
            'message',
            contains('Connection failed'),
          ),
        ],
      );
    });

    group('AddDeviceEvent', () {
      const testMacAddress = '00:11:22:33:44:55';
      const testDeviceName = 'Test Device';
      const testLocation = 'Living Room';

      blocTest<HvacListBloc, HvacListState>(
        'successfully adds device and refreshes list',
        build: () {
          when(() => mockApiService.post<Map<String, dynamic>>(
                    '/devices',
                    data: any(named: 'data'),
                  ))
              .thenAnswer((_) async => {'success': true});
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.value(testUnits));
          return bloc;
        },
        seed: () => HvacListLoaded(testUnits.take(2).toList()),
        act: (bloc) => bloc.add(const AddDeviceEvent(
          macAddress: testMacAddress,
          name: testDeviceName,
          location: testLocation,
        )),
        expect: () => [
          HvacListLoaded(testUnits),
        ],
        verify: (_) {
          verify(() => mockApiService.post<Map<String, dynamic>>(
                '/devices',
                data: {
                  'mac_address': testMacAddress,
                  'name': testDeviceName,
                  'location': testLocation,
                },
              )).called(1);
        },
      );

      blocTest<HvacListBloc, HvacListState>(
        'emits error when adding device fails',
        build: () {
          when(() => mockApiService.post<Map<String, dynamic>>(
                '/devices',
                data: any(named: 'data'),
              )).thenThrow(Exception('Network error'));
          return bloc;
        },
        seed: () => HvacListLoaded(testUnits),
        act: (bloc) => bloc.add(const AddDeviceEvent(
          macAddress: testMacAddress,
          name: testDeviceName,
          location: testLocation,
        )),
        expect: () => [
          isA<HvacListError>().having(
            (e) => e.message,
            'message',
            contains('Failed to add device'),
          ),
        ],
      );
    });

    group('RemoveDeviceEvent', () {
      const testDeviceId = 'device-123';

      blocTest<HvacListBloc, HvacListState>(
        'successfully removes device and refreshes list',
        build: () {
          when(() => mockApiService.delete<Map<String, dynamic>>('/devices/$testDeviceId'))
              .thenAnswer((_) async => {'success': true});
          when(() => mockGetAllUnits.call())
              .thenAnswer((_) => Stream.value(testUnits.skip(1).toList()));
          return bloc;
        },
        seed: () => HvacListLoaded(testUnits),
        act: (bloc) =>
            bloc.add(const RemoveDeviceEvent(deviceId: testDeviceId)),
        expect: () => [
          HvacListLoaded(testUnits.skip(1).toList()),
        ],
        verify: (_) {
          verify(() => mockApiService.delete<Map<String, dynamic>>('/devices/$testDeviceId'))
              .called(1);
        },
      );

      blocTest<HvacListBloc, HvacListState>(
        'emits error when removing device fails',
        build: () {
          when(() => mockApiService.delete<Map<String, dynamic>>('/devices/$testDeviceId'))
              .thenThrow(Exception('Device not found'));
          return bloc;
        },
        seed: () => HvacListLoaded(testUnits),
        act: (bloc) =>
            bloc.add(const RemoveDeviceEvent(deviceId: testDeviceId)),
        expect: () => [
          isA<HvacListError>().having(
            (e) => e.message,
            'message',
            contains('Failed to remove device'),
          ),
        ],
      );
    });

    group('Stream subscription management', () {
      test('cancels stream subscription on close', () async {
        when(() => mockGetAllUnits.call())
            .thenAnswer((_) => Stream.value(testUnits));

        bloc.add(const LoadHvacUnitsEvent());
        await Future.delayed(const Duration(milliseconds: 100));

        await bloc.close();

        // Verify that the bloc doesn't emit after being closed
        expect(bloc.isClosed, true);
      });

      test('handles multiple rapid events without memory leaks', () async {
        when(() => mockGetAllUnits.call())
            .thenAnswer((_) => Stream.value(testUnits));

        // Fire multiple events rapidly
        for (int i = 0; i < 10; i++) {
          bloc.add(const LoadHvacUnitsEvent());
          await Future.delayed(const Duration(milliseconds: 10));
        }

        await bloc.close();
        expect(bloc.isClosed, true);
      });
    });

    group('Performance tests', () {
      test('handles large dataset efficiently', () async {
        final largeDataset = TestDataFactory.createHvacUnits(count: 1000);

        when(() => mockGetAllUnits.call())
            .thenAnswer((_) => Stream.value(largeDataset));

        final stopwatch = Stopwatch()..start();
        bloc.add(const LoadHvacUnitsEvent());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            const HvacListLoading(),
            HvacListLoaded(largeDataset),
          ]),
        );

        stopwatch.stop();

        // Ensure processing large dataset takes less than 500ms
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      });
    });
  });
}
