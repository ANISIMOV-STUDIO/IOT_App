/// Device Utilities
///
/// Utility functions for device management
library;

class DeviceUtils {
  /// Formats a MAC address with colons
  static String formatMacAddress(String mac) {
    // Add colons every 2 characters if not present
    if (!mac.contains(':') && !mac.contains('-')) {
      final buffer = StringBuffer();
      for (int i = 0; i < mac.length; i += 2) {
        if (i > 0) buffer.write(':');
        buffer.write(mac.substring(i, i + 2 > mac.length ? mac.length : i + 2));
      }
      return buffer.toString().toUpperCase();
    }
    return mac.toUpperCase();
  }
}
