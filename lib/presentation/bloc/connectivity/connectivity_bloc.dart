/// Connectivity BLoC — мониторинг сетевого соединения
///
/// Отвечает за:
/// - Отслеживание состояния сети
/// - Отображение баннера при проблемах с соединением
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/connectivity_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

/// BLoC для мониторинга сетевого соединения
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;

  StreamSubscription<NetworkStatus>? _statusSubscription;

  ConnectivityBloc({
    required ConnectivityService connectivityService,
  })  : _connectivityService = connectivityService,
        super(const ConnectivityState()) {
    on<ConnectivitySubscriptionRequested>(_onSubscriptionRequested);
    on<ConnectivityStatusChanged>(_onStatusChanged);
  }

  /// Запрос на подписку к статусу соединения
  Future<void> _onSubscriptionRequested(
    ConnectivitySubscriptionRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Получаем текущий статус
    final currentStatus = _connectivityService.status;
    emit(_mapStatusToState(currentStatus));

    // Подписываемся на изменения
    await _statusSubscription?.cancel();
    _statusSubscription = _connectivityService.onStatusChange.listen(
      (status) => add(ConnectivityStatusChanged(status)),
      onError: (error) {
        // При ошибке стрима считаем что сеть недоступна
        add(const ConnectivityStatusChanged(NetworkStatus.offline));
      },
    );
  }

  /// Изменение статуса соединения
  void _onStatusChanged(
    ConnectivityStatusChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(_mapStatusToState(event.status));
  }

  /// Преобразование NetworkStatus в ConnectivityState
  ConnectivityState _mapStatusToState(NetworkStatus status) {
    return ConnectivityState(
      status: status,
      isOffline: status == NetworkStatus.offline,
      isServerUnavailable: status == NetworkStatus.serverUnavailable,
    );
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
