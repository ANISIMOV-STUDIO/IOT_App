/// Mode Preset Entity
///
/// Configuration for a predefined ventilation mode
library;

import 'package:equatable/equatable.dart';
import 'ventilation_mode.dart';

class ModePreset extends Equatable {
  final VentilationMode mode;
  final int supplyFanSpeed; // Скорость приточного вентилятора (0-100%)
  final int exhaustFanSpeed; // Скорость вытяжного вентилятора (0-100%)
  final double heatingTemp; // Температура нагрева (°C)
  final double coolingTemp; // Температура охлаждения (°C)

  const ModePreset({
    required this.mode,
    required this.supplyFanSpeed,
    required this.exhaustFanSpeed,
    required this.heatingTemp,
    required this.coolingTemp,
  });

  /// Create a copy with updated fields
  ModePreset copyWith({
    VentilationMode? mode,
    int? supplyFanSpeed,
    int? exhaustFanSpeed,
    double? heatingTemp,
    double? coolingTemp,
  }) {
    return ModePreset(
      mode: mode ?? this.mode,
      supplyFanSpeed: supplyFanSpeed ?? this.supplyFanSpeed,
      exhaustFanSpeed: exhaustFanSpeed ?? this.exhaustFanSpeed,
      heatingTemp: heatingTemp ?? this.heatingTemp,
      coolingTemp: coolingTemp ?? this.coolingTemp,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        supplyFanSpeed,
        exhaustFanSpeed,
        heatingTemp,
        coolingTemp,
      ];

  @override
  String toString() {
    return 'ModePreset(mode: ${mode.displayName}, supply: $supplyFanSpeed%, exhaust: $exhaustFanSpeed%, heating: $heatingTemp°C, cooling: $coolingTemp°C)';
  }

  /// Default presets based on COMPACTair screenshot
  static const Map<VentilationMode, ModePreset> defaults = {
    VentilationMode.basic: ModePreset(
      mode: VentilationMode.basic,
      supplyFanSpeed: 70,
      exhaustFanSpeed: 50,
      heatingTemp: 23.0,
      coolingTemp: 23.0,
    ),
    VentilationMode.intensive: ModePreset(
      mode: VentilationMode.intensive,
      supplyFanSpeed: 70,
      exhaustFanSpeed: 70,
      heatingTemp: 21.0,
      coolingTemp: 25.0,
    ),
    VentilationMode.economic: ModePreset(
      mode: VentilationMode.economic,
      supplyFanSpeed: 20,
      exhaustFanSpeed: 20,
      heatingTemp: 18.0,
      coolingTemp: 28.0,
    ),
    VentilationMode.maximum: ModePreset(
      mode: VentilationMode.maximum,
      supplyFanSpeed: 100,
      exhaustFanSpeed: 100,
      heatingTemp: 21.0,
      coolingTemp: 21.0,
    ),
    VentilationMode.kitchen: ModePreset(
      mode: VentilationMode.kitchen,
      supplyFanSpeed: 50,
      exhaustFanSpeed: 80,
      heatingTemp: 20.0,
      coolingTemp: 24.0,
    ),
    VentilationMode.fireplace: ModePreset(
      mode: VentilationMode.fireplace,
      supplyFanSpeed: 80,
      exhaustFanSpeed: 40,
      heatingTemp: 22.0,
      coolingTemp: 22.0,
    ),
    VentilationMode.vacation: ModePreset(
      mode: VentilationMode.vacation,
      supplyFanSpeed: 15,
      exhaustFanSpeed: 15,
      heatingTemp: 16.0,
      coolingTemp: 30.0,
    ),
    VentilationMode.custom: ModePreset(
      mode: VentilationMode.custom,
      supplyFanSpeed: 50,
      exhaustFanSpeed: 50,
      heatingTemp: 21.0,
      coolingTemp: 23.0,
    ),
  };
}
