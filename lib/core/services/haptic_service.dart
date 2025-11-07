/// Haptic Feedback Service
/// Centralized haptic feedback management for Big Tech level tactile UX
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

enum HapticType {
  selection,
  lightImpact,
  mediumImpact,
  heavyImpact,
  success,
  warning,
  error,
  click,
  longPress,
  drag,
}

class HapticService {
  static HapticService? _instance;
  static HapticService get instance => _instance ??= HapticService._();

  HapticService._();

  // Settings
  bool _isEnabled = true;
  double _intensity = 1.0; // 0.0 to 1.0

  bool get isEnabled => _isEnabled;
  double get intensity => _intensity;

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  void setIntensity(double intensity) {
    _intensity = intensity.clamp(0.0, 1.0);
  }

  /// Main haptic feedback method
  Future<void> feedback(HapticType type) async {
    if (!_isEnabled) return;
    if (kIsWeb) return; // No haptics on web

    try {
      switch (type) {
        case HapticType.selection:
          await HapticFeedback.selectionClick();
          break;
        case HapticType.lightImpact:
          await HapticFeedback.lightImpact();
          break;
        case HapticType.mediumImpact:
          await HapticFeedback.mediumImpact();
          break;
        case HapticType.heavyImpact:
          await HapticFeedback.heavyImpact();
          break;
        case HapticType.success:
          // Custom success pattern
          await _successPattern();
          break;
        case HapticType.warning:
          // Custom warning pattern
          await _warningPattern();
          break;
        case HapticType.error:
          // Custom error pattern
          await _errorPattern();
          break;
        case HapticType.click:
          await HapticFeedback.lightImpact();
          break;
        case HapticType.longPress:
          await HapticFeedback.mediumImpact();
          break;
        case HapticType.drag:
          await HapticFeedback.selectionClick();
          break;
      }
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }

  /// Custom success pattern (two light taps)
  Future<void> _successPattern() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Custom warning pattern (medium-light-medium)
  Future<void> _warningPattern() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
  }

  /// Custom error pattern (heavy impact with vibration)
  Future<void> _errorPattern() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.vibrate();
  }

  // Convenience methods
  Future<void> selection() => feedback(HapticType.selection);
  Future<void> light() => feedback(HapticType.lightImpact);
  Future<void> medium() => feedback(HapticType.mediumImpact);
  Future<void> heavy() => feedback(HapticType.heavyImpact);
  Future<void> success() => feedback(HapticType.success);
  Future<void> warning() => feedback(HapticType.warning);
  Future<void> error() => feedback(HapticType.error);
  Future<void> click() => feedback(HapticType.click);
  Future<void> longPress() => feedback(HapticType.longPress);
  Future<void> drag() => feedback(HapticType.drag);

  /// Play haptic feedback for slider changes
  Future<void> sliderChange(double oldValue, double newValue) async {
    if (!_isEnabled) return;

    final delta = (newValue - oldValue).abs();

    // Different feedback based on change magnitude
    if (delta > 0.1) {
      await medium();
    } else if (delta > 0.05) {
      await light();
    } else {
      await selection();
    }
  }

  /// Play haptic feedback for toggle changes
  Future<void> toggle(bool value) async {
    if (!_isEnabled) return;

    if (value) {
      await success();
    } else {
      await light();
    }
  }

  /// Play haptic feedback for tab selection
  Future<void> tabSelection() async {
    if (!_isEnabled) return;
    await selection();
  }

  /// Play haptic feedback for page transitions
  Future<void> pageTransition() async {
    if (!_isEnabled) return;
    await light();
  }

  /// Play haptic feedback for pull to refresh
  Future<void> pullToRefresh() async {
    if (!_isEnabled) return;
    await medium();
  }

  /// Play haptic feedback for list item selection
  Future<void> listItemSelection() async {
    if (!_isEnabled) return;
    await selection();
  }

  /// Play haptic feedback for dismissible actions
  Future<void> dismissible() async {
    if (!_isEnabled) return;
    await medium();
  }

  /// Play haptic feedback for notification
  Future<void> notification() async {
    if (!_isEnabled) return;
    await _successPattern();
  }
}

/// Mixin for widgets that need haptic feedback
mixin HapticFeedbackMixin {
  HapticService get haptic => HapticService.instance;

  void playHaptic(HapticType type) {
    haptic.feedback(type);
  }

  void playSelection() => haptic.selection();
  void playLight() => haptic.light();
  void playMedium() => haptic.medium();
  void playHeavy() => haptic.heavy();
  void playSuccess() => haptic.success();
  void playWarning() => haptic.warning();
  void playError() => haptic.error();
  void playClick() => haptic.click();
}

/// Widget wrapper that adds haptic feedback to any tap
class HapticTap extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final HapticType hapticType;
  final bool enableHaptic;

  const HapticTap({
    super.key,
    required this.child,
    this.onTap,
    this.hapticType = HapticType.lightImpact,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enableHaptic) {
          HapticService.instance.feedback(hapticType);
        }
        onTap?.call();
      },
      child: child,
    );
  }
}

/// Haptic feedback for InkWell
class HapticInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final HapticType tapHaptic;
  final HapticType longPressHaptic;
  final BorderRadius? borderRadius;
  final bool enableHaptic;

  const HapticInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.tapHaptic = HapticType.lightImpact,
    this.longPressHaptic = HapticType.mediumImpact,
    this.borderRadius,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              if (enableHaptic) {
                HapticService.instance.feedback(tapHaptic);
              }
              onTap!();
            }
          : null,
      onLongPress: onLongPress != null
          ? () {
              if (enableHaptic) {
                HapticService.instance.feedback(longPressHaptic);
              }
              onLongPress!();
            }
          : null,
      borderRadius: borderRadius,
      child: child,
    );
  }
}
