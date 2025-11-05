/// Floating action button with elastic animation
/// Web-optimized with hover states and cursor management
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnimatedFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final bool mini;
  final bool extended;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AnimatedFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.mini = false,
    this.extended = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverScaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Entry animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    _scaleController.forward();

    // Hover animation
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _handleTap() {
    HapticFeedback.mediumImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.mini ? 48.0 : 56.0;
    final hasLabel = widget.label != null && (widget.extended || _isHovered);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _hoverScaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _hoverScaleAnimation.value,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => _handleHover(true),
            onExit: (_) => _handleHover(false),
            child: _buildFABContainer(size, hasLabel),
          ),
        ),
      ),
    );
  }

  Widget _buildFABContainer(double size, bool hasLabel) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: hasLabel ? null : size,
      height: size,
      padding: hasLabel
          ? const EdgeInsets.symmetric(horizontal: HvacSpacing.lgR)
          : null,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor != null
            ? null
            : HvacColors.primaryGradient,
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          hasLabel ? HvacRadius.xlR : size / 2,
        ),
        boxShadow: _buildShadows(),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(
          hasLabel ? HvacRadius.xlR : size / 2,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            hasLabel ? HvacRadius.xlR : size / 2,
          ),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          onTap: _handleTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hasLabel ? HvacSpacing.smR : 0,
            ),
            child: _buildContent(hasLabel),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _buildShadows() {
    final shadowColor = widget.backgroundColor ?? HvacColors.primaryOrange;
    final shadowOpacity = _isHovered ? 0.4 : 0.3;

    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowOpacity),
        blurRadius: _isHovered ? 16 : 12,
        offset: Offset(0, _isHovered ? 8 : 6),
      ),
      BoxShadow(
        color: shadowColor.withValues(alpha: shadowOpacity * 0.5),
        blurRadius: _isHovered ? 28 : 24,
        offset: Offset(0, _isHovered ? 14 : 12),
      ),
    ];
  }

  Widget _buildContent(bool hasLabel) {
    final iconSize = widget.mini ? 20.0 : 24.0;
    final foregroundColor = widget.foregroundColor ?? Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.icon,
          color: foregroundColor,
          size: iconSize,
        ),
        if (hasLabel) ...[
          const SizedBox(width: HvacSpacing.smR),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: hasLabel ? 1.0 : 0.0,
              child: Text(
                widget.label!,
                style: HvacTypography.buttonMedium.copyWith(
                  color: foregroundColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}