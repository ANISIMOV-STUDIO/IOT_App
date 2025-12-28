/// Базовый репозиторий с общей логикой для всех Real repositories
///
/// Предоставляет:
/// - Управление StreamController
/// - Dispose pattern
/// - Timer управление для polling
library;

import 'dart:async';

/// Абстрактный базовый репозиторий
///
/// [T] - тип данных, которые хранятся в stream
abstract class BaseRepository<T> {
  /// Stream controller для данных
  final StreamController<T> _controller = StreamController<T>.broadcast();

  /// Timer для polling (опционально)
  Timer? _pollTimer;

  /// Получить stream данных
  Stream<T> get stream => _controller.stream;

  /// Добавить данные в stream
  void addToStream(T data) {
    if (!_controller.isClosed) {
      _controller.add(data);
    }
  }

  /// Добавить ошибку в stream
  void addErrorToStream(Object error, [StackTrace? stackTrace]) {
    if (!_controller.isClosed) {
      _controller.addError(error, stackTrace);
    }
  }

  /// Начать polling с заданным интервалом
  ///
  /// [interval] - интервал между вызовами
  /// [callback] - функция, которая будет вызываться
  void startPolling(Duration interval, Future<void> Function() callback) {
    _pollTimer?.cancel(); // Отменить предыдущий таймер

    _pollTimer = Timer.periodic(interval, (_) {
      callback();
    });

    // Немедленный вызов для начальной загрузки
    callback();
  }

  /// Остановить polling
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Очистить ресурсы
  ///
  /// Должен быть вызван при уничтожении repository
  void dispose() {
    stopPolling();
    _controller.close();
  }

  /// Проверить, закрыт ли stream
  bool get isClosed => _controller.isClosed;
}
