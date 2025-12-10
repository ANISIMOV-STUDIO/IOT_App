/// Мок-репозиторий климат-контроля
library;

import 'dart:async';
import '../../domain/entities/climate.dart';
import '../../domain/repositories/climate_repository.dart';

class MockClimateRepository implements ClimateRepository {
  final _climateController = StreamController<ClimateState>.broadcast();

  ClimateState _state = const ClimateState(
    roomId: 'main',
    currentTemperature: 21.5,
    targetTemperature: 22.0,
    humidity: 60.0,
    mode: ClimateMode.heating,
    airQuality: AirQualityLevel.good,
    co2Ppm: 874,
    pollutantsAqi: 60,
    isOn: true,
  );

  @override
  Future<ClimateState> getCurrentState() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _state;
  }

  @override
  Future<ClimateState> setTargetTemperature(double temperature) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(targetTemperature: temperature);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setHumidity(double humidity) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(humidity: humidity);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setMode(ClimateMode mode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(mode: mode, isOn: mode != ClimateMode.off);
    _climateController.add(_state);
    return _state;
  }

  @override
  Stream<ClimateState> watchClimate() {
    Future.microtask(() => _climateController.add(_state));
    return _climateController.stream;
  }

  void dispose() {
    _climateController.close();
  }
}
