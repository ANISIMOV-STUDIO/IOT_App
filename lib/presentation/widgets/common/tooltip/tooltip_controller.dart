/// Tooltip Controller
///
/// Manages tooltip state and animations
library;

import 'dart:async';
import 'package:flutter/material.dart';

/// Controller for managing tooltip display state
class TooltipController {
  final Duration showDuration;
  final Duration waitDuration;
  Timer? _showTimer;
  Timer? _hideTimer;
  final VoidCallback onShow;
  final VoidCallback onHide;

  TooltipController({
    required this.showDuration,
    required this.waitDuration,
    required this.onShow,
    required this.onHide,
  });

  /// Start showing tooltip after wait duration
  void startShowTimer() {
    cancelAllTimers();
    _showTimer = Timer(waitDuration, () {
      onShow();
      startHideTimer();
    });
  }

  /// Start hiding tooltip after show duration
  void startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(showDuration, () {
      onHide();
    });
  }

  /// Cancel all active timers
  void cancelAllTimers() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
  }

  /// Dispose of resources
  void dispose() {
    cancelAllTimers();
  }
}