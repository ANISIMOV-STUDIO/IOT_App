part of 'connectivity_bloc.dart';

/// Состояние сетевого соединения
final class ConnectivityState extends Equatable {
  /// Текущий статус сети
  final NetworkStatus status;

  /// Нет подключения к интернету
  final bool isOffline;

  /// Сервер недоступен
  final bool isServerUnavailable;

  /// Сообщение для пользователя
  final String? message;

  const ConnectivityState({
    this.status = NetworkStatus.unknown,
    this.isOffline = false,
    this.isServerUnavailable = false,
    this.message,
  });

  /// Показывать ли баннер о проблемах с соединением
  bool get showBanner => isOffline || isServerUnavailable;

  /// Есть ли соединение
  bool get isOnline => status == NetworkStatus.online;

  @override
  List<Object?> get props => [status, isOffline, isServerUnavailable, message];
}
