/// Мок-репозиторий климат-контроля
library;

import 'dart:async';
import '../../domain/entities/climate.dart';
import '../../domain/repositories/climate_repository.dart';

class MockClimateRepository implements ClimateRepository {
  final _climateController = StreamController<ClimateState>.broadcast();

  ClimateState _state = const ClimateState(
    roomId: 'main',
    deviceName: 'ZILON ZPE-6000',
    currentTemperature: 21.5,
    targetTemperature: 22.0,
    humidity: 58.0,
    targetHumidity: 50.0,
    supplyAirflow: 65.0,
    exhaustAirflow: 50.0,
    mode: ClimateMode.heating,
    preset: 'auto',
    airQuality: AirQualityLevel.good,
    co2Ppm: 720,
    pollutantsAqi: 45,
    isOn: true,
  );

  @override
  Future<ClimateState> getCurrentState() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _state;
  }

  @override
  Future<ClimateState> setPower(bool isOn) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _state = _state.copyWith(isOn: isOn);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setTargetTemperature(double temperature) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _state = _state.copyWith(targetTemperature: temperature);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setHumidity(double humidity) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _state = _state.copyWith(targetHumidity: humidity);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setMode(ClimateMode mode) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _state = _state.copyWith(mode: mode, isOn: mode != ClimateMode.off);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setSupplyAirflow(double value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _state = _state.copyWith(supplyAirflow: value);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setExhaustAirflow(double value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _state = _state.copyWith(exhaustAirflow: value);
    _climateController.add(_state);
    return _state;
  }

  @override
  Future<ClimateState> setPreset(String preset) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Применяем настройки пресета
    ClimateState newState = _state.copyWith(preset: preset);
    switch (preset) {
      case 'auto':
        newState = newState.copyWith(mode: ClimateMode.auto);
        break;
      case 'night':
        newState = newState.copyWith(
          targetTemperature: 19.0,
          supplyAirflow: 30.0,
          exhaustAirflow: 25.0,
        );
        break;
      case 'turbo':
        newState = newState.copyWith(
          supplyAirflow: 100.0,
          exhaustAirflow: 90.0,
        );
        break;
      case 'eco':
        newState = newState.copyWith(
          targetTemperature: 20.0,
          supplyAirflow: 40.0,
          exhaustAirflow: 35.0,
        );
        break;
      case 'away':
        newState = newState.copyWith(
          targetTemperature: 16.0,
          supplyAirflow: 20.0,
          exhaustAirflow: 15.0,
        );
        break;
    }
    
    _state = newState;
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
