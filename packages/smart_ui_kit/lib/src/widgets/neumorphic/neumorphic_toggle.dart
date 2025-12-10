import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Toggle Switch - iOS-style toggle with soft shadows
class NeumorphicToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final bool isDisabled;

  const NeumorphicToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.isDisabled = false,
  });

  @override
  State<NeumorphicToggle> createState() => _NeumorphicToggleState();
}

class _NeumorphicToggleState extends State<NeumorphicToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(NeumorphicToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isDisabled) {
      widget.onChanged?.call(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final activeColor = widget.activeColor ?? NeumorphicColors.accentPrimary;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final trackColor = Color.lerp(
            theme.colors.surface,
            activeColor,
            _animation.value,
          )!;

          return Opacity(
            opacity: widget.isDisabled ? 0.5 : 1.0,
            child: Container(
              width: NeumorphicSpacing.toggleWidth,
              height: NeumorphicSpacing.toggleHeight,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(NeumorphicSpacing.toggleHeight / 2),
                boxShadow: theme.shadows.concaveSmall,
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: widget.value 
                        ? NeumorphicSpacing.toggleWidth - NeumorphicSpacing.toggleHeight + 2
                        : 2,
                    top: 2,
                    child: Container(
                      width: NeumorphicSpacing.toggleHeight - 4,
                      height: NeumorphicSpacing.toggleHeight - 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
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

/// Neumorphic Toggle with label
class NeumorphicToggleWithLabel extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final bool isDisabled;

  const NeumorphicToggleWithLabel({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.typography.bodyLarge,
        ),
        NeumorphicToggle(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          isDisabled: isDisabled,
        ),
      ],
    );
  }
}
