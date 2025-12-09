/// Trait for devices that can report and control temperature
mixin TemperatureTrait {
  double get currentTemperature;
  double? get targetTemperature;
  
  /// Returns a copy with new target temperature
  dynamic copyWithTemperature(double targetTemperature);
}
