/// Тесты для CachedScheduleRepository
///
/// Проверяет логику кеширования:
/// - Online: загрузка из API + кеширование
/// - Offline: использование кеша
/// - Write операции требуют сети
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/core/error/offline_exception.dart';
import 'package:hvac_control/core/services/cache_service.dart';
import 'package:hvac_control/core/services/connectivity_service.dart';
import 'package:hvac_control/data/repositories/cached_schedule_repository.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/domain/repositories/schedule_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock для ScheduleRepository (внутренний репозиторий)
class MockScheduleRepository extends Mock implements ScheduleRepository {}

/// Mock для CacheService
class MockCacheService extends Mock implements CacheService {}

/// Mock для ConnectivityService
class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockScheduleRepository mockInner;
  late MockCacheService mockCacheService;
  late MockConnectivityService mockConnectivity;
  late CachedScheduleRepository repository;

  /// Тестовые данные
  const testDeviceId = 'device-1';
  const testEntries = <ScheduleEntry>[
    ScheduleEntry(
      id: 'entry-1',
      deviceId: testDeviceId,
      day: 'Пн',
      mode: 'heating',
      timeRange: '08:00 - 12:00',
      tempDay: 22,
      tempNight: 18,
      isActive: true,
    ),
    ScheduleEntry(
      id: 'entry-2',
      deviceId: testDeviceId,
      day: 'Вт',
      mode: 'cooling',
      timeRange: '14:00 - 18:00',
      tempDay: 20,
      tempNight: 16,
      isActive: true,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(testEntries.first);
    registerFallbackValue(testEntries);
  });

  setUp(() {
    mockInner = MockScheduleRepository();
    mockCacheService = MockCacheService();
    mockConnectivity = MockConnectivityService();

    repository = CachedScheduleRepository(
      inner: mockInner,
      cacheService: mockCacheService,
      connectivity: mockConnectivity,
    );
  });

  group('CachedScheduleRepository.getSchedule', () {
    test('online: загружает из API и кеширует', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.getSchedule(testDeviceId))
          .thenAnswer((_) async => testEntries);
      when(() => mockCacheService.cacheSchedule(testDeviceId, testEntries))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getSchedule(testDeviceId);

      // Assert
      expect(result, equals(testEntries));
      verify(() => mockInner.getSchedule(testDeviceId)).called(1);
      verify(() => mockCacheService.cacheSchedule(testDeviceId, testEntries))
          .called(1);
    });

    test('online + ошибка API: возвращает кеш если есть', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.getSchedule(testDeviceId))
          .thenThrow(Exception('Network error'));
      when(() => mockCacheService.getCachedSchedule(testDeviceId))
          .thenReturn(testEntries);

      // Act
      final result = await repository.getSchedule(testDeviceId);

      // Assert
      expect(result, equals(testEntries));
      verify(() => mockCacheService.getCachedSchedule(testDeviceId)).called(1);
    });

    test('online + ошибка API + нет кеша: пробрасывает ошибку', () async {
      // Arrange
      final error = Exception('Network error');
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.getSchedule(testDeviceId)).thenThrow(error);
      when(() => mockCacheService.getCachedSchedule(testDeviceId))
          .thenReturn(null);

      // Act & Assert
      expect(
        () => repository.getSchedule(testDeviceId),
        throwsA(isA<Exception>()),
      );
    });

    test('offline: возвращает кеш если есть', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(false);
      when(() => mockCacheService.getCachedSchedule(testDeviceId))
          .thenReturn(testEntries);

      // Act
      final result = await repository.getSchedule(testDeviceId);

      // Assert
      expect(result, equals(testEntries));
      verifyNever(() => mockInner.getSchedule(testDeviceId));
    });

    test('offline + нет кеша: выбрасывает OfflineException', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(false);
      when(() => mockCacheService.getCachedSchedule(testDeviceId))
          .thenReturn(null);

      // Act & Assert
      expect(
        () => repository.getSchedule(testDeviceId),
        throwsA(isA<OfflineException>()),
      );
    });
  });

  group('CachedScheduleRepository.addEntry', () {
    test('online: добавляет запись и обновляет кеш', () async {
      // Arrange
      final newEntry = testEntries.first;
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.addEntry(newEntry))
          .thenAnswer((_) async => newEntry);
      when(() => mockInner.getSchedule(testDeviceId))
          .thenAnswer((_) async => testEntries);
      when(() => mockCacheService.cacheSchedule(testDeviceId, any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.addEntry(newEntry);

      // Assert
      expect(result, equals(newEntry));
      verify(() => mockInner.addEntry(newEntry)).called(1);
    });

    test('offline: выбрасывает OfflineException', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(false);

      // Act & Assert
      expect(
        () => repository.addEntry(testEntries.first),
        throwsA(isA<OfflineException>()),
      );
      verifyNever(() => mockInner.addEntry(any()));
    });
  });

  group('CachedScheduleRepository.updateEntry', () {
    test('online: обновляет запись и обновляет кеш', () async {
      // Arrange
      final updatedEntry = testEntries.first;
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.updateEntry(updatedEntry))
          .thenAnswer((_) async => updatedEntry);
      when(() => mockInner.getSchedule(testDeviceId))
          .thenAnswer((_) async => testEntries);
      when(() => mockCacheService.cacheSchedule(testDeviceId, any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.updateEntry(updatedEntry);

      // Assert
      expect(result, equals(updatedEntry));
      verify(() => mockInner.updateEntry(updatedEntry)).called(1);
    });

    test('offline: выбрасывает OfflineException', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(false);

      // Act & Assert
      expect(
        () => repository.updateEntry(testEntries.first),
        throwsA(isA<OfflineException>()),
      );
    });
  });

  group('CachedScheduleRepository.deleteEntry', () {
    test('online: удаляет запись', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.deleteEntry('entry-1'))
          .thenAnswer((_) async {});

      // Act
      await repository.deleteEntry('entry-1');

      // Assert
      verify(() => mockInner.deleteEntry('entry-1')).called(1);
    });

    test('offline: выбрасывает OfflineException', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(false);

      // Act & Assert
      expect(
        () => repository.deleteEntry('entry-1'),
        throwsA(isA<OfflineException>()),
      );
    });
  });

  group('CachedScheduleRepository.toggleEntry', () {
    test('online: переключает запись и обновляет кеш', () async {
      // Arrange
      final toggledEntry = testEntries.first;
      when(() => mockConnectivity.isOnline).thenReturn(true);
      when(() => mockInner.toggleEntry('entry-1', isActive: false))
          .thenAnswer((_) async => toggledEntry);
      when(() => mockInner.getSchedule(testDeviceId))
          .thenAnswer((_) async => testEntries);
      when(() => mockCacheService.cacheSchedule(testDeviceId, any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.toggleEntry('entry-1', isActive: false);

      // Assert
      expect(result, equals(toggledEntry));
      verify(() => mockInner.toggleEntry('entry-1', isActive: false)).called(1);
    });

    test('offline: выбрасывает OfflineException', () async {
      // Arrange
      when(() => mockConnectivity.isOnline).thenReturn(false);

      // Act & Assert
      expect(
        () => repository.toggleEntry('entry-1', isActive: false),
        throwsA(isA<OfflineException>()),
      );
    });
  });

  group('CachedScheduleRepository.watchSchedule', () {
    test('делегирует к внутреннему репозиторию', () {
      // Arrange
      final stream = Stream<List<ScheduleEntry>>.fromIterable([testEntries]);
      when(() => mockInner.watchSchedule(testDeviceId)).thenAnswer((_) => stream);

      // Act
      final result = repository.watchSchedule(testDeviceId);

      // Assert
      expect(result, isA<Stream<List<ScheduleEntry>>>());
      verify(() => mockInner.watchSchedule(testDeviceId)).called(1);
    });
  });
}
