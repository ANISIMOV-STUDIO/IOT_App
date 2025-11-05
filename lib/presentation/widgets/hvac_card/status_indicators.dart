/// Status indicators widget with web-responsive design
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'animated_icon.dart';

/// Row of status indicators for HVAC unit
class StatusIndicators extends StatelessWidget {
  final int humidity;
  final String fanSpeed;
  final String mode;
  final bool isCompact;

  const StatusIndicators({
    super.key,
    required this.humidity,
    required this.fanSpeed,
    required this.mode,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final indicators = [
          _StatusChip(
            icon: Icons.water_drop,
            value: '$humidity%',
            label: 'Humidity',
            color: HvacColors.primaryBlue,
            isCompact: isCompact,
          ),
          _StatusChip(
            icon: Icons.air,
            value: fanSpeed,
            label: 'Fan',
            color: HvacColors.success,
            isCompact: isCompact,
          ),
          _StatusChip(
            icon: Icons.thermostat,
            value: mode,
            label: 'Mode',
            color: HvacColors.primaryOrange,
            isCompact: isCompact,
          ),
        ];

        if (constraints.maxWidth < 300 || isCompact) {
          // Vertical layout for small screens
          return Column(
            children: indicators
                .map((indicator) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: indicator,
                    ))
                .toList(),
          );
        } else {
          // Horizontal layout for larger screens
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: indicators
                .map((indicator) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: indicator,
                      ),
                    ))
                .toList(),
          );
        }
      },
    );
  }
}

/// Individual status chip with hover effect
class _StatusChip extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isCompact;

  const _StatusChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.isCompact = false,
  });

  @override
  State<_StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<_StatusChip>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
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
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCompact ? 4.0 : 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.2)
                    : HvacColors.textPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: _isHovered
                      ? widget.color.withValues(alpha: 0.5)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedPulseIcon(
                    icon: widget.icon,
                    color: widget.color,
                    isHovered: _isHovered,
                    size: widget.isCompact ? 14.0 : 16.0,
                  ),
                  const SizedBox(width: 4.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.value,
                          style: TextStyle(
                            fontSize: widget.isCompact ? 11.0 : 12.0,
                            fontWeight: FontWeight.bold,
                            color: _isHovered ? widget.color : HvacColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontSize: widget.isCompact ? 9.0 : 10.0,
                            color: _isHovered
                                ? widget.color.withValues(alpha: 0.8)
                                : HvacColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

