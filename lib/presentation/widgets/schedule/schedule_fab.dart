/// Web-friendly floating action button for schedule creation
///
/// Provides an accessible FAB with hover states for web platform
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class ScheduleFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final String semanticLabel;
  final String tooltip;

  const ScheduleFAB({
    super.key,
    required this.onPressed,
    this.semanticLabel = 'Create new schedule',
    this.tooltip = 'Add Schedule',
  });

  @override
  State<ScheduleFAB> createState() => _ScheduleFABState();
}

class _ScheduleFABState extends State<ScheduleFAB>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: Tooltip(
          message: widget.tooltip,
          preferBelow: false,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              backgroundColor: _isHovered
                  ? HvacColors.primaryOrange.withValues(alpha: 0.9)
                  : HvacColors.primaryOrange,
              foregroundColor: HvacColors.textPrimary,
              elevation: _isHovered ? 8 : 4,
              child: const Icon(
                Icons.add,
                size: 24.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
