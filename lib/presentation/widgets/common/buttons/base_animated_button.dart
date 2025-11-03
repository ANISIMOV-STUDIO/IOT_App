/// Base class for animated buttons with common functionality
/// Provides haptic feedback, cursor management, and animation controllers
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Base mixin for animated button states
mixin AnimatedButtonMixin<T extends StatefulWidget> on TickerProviderStateMixin<T> {
  /// Animation controller for button interactions
  late AnimationController _animationController;

  /// Scale animation for press effects
  late Animation<double> scaleAnimation;

  /// Whether haptic feedback is enabled
  bool get enableHaptic => true;

  /// Animation duration in milliseconds
  int get animationDuration => 100;

  /// Scale factor when pressed
  double get pressedScale => 0.95;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize animation controllers and animations
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      vsync: this,
    );

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: pressedScale,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handle tap down event with haptic feedback
  void handleTapDown(TapDownDetails details) {
    if (!isButtonEnabled) return;

    _animationController.forward();

    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  /// Handle tap up event
  void handleTapUp(TapUpDetails details) {
    if (!isButtonEnabled) return;
    _animationController.reverse();
  }

  /// Handle tap cancel event
  void handleTapCancel() {
    if (!isButtonEnabled) return;
    _animationController.reverse();
  }

  /// Override to determine if button is enabled
  bool get isButtonEnabled => true;

  /// Get appropriate mouse cursor based on button state
  SystemMouseCursor get mouseCursor {
    return isButtonEnabled
      ? SystemMouseCursors.click
      : SystemMouseCursors.forbidden;
  }
}

/// Common button properties
class ButtonProperties {
  final bool isLoading;
  final bool isDisabled;
  final bool enableHaptic;

  const ButtonProperties({
    this.isLoading = false,
    this.isDisabled = false,
    this.enableHaptic = true,
  });

  bool get isEnabled => !isLoading && !isDisabled;
}

/// Button size configurations
class ButtonSize {
  final double height;
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;

  const ButtonSize._({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
  });

  static const small = ButtonSize._(
    height: 36,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    fontSize: 12,
    iconSize: 16,
  );

  static const medium = ButtonSize._(
    height: 48,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    fontSize: 14,
    iconSize: 20,
  );

  static const large = ButtonSize._(
    height: 56,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    fontSize: 16,
    iconSize: 24,
  );
}