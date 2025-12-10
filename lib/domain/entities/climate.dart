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
  final String roomId;
  final double currentTemperature;
  final double targetTemperature;
  final double humidity;
  final ClimateMode mode;
  final AirQualityLevel airQuality;
  final int co2Ppm;
  final int pollutantsAqi;
  final bool isOn;

  const ClimateState({
    required this.roomId,
    required this.currentTemperature,
    required this.targetTemperature,
    required this.humidity,
    required this.mode,
    required this.airQuality,
    this.co2Ppm = 400,
    this.pollutantsAqi = 50,
    this.isOn = true,
  });

  ClimateState copyWith({
    String? roomId,
    double? currentTemperature,
    double? targetTemperature,
    double? humidity,
    ClimateMode? mode,
    AirQualityLevel? airQuality,
    int? co2Ppm,
    int? pollutantsAqi,
    bool? isOn,
  }) {
    return ClimateState(
      roomId: roomId ?? this.roomId,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      humidity: humidity ?? this.humidity,
      mode: mode ?? this.mode,
      airQuality: airQuality ?? this.airQuality,
      co2Ppm: co2Ppm ?? this.co2Ppm,
      pollutantsAqi: pollutantsAqi ?? this.pollutantsAqi,
      isOn: isOn ?? this.isOn,
    );
  }

  @override
  List<Object?> get props => [
    roomId, currentTemperature, targetTemperature, humidity,
    mode, airQuality, co2Ppm, pollutantsAqi, isOn,
  ];
}
