/// Trait for devices that can be turned on/off
mixin PowerTrait {
  bool get isPowerOn;
  
  /// Returns a copy with new power state
  dynamic copyWithPower(bool isPowerOn);
}
