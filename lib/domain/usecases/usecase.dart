/// Базовый класс для Use Cases
///
/// Use Case инкапсулирует бизнес-логику и координирует поток данных.
/// Presentation layer вызывает Use Case, а не Repository напрямую.
library;

/// Базовый класс для Use Case без параметров
abstract class UseCase<T> {
  /// Выполнить use case
  Future<T> call();
}

/// Базовый класс для Use Case с параметрами
abstract class UseCaseWithParams<T, Params> {
  /// Выполнить use case с параметрами
  Future<T> call(Params params);
}

/// Базовый класс для Stream Use Case (для подписок)
abstract class StreamUseCase<T> {
  /// Получить stream данных
  Stream<T> call();
}

/// Базовый класс для Stream Use Case с параметрами
abstract class StreamUseCaseWithParams<T, Params> {
  /// Получить stream данных с параметрами
  Stream<T> call(Params params);
}

/// Маркер для Use Case без параметров
class NoParams {
  const NoParams();
}
