import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// Comprehensive accessibility utilities for WCAG compliance
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Minimum touch target size per WCAG guidelines
  static const double minTouchTarget = 48.0;

  /// Minimum contrast ratios
  static const double minContrastNormalText = 4.5;
  static const double minContrastLargeText = 3.0;
  static const double minContrastNonText = 3.0;

  /// Check if a widget meets minimum touch target requirements
  static bool meetsMinTouchTarget(Size size) {
    return size.width >= minTouchTarget && size.height >= minTouchTarget;
  }

  /// Calculate contrast ratio between two colors
  static double calculateContrastRatio(Color foreground, Color background) {
    final l1 = _calculateRelativeLuminance(foreground);
    final l2 = _calculateRelativeLuminance(background);

    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  static double _calculateRelativeLuminance(Color color) {
    double r = _normalizeColorComponent((color.r * 255.0).round() & 0xff);
    double g = _normalizeColorComponent((color.g * 255.0).round() & 0xff);
    double b = _normalizeColorComponent((color.b * 255.0).round() & 0xff);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Normalize color component for luminance calculation
  static double _normalizeColorComponent(int component) {
    double normalized = component / 255.0;
    if (normalized <= 0.03928) {
      return normalized / 12.92;
    } else {
      return ((normalized + 0.055) / 1.055) * ((normalized + 0.055) / 1.055);
    }
  }

  /// Check if text contrast meets WCAG AA standards
  static bool meetsContrastStandard(
    Color textColor,
    Color backgroundColor, {
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(textColor, backgroundColor);
    return ratio >=
        (isLargeText ? minContrastLargeText : minContrastNormalText);
  }

  /// Get a color with sufficient contrast against background
  static Color ensureContrast(
    Color color,
    Color background, {
    bool isLargeText = false,
  }) {
    if (meetsContrastStandard(color, background, isLargeText: isLargeText)) {
      return color;
    }

    // Try to darken or lighten the color to meet contrast
    final isDarkBackground = _calculateRelativeLuminance(background) < 0.5;
    Color adjustedColor = color;

    for (int i = 1; i <= 10; i++) {
      adjustedColor = isDarkBackground
          ? Color.lerp(color, Colors.white, i * 0.1)!
          : Color.lerp(color, Colors.black, i * 0.1)!;

      if (meetsContrastStandard(adjustedColor, background,
          isLargeText: isLargeText)) {
        return adjustedColor;
      }
    }

    // If still not meeting contrast, return white or black
    return isDarkBackground ? Colors.white : Colors.black;
  }

  /// Announce message to screen reader
  static void announce(String message, {TextDirection? textDirection}) {
    SemanticsService.announce(message, textDirection ?? TextDirection.ltr);
  }

  /// Provide haptic feedback based on action type
  static void hapticFeedback(HapticType type) {
    switch (type) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if reduced motion is preferred
  static bool prefersReducedMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get appropriate animation duration based on accessibility preferences
  static Duration getAnimationDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    if (prefersReducedMotion(context)) {
      return Duration.zero;
    }
    return normalDuration;
  }

  /// Build widget with accessibility wrapper
  static Widget buildAccessibleWidget({
    required Widget child,
    String? label,
    String? hint,
    String? value,
    bool? button,
    bool? enabled,
    bool? checked,
    bool? selected,
    bool? focusable,
    bool? focused,
    bool? readOnly,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onIncrease,
    VoidCallback? onDecrease,
    VoidCallback? onDismiss,
    CustomSemanticsAction? customAction,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      enabled: enabled,
      checked: checked,
      selected: selected,
      focusable: focusable,
      focused: focused,
      readOnly: readOnly,
      onTap: onTap,
      onLongPress: onLongPress,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      onDismiss: onDismiss,
      customSemanticsActions:
          customAction != null ? {customAction: () {}} : null,
      child: child,
    );
  }

  /// Create semantic label for temperature
  static String temperatureLabel(double temperature, {bool isCelsius = true}) {
    final unit = isCelsius ? 'degrees Celsius' : 'degrees Fahrenheit';
    return '${temperature.toStringAsFixed(1)} $unit';
  }

  /// Create semantic label for percentage
  static String percentageLabel(double percentage) {
    return '${percentage.toStringAsFixed(0)} percent';
  }

  /// Create semantic label for time duration
  static String durationLabel(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ${minutes > 0 ? 'and $minutes ${minutes == 1 ? 'minute' : 'minutes'}' : ''}';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      final seconds = duration.inSeconds;
      return '$seconds ${seconds == 1 ? 'second' : 'seconds'}';
    }
  }

  /// Create semantic label for device status
  static String deviceStatusLabel(bool isOn, String deviceName) {
    return '$deviceName is ${isOn ? 'on' : 'off'}';
  }

  /// Create semantic label for alerts
  static String alertLabel(String title, String message, {String? severity}) {
    final severityText = severity != null ? '$severity alert: ' : 'Alert: ';
    return '$severityText$title. $message';
  }
}

/// Types of haptic feedback
enum HapticType {
  light,
  medium,
  heavy,
  selection,
  vibrate,
}

/// Focus management utilities
class FocusUtils {
  FocusUtils._();

  /// Request focus for a specific node
  static void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  /// Unfocus current focus
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Move focus to next focusable element
  static void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to previous focusable element
  static void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Create a focus trap for modal dialogs
  static Widget createFocusTrap({
    required Widget child,
    required FocusNode firstFocusNode,
    FocusNode? lastFocusNode,
  }) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            if (HardwareKeyboard.instance.isShiftPressed) {
              // Shift+Tab: Move focus backward
              if (node.hasPrimaryFocus) {
                (lastFocusNode ?? firstFocusNode).requestFocus();
                return KeyEventResult.handled;
              }
            } else {
              // Tab: Move focus forward
              if ((lastFocusNode ?? firstFocusNode).hasFocus) {
                firstFocusNode.requestFocus();
                return KeyEventResult.handled;
              }
            }
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            // Escape: Close dialog
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}

/// Semantic labels for common UI elements
class SemanticLabels {
  SemanticLabels._();

  // Navigation
  static const String back = 'Go back';
  static const String close = 'Close';
  static const String menu = 'Open menu';
  static const String more = 'More options';
  static const String settings = 'Open settings';
  static const String home = 'Go to home';

  // Actions
  static const String add = 'Add';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String refresh = 'Refresh';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String share = 'Share';

  // Status
  static const String loading = 'Loading';
  static const String error = 'Error occurred';
  static const String success = 'Success';
  static const String warning = 'Warning';
  static const String info = 'Information';

  // HVAC specific
  static const String temperature = 'Temperature';
  static const String humidity = 'Humidity';
  static const String fanSpeed = 'Fan speed';
  static const String mode = 'Operating mode';
  static const String schedule = 'Schedule';
  static const String device = 'Device';
  static const String room = 'Room';
  static const String zone = 'Zone';

  // States
  static const String on = 'On';
  static const String off = 'Off';
  static const String auto = 'Automatic';
  static const String manual = 'Manual';
  static const String heating = 'Heating';
  static const String cooling = 'Cooling';
  static const String ventilation = 'Ventilation';

  /// Get semantic label for icon
  static String? getIconLabel(IconData icon) {
    // Map common icons to semantic labels
    final iconLabels = {
      Icons.arrow_back: back,
      Icons.close: close,
      Icons.menu: menu,
      Icons.more_vert: more,
      Icons.settings: settings,
      Icons.home: home,
      Icons.add: add,
      Icons.delete: delete,
      Icons.edit: edit,
      Icons.save: save,
      Icons.cancel: cancel,
      Icons.refresh: refresh,
      Icons.search: search,
      Icons.filter_list: filter,
      Icons.sort: sort,
      Icons.share: share,
      Icons.thermostat: temperature,
      Icons.water_drop: humidity,
      Icons.air: fanSpeed,
      Icons.schedule: schedule,
      Icons.devices: device,
    };

    return iconLabels[icon];
  }
}
