import 'package:smart_home_core/domain/entities/device.dart';
import 'package:smart_home_core/domain/entities/traits/power_trait.dart';
import 'package:smart_home_core/domain/entities/traits/temperature_trait.dart';

/// Concrete implementation of a Ventilation Device
class VentilationDevice extends Device with PowerTrait, TemperatureTrait {
  @override
  final bool isPowerOn;
  
  @override
  final double currentTemperature;
  
  @override
  final double? targetTemperature;
  
  final int fanSpeed; // 0-100
  
  const VentilationDevice({
    required super.id,
    required super.name,
    this.isPowerOn = false,
    this.currentTemperature = 0.0,
    this.targetTemperature,
    this.fanSpeed = 0,
  }) : super(type: 'ventilation');

  @override
  VentilationDevice copyWith({
    String? id,
    String? name,
    bool? isPowerOn,
    double? currentTemperature,
    double? targetTemperature,
    int? fanSpeed,
  }) {
    return VentilationDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      isPowerOn: isPowerOn ?? this.isPowerOn,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      fanSpeed: fanSpeed ?? this.fanSpeed,
    );
  }

  @override
  VentilationDevice copyWithPower(bool isPowerOn) {
    return copyWith(isPowerOn: isPowerOn);
  }

  @override
  VentilationDevice copyWithTemperature(double targetTemperature) {
    return copyWith(targetTemperature: targetTemperature);
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isPowerOn,
    currentTemperature,
    targetTemperature,
    fanSpeed,
  ];
}
