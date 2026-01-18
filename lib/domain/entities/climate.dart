import 'package:equatable/equatable.dart';

/// Режим климата
enum ClimateMode {
  heating,
  cooling,
  auto,
  dry,
  ventilation,
  off,
}

/// Качество воздуха
enum AirQualityLevel {
  excellent,
  good,
  moderate,
  poor,
  hazardous,
}

/// Состояние климата в комнате
class ClimateState extends Equatable {

  const ClimateState({
    required this.roomId,
    required this.currentTemperature,
    required this.targetTemperature,
    required this.humidity,
    required this.mode,
    required this.airQuality,
    this.deviceName = 'HVAC Unit',
    this.targetHumidity = 50,
    this.supplyAirflow = 50,
    this.exhaustAirflow = 40,
    this.preset = 'auto',
    this.co2Ppm = 400,
    this.pollutantsAqi = 50,
    this.isOn = true,
  });
  final String roomId;
  final String deviceName;
  final double currentTemperature;
  final double targetTemperature;
  final double humidity;
  final double targetHumidity;
  final double supplyAirflow;
  final double exhaustAirflow;
  final ClimateMode mode;
  final String preset;
  final AirQualityLevel airQuality;
  final int co2Ppm;
  final int pollutantsAqi;
  final bool isOn;

  ClimateState copyWith({
    String? roomId,
    String? deviceName,
    double? currentTemperature,
    double? targetTemperature,
    double? humidity,
    double? targetHumidity,
    double? supplyAirflow,
    double? exhaustAirflow,
    ClimateMode? mode,
    String? preset,
    AirQualityLevel? airQuality,
    int? co2Ppm,
    int? pollutantsAqi,
    bool? isOn,
  }) =>
      ClimateState(
        roomId: roomId ?? this.roomId,
        deviceName: deviceName ?? this.deviceName,
        currentTemperature: currentTemperature ?? this.currentTemperature,
        targetTemperature: targetTemperature ?? this.targetTemperature,
        humidity: humidity ?? this.humidity,
        targetHumidity: targetHumidity ?? this.targetHumidity,
        supplyAirflow: supplyAirflow ?? this.supplyAirflow,
        exhaustAirflow: exhaustAirflow ?? this.exhaustAirflow,
        mode: mode ?? this.mode,
        preset: preset ?? this.preset,
        airQuality: airQuality ?? this.airQuality,
        co2Ppm: co2Ppm ?? this.co2Ppm,
        pollutantsAqi: pollutantsAqi ?? this.pollutantsAqi,
        isOn: isOn ?? this.isOn,
      );

  @override
  List<Object?> get props => [
    roomId, deviceName, currentTemperature, targetTemperature,
    humidity, targetHumidity, supplyAirflow, exhaustAirflow,
    mode, preset, airQuality, co2Ppm, pollutantsAqi, isOn,
  ];
}
