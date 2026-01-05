/// NotificationsBloc Unit Tests
///
/// Тестирование управления уведомлениями
library;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/domain/usecases/usecases.dart';
import 'package:hvac_control/presentation/bloc/notifications/notifications_bloc.dart';

// Mock classes for Use Cases
class MockGetNotifications extends Mock implements GetNotifications {}

class MockWatchNotifications extends Mock implements WatchNotifications {}

class MockMarkNotificationAsRead extends Mock
    implements MarkNotificationAsRead {}

class MockDismissNotification extends Mock implements DismissNotification {}

void main() {
  late MockGetNotifications mockGetNotifications;
  late MockWatchNotifications mockWatchNotifications;
  late MockMarkNotificationAsRead mockMarkNotificationAsRead;
  late MockDismissNotification mockDismissNotification;

  // Test data
  final testNotification1 = UnitNotification(
    id: 'notif-1',
    deviceId: 'device-1',
    title: 'Фильтр требует замены',
    message: 'Ресурс фильтра исчерпан на 95%',
    type: NotificationType.warning,
    timestamp: DateTime(2024, 1, 15, 10, 30),
    isRead: false,
  );

  final testNotification2 = UnitNotification(
    id: 'notif-2',
    deviceId: 'device-1',
    title: 'Устройство включено',
    message: 'Бризер Гостиная запущен',
    type: NotificationType.info,
    timestamp: DateTime(2024, 1, 15, 9, 0),
    isRead: true,
  );

  final testNotifications = [testNotification1, testNotification2];

  setUpAll(() {
    registerFallbackValue(const GetNotificationsParams());
    registerFallbackValue(const WatchNotificationsParams());
    registerFallbackValue(
        const MarkNotificationAsReadParams(notificationId: ''));
    registerFallbackValue(const DismissNotificationParams(notificationId: ''));
  });

  setUp(() {
    mockGetNotifications = MockGetNotifications();
    mockWatchNotifications = MockWatchNotifications();
    mockMarkNotificationAsRead = MockMarkNotificationAsRead();
    mockDismissNotification = MockDismissNotification();
  });

  NotificationsBloc createBloc() => NotificationsBloc(
        getNotifications: mockGetNotifications,
        watchNotifications: mockWatchNotifications,
        markNotificationAsRead: mockMarkNotificationAsRead,
        dismissNotification: mockDismissNotification,
      );

  group('NotificationsBloc', () {
    group('Инициализация', () {
      test('начальное состояние - NotificationsState с initial статусом', () {
        when(() => mockWatchNotifications(any()))
            .thenAnswer((_) => const Stream.empty());

        final bloc = createBloc();

        expect(bloc.state.status, NotificationsStatus.initial);
        expect(bloc.state.notifications, isEmpty);
        expect(bloc.state.unreadCount, 0);

        bloc.close();
      });
    });

    group('NotificationsSubscriptionRequested', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'эмитит [loading, success] при успешной загрузке',
        build: () {
          when(() => mockGetNotifications(any()))
              .thenAnswer((_) async => testNotifications);
          when(() => mockWatchNotifications(any()))
              .thenAnswer((_) => const Stream.empty());
          return createBloc();
        },
        act: (bloc) => bloc.add(const NotificationsSubscriptionRequested()),
        expect: () => [
          const NotificationsState(status: NotificationsStatus.loading),
          NotificationsState(
            status: NotificationsStatus.success,
            notifications: testNotifications,
          ),
        ],
        verify: (_) {
          verify(() => mockGetNotifications(any())).called(1);
          verify(() => mockWatchNotifications(any())).called(1);
        },
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'эмитит [loading, failure] при ошибке',
        build: () {
          when(() => mockGetNotifications(any()))
              .thenThrow(Exception('Network error'));
          return createBloc();
        },
        act: (bloc) => bloc.add(const NotificationsSubscriptionRequested()),
        expect: () => [
          const NotificationsState(status: NotificationsStatus.loading),
          isA<NotificationsState>()
              .having((s) => s.status, 'status', NotificationsStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('NotificationsDeviceChanged', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'загружает уведомления для выбранного устройства',
        build: () {
          when(() => mockGetNotifications(any()))
              .thenAnswer((_) async => [testNotification1]);
          when(() => mockWatchNotifications(any()))
              .thenAnswer((_) => const Stream.empty());
          return createBloc();
        },
        act: (bloc) => bloc.add(const NotificationsDeviceChanged('device-1')),
        expect: () => [
          const NotificationsState(status: NotificationsStatus.loading),
          NotificationsState(
            status: NotificationsStatus.success,
            notifications: [testNotification1],
            currentDeviceId: 'device-1',
          ),
        ],
      );
    });

    group('NotificationsListUpdated', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'обновляет список уведомлений из стрима',
        build: () => createBloc(),
        seed: () => NotificationsState(
          status: NotificationsStatus.success,
          notifications: [testNotification1],
        ),
        act: (bloc) => bloc.add(NotificationsListUpdated(testNotifications)),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.success,
            notifications: testNotifications,
          ),
        ],
      );
    });

    group('NotificationsMarkAsReadRequested', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'отмечает уведомление как прочитанное',
        build: () {
          when(() => mockMarkNotificationAsRead(any()))
              .thenAnswer((_) async {});
          return createBloc();
        },
        seed: () => NotificationsState(
          status: NotificationsStatus.success,
          notifications: [testNotification1],
        ),
        act: (bloc) =>
            bloc.add(const NotificationsMarkAsReadRequested('notif-1')),
        expect: () => [
          isA<NotificationsState>()
              .having((s) => s.notifications.first.isRead, 'isRead', isTrue),
        ],
        verify: (_) {
          verify(() => mockMarkNotificationAsRead(any())).called(1);
        },
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'эмитит ошибку при неудачной отметке',
        build: () {
          when(() => mockMarkNotificationAsRead(any()))
              .thenThrow(Exception('Failed'));
          return createBloc();
        },
        seed: () => NotificationsState(
          status: NotificationsStatus.success,
          notifications: [testNotification1],
        ),
        act: (bloc) =>
            bloc.add(const NotificationsMarkAsReadRequested('notif-1')),
        expect: () => [
          isA<NotificationsState>()
              .having((s) => s.errorMessage, 'errorMessage', contains('Mark notification error')),
        ],
      );
    });

    group('NotificationsMarkAllAsReadRequested', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'отмечает все уведомления как прочитанные',
        build: () {
          when(() => mockMarkNotificationAsRead(any()))
              .thenAnswer((_) async {});
          return createBloc();
        },
        seed: () => NotificationsState(
          status: NotificationsStatus.success,
          notifications: testNotifications,
        ),
        act: (bloc) => bloc.add(const NotificationsMarkAllAsReadRequested()),
        expect: () => [
          isA<NotificationsState>().having(
            (s) => s.notifications.every((n) => n.isRead),
            'all isRead',
            isTrue,
          ),
        ],
        verify: (_) {
          // Только testNotification1 был непрочитан
          verify(() => mockMarkNotificationAsRead(any())).called(1);
        },
      );
    });

    group('NotificationsDismissRequested', () {
      blocTest<NotificationsBloc, NotificationsState>(
        'удаляет уведомление из списка',
        build: () {
          when(() => mockDismissNotification(any())).thenAnswer((_) async {});
          return createBloc();
        },
        seed: () => NotificationsState(
          status: NotificationsStatus.success,
          notifications: testNotifications,
        ),
        act: (bloc) =>
            bloc.add(const NotificationsDismissRequested('notif-1')),
        expect: () => [
          NotificationsState(
            status: NotificationsStatus.success,
            notifications: [testNotification2],
          ),
        ],
        verify: (_) {
          verify(() => mockDismissNotification(any())).called(1);
        },
      );

      blocTest<NotificationsBloc, NotificationsState>(
        'эмитит ошибку при неудачном удалении',
        build: () {
          when(() => mockDismissNotification(any()))
              .thenThrow(Exception('Failed'));
          return createBloc();
        },
        seed: () => NotificationsState(
          status: NotificationsStatus.success,
          notifications: testNotifications,
        ),
        act: (bloc) =>
            bloc.add(const NotificationsDismissRequested('notif-1')),
        expect: () => [
          isA<NotificationsState>().having(
              (s) => s.errorMessage, 'errorMessage', contains('Delete notification error')),
        ],
      );
    });

    group('NotificationsState', () {
      test('unreadCount возвращает количество непрочитанных', () {
        final state = NotificationsState(
          status: NotificationsStatus.success,
          notifications: testNotifications,
        );

        expect(state.unreadCount, 1); // testNotification1 unread
      });

      test('hasUnread возвращает true когда есть непрочитанные', () {
        final state = NotificationsState(
          status: NotificationsStatus.success,
          notifications: testNotifications,
        );

        expect(state.hasUnread, isTrue);
      });

      test('hasUnread возвращает false когда все прочитаны', () {
        final state = NotificationsState(
          status: NotificationsStatus.success,
          notifications: [testNotification2], // only read notification
        );

        expect(state.hasUnread, isFalse);
      });
    });
  });
}
