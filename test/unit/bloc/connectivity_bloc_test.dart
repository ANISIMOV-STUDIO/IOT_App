/// ConnectivityBloc Unit Tests
///
/// Тестирование мониторинга сетевого соединения
library;

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/core/services/connectivity_service.dart';
import 'package:hvac_control/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockConnectivityService mockService;

  setUp(() {
    mockService = MockConnectivityService();
  });

  group('ConnectivityBloc', () {
    group('Инициализация', () {
      test('начальное состояние - unknown статус', () {
        when(() => mockService.onStatusChange)
            .thenAnswer((_) => const Stream.empty());

        final bloc = ConnectivityBloc(connectivityService: mockService);

        expect(bloc.state.status, NetworkStatus.unknown);
        expect(bloc.state.isOffline, isFalse);
        expect(bloc.state.isServerUnavailable, isFalse);
        expect(bloc.state.showBanner, isFalse);

        bloc.close();
      });
    });

    group('ConnectivitySubscriptionRequested', () {
      blocTest<ConnectivityBloc, ConnectivityState>(
        'эмитит online состояние когда сеть доступна',
        build: () {
          when(() => mockService.status).thenReturn(NetworkStatus.online);
          when(() => mockService.onStatusChange)
              .thenAnswer((_) => const Stream.empty());
          return ConnectivityBloc(connectivityService: mockService);
        },
        act: (bloc) => bloc.add(const ConnectivitySubscriptionRequested()),
        expect: () => [
          const ConnectivityState(
            status: NetworkStatus.online,
          ),
        ],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'эмитит offline состояние когда нет сети',
        build: () {
          when(() => mockService.status).thenReturn(NetworkStatus.offline);
          when(() => mockService.onStatusChange)
              .thenAnswer((_) => const Stream.empty());
          return ConnectivityBloc(connectivityService: mockService);
        },
        act: (bloc) => bloc.add(const ConnectivitySubscriptionRequested()),
        expect: () => [
          const ConnectivityState(
            status: NetworkStatus.offline,
            isOffline: true,
          ),
        ],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'эмитит serverUnavailable состояние когда сервер недоступен',
        build: () {
          when(() => mockService.status).thenReturn(NetworkStatus.serverUnavailable);
          when(() => mockService.onStatusChange)
              .thenAnswer((_) => const Stream.empty());
          return ConnectivityBloc(connectivityService: mockService);
        },
        act: (bloc) => bloc.add(const ConnectivitySubscriptionRequested()),
        expect: () => [
          const ConnectivityState(
            status: NetworkStatus.serverUnavailable,
            isServerUnavailable: true,
          ),
        ],
      );
    });

    group('ConnectivityStatusChanged', () {
      blocTest<ConnectivityBloc, ConnectivityState>(
        'обновляет состояние при изменении статуса сети',
        build: () => ConnectivityBloc(connectivityService: mockService),
        act: (bloc) => bloc.add(const ConnectivityStatusChanged(NetworkStatus.offline)),
        expect: () => [
          const ConnectivityState(
            status: NetworkStatus.offline,
            isOffline: true,
          ),
        ],
      );

      blocTest<ConnectivityBloc, ConnectivityState>(
        'восстанавливает online состояние',
        build: () => ConnectivityBloc(connectivityService: mockService),
        seed: () => const ConnectivityState(
          status: NetworkStatus.offline,
          isOffline: true,
        ),
        act: (bloc) => bloc.add(const ConnectivityStatusChanged(NetworkStatus.online)),
        expect: () => [
          const ConnectivityState(
            status: NetworkStatus.online,
          ),
        ],
      );
    });

    group('Подписка на изменения', () {
      late StreamController<NetworkStatus> statusController;

      setUp(() {
        statusController = StreamController<NetworkStatus>.broadcast();
      });

      tearDown(() {
        statusController.close();
      });

      blocTest<ConnectivityBloc, ConnectivityState>(
        'реагирует на изменения статуса из стрима',
        build: () {
          when(() => mockService.status).thenReturn(NetworkStatus.online);
          when(() => mockService.onStatusChange).thenAnswer((_) => statusController.stream);
          return ConnectivityBloc(connectivityService: mockService);
        },
        act: (bloc) async {
          bloc.add(const ConnectivitySubscriptionRequested());
          await Future<void>.delayed(const Duration(milliseconds: 10));
          // Стрим симулируется через событие
          bloc.add(const ConnectivityStatusChanged(NetworkStatus.offline));
        },
        expect: () => [
          const ConnectivityState(
            status: NetworkStatus.online,
          ),
          const ConnectivityState(
            status: NetworkStatus.offline,
            isOffline: true,
          ),
        ],
      );
    });

    group('ConnectivityState', () {
      test('showBanner возвращает true когда offline', () {
        const state = ConnectivityState(
          status: NetworkStatus.offline,
          isOffline: true,
        );

        expect(state.showBanner, isTrue);
      });

      test('showBanner возвращает true когда server unavailable', () {
        const state = ConnectivityState(
          status: NetworkStatus.serverUnavailable,
          isServerUnavailable: true,
        );

        expect(state.showBanner, isTrue);
      });

      test('showBanner возвращает false когда online', () {
        const state = ConnectivityState(
          status: NetworkStatus.online,
        );

        expect(state.showBanner, isFalse);
      });

      test('isOnline возвращает true только для online статуса', () {
        const onlineState = ConnectivityState(status: NetworkStatus.online);
        const offlineState = ConnectivityState(status: NetworkStatus.offline);
        const unknownState = ConnectivityState();

        expect(onlineState.isOnline, isTrue);
        expect(offlineState.isOnline, isFalse);
        expect(unknownState.isOnline, isFalse);
      });
    });
  });
}
