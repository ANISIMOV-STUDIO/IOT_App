/// Device Validator
///
/// Validation for device-specific inputs: device ID, temperature, numeric values
library;

class DeviceValidator {
  // Prevent instantiation
  DeviceValidator._();

  /// Validate device ID
  static String? validateDeviceId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Device ID is required';
    }

    // Device ID format: alphanumeric with hyphens, 8-36 characters
    final deviceIdPattern = RegExp(r'^[a-zA-Z0-9\-]{8,36}$');

    if (!deviceIdPattern.hasMatch(value)) {
      return 'Invalid device ID format';
    }

    return null;
  }

  /// Validate temperature input
  static String? validateTemperature(
    String? value, {
    double min = -50,
    double max = 100,
    String unit = '°C',
  }) {
    if (value == null || value.isEmpty) {
      return 'Temperature is required';
    }

    final temp = double.tryParse(value);
    if (temp == null) {
      return 'Please enter a valid number';
    }

    if (temp < min || temp > max) {
      return 'Temperature must be between $min$unit and $max$unit';
    }

    return null;
  }

  /// Validate numeric input
  static String? validateNumber(
    String? value, {
    String fieldName = 'Value',
    double? min,
    double? max,
    bool allowDecimal = true,
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (!allowDecimal && number % 1 != 0) {
      return '$fieldName must be a whole number';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must be at most $max';
    }

    return null;
  }
}
