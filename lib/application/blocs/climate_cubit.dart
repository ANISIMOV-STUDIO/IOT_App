import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/climate.dart';
import '../../domain/repositories/climate_repository.dart';

// ============================================
// STATE
// ============================================

enum ClimateStatus { initial, loading, success, failure }

class ClimateCubitState extends Equatable {
  final ClimateStatus status;
  final ClimateState? climate;
  final String? errorMessage;

  const ClimateCubitState({
    this.status = ClimateStatus.initial,
    this.climate,
    this.errorMessage,
  });

  ClimateCubitState copyWith({
    ClimateStatus? status,
    ClimateState? climate,
    String? errorMessage,
  }) {
    return ClimateCubitState(
      status: status ?? this.status,
      climate: climate ?? this.climate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Геттеры для удобства
  double get temperature => climate?.targetTemperature ?? 22;
  double get humidity => climate?.humidity ?? 50;
  ClimateMode get mode => climate?.mode ?? ClimateMode.auto;
  AirQualityLevel get airQuality => climate?.airQuality ?? AirQualityLevel.good;
  int get co2 => climate?.co2Ppm ?? 400;
  int get aqi => climate?.pollutantsAqi ?? 50;
  bool get isOn => climate?.isOn ?? false;

  @override
  List<Object?> get props => [status, climate, errorMessage];
}

// ============================================
// CUBIT
// ============================================

class ClimateCubit extends Cubit<ClimateCubitState> {
  final ClimateRepository _repository;
  StreamSubscription<ClimateState>? _subscription;

  ClimateCubit(this._repository) : super(const ClimateCubitState());

  /// Загрузить состояние климата
  Future<void> loadClimate() async {
    emit(state.copyWith(status: ClimateStatus.loading));
    
    try {
      final climate = await _repository.getCurrentState();
      emit(state.copyWith(
        status: ClimateStatus.success,
        climate: climate,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClimateStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Установить температуру
  Future<void> setTemperature(double temperature) async {
    try {
      final updated = await _repository.setTargetTemperature(temperature);
      emit(state.copyWith(climate: updated));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Установить влажность
  Future<void> setHumidity(double humidity) async {
    try {
      final updated = await _repository.setHumidity(humidity);
      emit(state.copyWith(climate: updated));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Установить режим
  Future<void> setMode(ClimateMode mode) async {
    try {
      final updated = await _repository.setMode(mode);
      emit(state.copyWith(climate: updated));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Включить/выключить
  Future<void> toggle() async {
    try {
      final newMode = state.isOn ? ClimateMode.off : ClimateMode.auto;
      final updated = await _repository.setMode(newMode);
      emit(state.copyWith(climate: updated));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Подписаться на обновления
  void watchClimate() {
    _subscription?.cancel();
    _subscription = _repository.watchClimate().listen((climate) {
      emit(state.copyWith(
        status: ClimateStatus.success,
        climate: climate,
      ));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
