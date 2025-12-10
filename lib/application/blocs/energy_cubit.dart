import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/energy_stats.dart';
import '../../domain/repositories/energy_repository.dart';

// ============================================
// STATE
// ============================================

enum EnergyStatus { initial, loading, success, failure }

class EnergyState extends Equatable {
  final EnergyStatus status;
  final EnergyStats? stats;
  final List<DeviceEnergyUsage> deviceUsage;
  final String? errorMessage;

  const EnergyState({
    this.status = EnergyStatus.initial,
    this.stats,
    this.deviceUsage = const [],
    this.errorMessage,
  });

  EnergyState copyWith({
    EnergyStatus? status,
    EnergyStats? stats,
    List<DeviceEnergyUsage>? deviceUsage,
    String? errorMessage,
  }) {
    return EnergyState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      deviceUsage: deviceUsage ?? this.deviceUsage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Геттеры
  double get totalKwh => stats?.totalKwh ?? 0;
  int get totalHours => stats?.totalHours ?? 0;
  List<HourlyUsage> get hourlyData => stats?.hourlyData ?? [];

  @override
  List<Object?> get props => [status, stats, deviceUsage, errorMessage];
}

// ============================================
// CUBIT
// ============================================

class EnergyCubit extends Cubit<EnergyState> {
  final EnergyRepository _repository;
  StreamSubscription<EnergyStats>? _subscription;

  EnergyCubit(this._repository) : super(const EnergyState());

  /// Загрузить статистику за сегодня
  Future<void> loadTodayStats() async {
    emit(state.copyWith(status: EnergyStatus.loading));
    
    try {
      final stats = await _repository.getTodayStats();
      final deviceUsage = await _repository.getDevicePowerUsage();
      
      emit(state.copyWith(
        status: EnergyStatus.success,
        stats: stats,
        deviceUsage: deviceUsage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EnergyStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Загрузить статистику за период
  Future<void> loadStats(DateTime from, DateTime to) async {
    emit(state.copyWith(status: EnergyStatus.loading));
    
    try {
      final stats = await _repository.getStats(from, to);
      emit(state.copyWith(
        status: EnergyStatus.success,
        stats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EnergyStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Подписаться на обновления
  void watchStats() {
    _subscription?.cancel();
    _subscription = _repository.watchStats().listen((stats) {
      emit(state.copyWith(
        status: EnergyStatus.success,
        stats: stats,
      ));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
