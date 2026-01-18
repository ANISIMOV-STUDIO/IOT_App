/// Исключение для offline режима
///
/// Выбрасывается когда операция требует сетевого подключения,
/// но устройство находится в offline режиме.
library;

/// Исключение при попытке выполнить операцию без сети
class OfflineException implements Exception {

  const OfflineException(this.message, {this.operation});
  /// Описание операции, которую не удалось выполнить
  final String message;

  /// Название операции (для логирования)
  final String? operation;

  @override
  String toString() {
    if (operation != null) {
      return 'OfflineException[$operation]: $message';
    }
    return 'OfflineException: $message';
  }
}
