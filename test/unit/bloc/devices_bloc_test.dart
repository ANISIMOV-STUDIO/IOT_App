/// DevicesBloc Unit Tests
///
/// Тестирование управления списком HVAC устройств
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/core/error/api_exception.dart';
import 'package:hvac_control/domain/entities/hvac_device.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';

// Mock classes for Use Cases
class MockGetAllHvacDevices extends Mock implements GetAllHvacDevices {}

class MockWatchHvacDevices extends Mock implements WatchHvacDevices {}

class MockRegisterDevice extends Mock implements RegisterDevice {}

class MockDeleteDevice extends Mock implements DeleteDevice {}

class MockRenameDevice extends Mock implements RenameDevice {}

class MockSetDevicePower extends Mock implements SetDevicePower {}

class MockSetDeviceTime extends Mock implements SetDeviceTime {}

void main() {
  late MockGetAllHvacDevices mockGetAllHvacDevices;
  late MockWatchHvacDevices mockWatchHvacDevices;
  late MockRegisterDevice mockRegisterDevice;
  late MockDeleteDevice mockDeleteDevice;
  late MockRenameDevice mockRenameDevice;
  late MockSetDevicePower mockSetDevicePower;
  late MockSetDeviceTime mockSetDeviceTime;
  late void Function(String) mockSetSelectedDevice;
  late List<String> selectedDeviceCalls;

  // Test data
  const testDevice1 = HvacDevice(
    id: 'device-1',
    name: 'Бризер Гостиная',
    brand: 'Breez',
    isOnline: true,
  );

  const testDevice2 = HvacDevice(
    id: 'device-2',
    name: 'Бризер Спальня',
    brand: 'Breez',
    isOnline: false,
  );

  final testDevices = [testDevice1, testDevice2];

  setUpAll(() {
    registerFallbackValue(const RegisterDeviceParams(macAddress: '', name: ''));
    registerFallbackValue(const DeleteDeviceParams(deviceId: ''));
    registerFallbackValue(const RenameDeviceParams(deviceId: '', newName: ''));
    registerFallbackValue(SetDeviceTimeParams(deviceId: '', time: DateTime(2024)));
  });

  setUp(() {
    mockGetAllHvacDevices = MockGetAllHvacDevices();
    mockWatchHvacDevices = MockWatchHvacDevices();
    mockRegisterDevice = MockRegisterDevice();
    mockDeleteDevice = MockDeleteDevice();
    mockRenameDevice = MockRenameDevice();
    mockSetDevicePower = MockSetDevicePower();
    mockSetDeviceTime = MockSetDeviceTime();
    selectedDeviceCalls = [];
    mockSetSelectedDevice = (deviceId) => selectedDeviceCalls.add(deviceId);
  });

  DevicesBloc createBloc() => DevicesBloc(
        getAllHvacDevices: mockGetAllHvacDevices,
        watchHvacDevices: mockWatchHvacDevices,
        registerDevice: mockRegisterDevice,
        deleteDevice: mockDeleteDevice,
        renameDevice: mockRenameDevice,
        setDevicePower: mockSetDevicePower,
        setDeviceTime: mockSetDeviceTime,
        setSelectedDevice: mockSetSelectedDevice,
      );

  group('DevicesBloc', () {
    group('Инициализация', () {
      test('начальное состояние - DevicesState с initial статусом', () {
        when(() => mockWatchHvacDevices())
            .thenAnswer((_) => const Stream.empty());

        final bloc = createBloc();

        expect(bloc.state.status, DevicesStatus.initial);
        expect(bloc.state.devices, isEmpty);
        expect(bloc.state.selectedDeviceId, isNull);

        bloc.close();
      });
    });

    group('DevicesSubscriptionRequested', () {
      blocTest<DevicesBloc, DevicesState>(
        'эмитит [loading, success] с устройствами при успешной загрузке',
        build: () {
          when(() => mockGetAllHvacDevices())
              .thenAnswer((_) async => testDevices);
          when(() => mockWatchHvacDevices())
              .thenAnswer((_) => const Stream.empty());
          return createBloc();
        },
        act: (bloc) => bloc.add(const DevicesSubscriptionRequested()),
        expect: () => [
          const DevicesState(status: DevicesStatus.loading),
          DevicesState(
            status: DevicesStatus.success,
            devices: testDevices,
            selectedDeviceId: testDevice1.id,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllHvacDevices()).called(1);
          expect(selectedDeviceCalls, [testDevice1.id]);
          verify(() => mockWatchHvacDevices()).called(1);
        },
      );

      blocTest<DevicesBloc, DevicesState>(
        'эмитит [loading, success] с пустым списком когда устройств нет',
        build: () {
          when(() => mockGetAllHvacDevices()).thenAnswer((_) async => []);
          when(() => mockWatchHvacDevices())
              .thenAnswer((_) => const Stream.empty());
          return createBloc();
        },
        act: (bloc) => bloc.add(const DevicesSubscriptionRequested()),
        expect: () => [
          const DevicesState(status: DevicesStatus.loading),
          const DevicesState(
            status: DevicesStatus.success,
            devices: [],
            selectedDeviceId: null,
          ),
        ],
        verify: (_) {
          expect(selectedDeviceCalls, isEmpty);
        },
      );

      blocTest<DevicesBloc, DevicesState>(
        'эмитит [loading, failure] при ошибке загрузки',
        build: () {
          when(() => mockGetAllHvacDevices())
              .thenThrow(Exception('Network error'));
          return createBloc();
        },
        act: (bloc) => bloc.add(const DevicesSubscriptionRequested()),
        expect: () => [
          const DevicesState(status: DevicesStatus.loading),
          isA<DevicesState>()
              .having((s) => s.status, 'status', DevicesStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('DevicesDeviceSelected', () {
      blocTest<DevicesBloc, DevicesState>(
        'обновляет selectedDeviceId при выборе устройства',
        build: () => createBloc(),
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(DevicesDeviceSelected(testDevice2.id)),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: testDevices,
            selectedDeviceId: testDevice2.id,
          ),
        ],
        verify: (_) {
          expect(selectedDeviceCalls, [testDevice2.id]);
        },
      );
    });

    group('DevicesListUpdated', () {
      blocTest<DevicesBloc, DevicesState>(
        'обновляет список устройств из стрима',
        build: () => createBloc(),
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: [testDevice1],
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(DevicesListUpdated(testDevices)),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: testDevices,
            selectedDeviceId: testDevice1.id,
          ),
        ],
      );
    });

    group('DevicesRegistrationRequested', () {
      blocTest<DevicesBloc, DevicesState>(
        'эмитит [isRegistering=true, success с новым устройством] при успешной регистрации',
        build: () {
          when(() => mockRegisterDevice(any()))
              .thenAnswer((_) async => testDevice2);
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: [testDevice1],
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(const DevicesRegistrationRequested(
          macAddress: 'AA:BB:CC:DD:EE:FF',
          name: 'Бризер Спальня',
        )),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: [testDevice1],
            selectedDeviceId: testDevice1.id,
            isRegistering: true,
          ),
          DevicesState(
            status: DevicesStatus.success,
            devices: [testDevice1, testDevice2],
            selectedDeviceId: testDevice2.id,
            isRegistering: false,
          ),
        ],
        verify: (_) {
          verify(() => mockRegisterDevice(any())).called(1);
        },
      );

      blocTest<DevicesBloc, DevicesState>(
        'эмитит ошибку регистрации при ApiException',
        build: () {
          when(() => mockRegisterDevice(any()))
              .thenThrow(const ApiException(
            type: ApiErrorType.validation,
            message: 'Устройство уже зарегистрировано',
          ));
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: [testDevice1],
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(const DevicesRegistrationRequested(
          macAddress: 'AA:BB:CC:DD:EE:FF',
          name: 'Бризер',
        )),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: [testDevice1],
            selectedDeviceId: testDevice1.id,
            isRegistering: true,
          ),
          DevicesState(
            status: DevicesStatus.success,
            devices: [testDevice1],
            selectedDeviceId: testDevice1.id,
            isRegistering: false,
            registrationError: 'Устройство уже зарегистрировано',
          ),
        ],
      );
    });

    group('DevicesRegistrationErrorCleared', () {
      blocTest<DevicesBloc, DevicesState>(
        'очищает ошибку регистрации',
        build: () => createBloc(),
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: [testDevice1],
          selectedDeviceId: testDevice1.id,
          registrationError: 'Какая-то ошибка',
        ),
        act: (bloc) => bloc.add(const DevicesRegistrationErrorCleared()),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: [testDevice1],
            selectedDeviceId: testDevice1.id,
            registrationError: null,
          ),
        ],
      );
    });

    group('DevicesDeletionRequested', () {
      blocTest<DevicesBloc, DevicesState>(
        'удаляет устройство и выбирает следующее',
        build: () {
          when(() => mockDeleteDevice(any())).thenAnswer((_) async {});
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(DevicesDeletionRequested(testDevice1.id)),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: [testDevice2],
            selectedDeviceId: testDevice2.id,
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteDevice(any())).called(1);
          expect(selectedDeviceCalls, [testDevice2.id]);
        },
      );

      blocTest<DevicesBloc, DevicesState>(
        'удаляет последнее устройство и сбрасывает выбор',
        build: () {
          when(() => mockDeleteDevice(any())).thenAnswer((_) async {});
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: [testDevice1],
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(DevicesDeletionRequested(testDevice1.id)),
        expect: () => [
          const DevicesState(
            status: DevicesStatus.success,
            devices: [],
            selectedDeviceId: null,
          ),
        ],
      );

      blocTest<DevicesBloc, DevicesState>(
        'эмитит ошибку при неудачном удалении',
        build: () {
          when(() => mockDeleteDevice(any())).thenThrow(const ApiException(
            type: ApiErrorType.serverError,
            message: 'Ошибка сервера',
          ));
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(DevicesDeletionRequested(testDevice1.id)),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: testDevices,
            selectedDeviceId: testDevice1.id,
            operationError: 'Ошибка сервера',
          ),
        ],
      );
    });

    group('DevicesRenameRequested', () {
      blocTest<DevicesBloc, DevicesState>(
        'переименовывает устройство',
        build: () {
          when(() => mockRenameDevice(any())).thenAnswer((_) async {});
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(const DevicesRenameRequested(
          deviceId: 'device-1',
          newName: 'Бризер Кухня',
        )),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: [
              testDevice1.copyWith(name: 'Бризер Кухня'),
              testDevice2,
            ],
            selectedDeviceId: testDevice1.id,
          ),
        ],
        verify: (_) {
          verify(() => mockRenameDevice(any())).called(1);
        },
      );

      blocTest<DevicesBloc, DevicesState>(
        'эмитит ошибку при неудачном переименовании',
        build: () {
          when(() => mockRenameDevice(any())).thenThrow(const ApiException(
            type: ApiErrorType.validation,
            message: 'Имя слишком короткое',
          ));
          return createBloc();
        },
        seed: () => DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: testDevice1.id,
        ),
        act: (bloc) => bloc.add(const DevicesRenameRequested(
          deviceId: 'device-1',
          newName: 'A',
        )),
        expect: () => [
          DevicesState(
            status: DevicesStatus.success,
            devices: testDevices,
            selectedDeviceId: testDevice1.id,
            operationError: 'Имя слишком короткое',
          ),
        ],
      );
    });

    group('DevicesState', () {
      test('selectedDevice возвращает выбранное устройство', () {
        final state = DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: testDevice2.id,
        );

        expect(state.selectedDevice, testDevice2);
      });

      test('selectedDevice возвращает первое устройство если выбранное не найдено', () {
        final state = DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
          selectedDeviceId: 'non-existent',
        );

        expect(state.selectedDevice, testDevice1);
      });

      test('selectedDevice возвращает null для пустого списка', () {
        const state = DevicesState(
          status: DevicesStatus.success,
          devices: [],
          selectedDeviceId: 'device-1',
        );

        expect(state.selectedDevice, isNull);
      });

      test('hasDevices возвращает true когда есть устройства', () {
        final state = DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
        );

        expect(state.hasDevices, isTrue);
      });

      test('hasDevices возвращает false для пустого списка', () {
        const state = DevicesState(
          status: DevicesStatus.success,
          devices: [],
        );

        expect(state.hasDevices, isFalse);
      });

      test('onlineCount возвращает количество онлайн устройств', () {
        final state = DevicesState(
          status: DevicesStatus.success,
          devices: testDevices,
        );

        expect(state.onlineCount, 1); // testDevice1 online, testDevice2 offline
      });
    });
  });
}
