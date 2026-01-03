part of 'connectivity_bloc.dart';

/// События для ConnectivityBloc
sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

/// Запрос на подписку к статусу соединения
final class ConnectivitySubscriptionRequested extends ConnectivityEvent {
  const ConnectivitySubscriptionRequested();
}

/// Статус соединения изменился
final class ConnectivityStatusChanged extends ConnectivityEvent {
  final NetworkStatus status;

  const ConnectivityStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}
