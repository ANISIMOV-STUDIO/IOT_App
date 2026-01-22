/// Operation Graph Controller - Animation and gesture state management
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_animations.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Zoom/pan configuration constants
abstract class _ZoomConstants {
  static const double minScale = 0.5;
  static const double maxScale = 4;
  static const double defaultScale = 1;
}

// =============================================================================
// CONTROLLER
// =============================================================================

/// Controller for OperationGraph animations and gestures
///
/// Manages:
/// - Draw curve animation on data load
/// - Zoom/pan transform state
class OperationGraphController extends ChangeNotifier {
  OperationGraphController({required TickerProvider vsync}) : _vsync = vsync {
    _initAnimations();
  }

  final TickerProvider _vsync;

  // Animation controllers
  late final AnimationController _drawController;
  late final Animation<double> _drawAnimation;

  // Zoom/pan state
  final TransformationController transformController = TransformationController();
  double _currentScale = _ZoomConstants.defaultScale;

  /// Current draw progress (0.0 - 1.0)
  double get drawProgress => _drawAnimation.value;

  /// Whether the draw animation is running
  bool get isAnimating => _drawController.isAnimating;

  /// Current zoom scale
  double get currentScale => _currentScale;

  /// Whether zoomed in
  bool get isZoomed => _currentScale > 1.01;

  /// Minimum zoom scale
  double get minScale => _ZoomConstants.minScale;

  /// Maximum zoom scale
  double get maxScale => _ZoomConstants.maxScale;

  void _initAnimations() {
    _drawController = AnimationController(
      vsync: _vsync,
      duration: AppDurations.slower,
    );

    _drawAnimation = CurvedAnimation(
      parent: _drawController,
      curve: AppCurves.emphasize,
    );

    _drawController.addListener(notifyListeners);
  }

  /// Start the curve draw animation from beginning
  void animateDrawCurve() {
    _drawController
      ..reset()
      ..forward();
  }

  /// Reset animation to initial state (fully drawn)
  void resetAnimation() {
    _drawController.value = 1.0;
    notifyListeners();
  }

  /// Skip animation and show full curve immediately
  void skipAnimation() {
    _drawController
      ..stop()
      ..value = 1.0;
    notifyListeners();
  }

  /// Update zoom/pan state from InteractiveViewer
  void updateTransform(Matrix4 matrix) {
    _currentScale = matrix.getMaxScaleOnAxis();
    notifyListeners();
  }

  /// Reset zoom to default (1.0 scale)
  void resetZoom() {
    transformController.value = Matrix4.identity();
    _currentScale = _ZoomConstants.defaultScale;
    notifyListeners();
  }

  @override
  void dispose() {
    _drawController.dispose();
    transformController.dispose();
    super.dispose();
  }
}
