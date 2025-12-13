import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import '../../theme/tokens/neumorphic_spacing.dart';

/// Card variant styles
enum NeumorphicCardVariant {
  convex,  // Default raised look
  flat,    // No shadow, subtle background
  concave, // Pressed/inset look
}

/// Backwards-compatible NeumorphicCard using flutter_neumorphic_plus
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isPressed;
  final VoidCallback? onTap;
  final NeumorphicCardVariant variant;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = NeumorphicSpacing.cardRadius,
    this.isPressed = false,
    this.onTap,
    this.variant = NeumorphicCardVariant.convex,
  });

  @override
  Widget build(BuildContext context) {
    final depth = switch (variant) {
      NeumorphicCardVariant.convex => isPressed ? -2.0 : 4.0,
      NeumorphicCardVariant.flat => 0.0,
      NeumorphicCardVariant.concave => -3.0,
    };

    Widget card = np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: depth,
        intensity: variant == NeumorphicCardVariant.flat ? 0.3 : 0.5,
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(borderRadius),
        ),
      ),
      padding: padding ?? NeumorphicSpacing.cardInsets,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: card),
      );
    }
    return card;
  }
}

/// Interactive card with tap animation
class NeumorphicInteractiveCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final double borderRadius;

  const NeumorphicInteractiveCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius = NeumorphicSpacing.cardRadius,
  });

  @override
  State<NeumorphicInteractiveCard> createState() => _NeumorphicInteractiveCardState();
}

class _NeumorphicInteractiveCardState extends State<NeumorphicInteractiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: np.Neumorphic(
          duration: Duration.zero, // No animation jank
          style: np.NeumorphicStyle(
            depth: _isPressed ? -2 : 4,
            intensity: 0.5,
            boxShape: np.NeumorphicBoxShape.roundRect(
              BorderRadius.circular(widget.borderRadius),
            ),
          ),
          padding: widget.padding ?? NeumorphicSpacing.cardInsets,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Backwards-compatible NeumorphicToggle using flutter_neumorphic_plus
class NeumorphicToggle extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: np.NeumorphicSwitch(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        style: np.NeumorphicSwitchStyle(
          activeTrackColor: activeColor,
        ),
      ),
    );
  }
}

/// Backwards-compatible NeumorphicButton using flutter_neumorphic_plus
class NeumorphicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final NeumorphicButtonSize size;
  final double? width;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final Color? backgroundColor;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.size = NeumorphicButtonSize.medium,
    this.width,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizeConfig = _getSizeConfig();
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: sizeConfig.iconSize),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: sizeConfig.iconSize,
            height: sizeConfig.iconSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        else
          child,
      ],
    );

    return MouseRegion(
      cursor: (isDisabled || isLoading) ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: np.NeumorphicButton(
          onPressed: (isDisabled || isLoading) ? null : onPressed,
          duration: Duration.zero, // No animation jank
          style: np.NeumorphicStyle(
            depth: 4,
            intensity: 0.5,
            boxShape: np.NeumorphicBoxShape.roundRect(
              BorderRadius.circular(sizeConfig.borderRadius),
            ),
            color: backgroundColor,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.horizontalPadding,
            vertical: sizeConfig.verticalPadding,
          ),
          minDistance: -2,
          child: SizedBox(
            width: width,
            height: sizeConfig.height - sizeConfig.verticalPadding * 2,
            child: Center(child: content),
          ),
        ),
      ),
    );
  }

  _ButtonSizeConfig _getSizeConfig() => switch (size) {
    NeumorphicButtonSize.small => const _ButtonSizeConfig(
      height: 36, horizontalPadding: 16, verticalPadding: 8,
      iconSize: 18, borderRadius: 10,
    ),
    NeumorphicButtonSize.medium => const _ButtonSizeConfig(
      height: 44, horizontalPadding: 20, verticalPadding: 12,
      iconSize: 20, borderRadius: 12,
    ),
    NeumorphicButtonSize.large => const _ButtonSizeConfig(
      height: 52, horizontalPadding: 24, verticalPadding: 14,
      iconSize: 24, borderRadius: 14,
    ),
  };
}

class _ButtonSizeConfig {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double borderRadius;

  const _ButtonSizeConfig({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.borderRadius,
  });
}

enum NeumorphicButtonSize { small, medium, large }

/// Neumorphic Loading Indicator - pulsing circles
class NeumorphicLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const NeumorphicLoadingIndicator({
    super.key,
    this.size = 60,
    this.color,
  });

  @override
  State<NeumorphicLoadingIndicator> createState() => _NeumorphicLoadingIndicatorState();
}

class _NeumorphicLoadingIndicatorState extends State<NeumorphicLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return np.Neumorphic(
          style: np.NeumorphicStyle(
            depth: _animation.value,
            intensity: 0.6,
            boxShape: const np.NeumorphicBoxShape.circle(),
            color: widget.color,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Padding(
              padding: EdgeInsets.all(widget.size * 0.25),
              child: np.Neumorphic(
                style: np.NeumorphicStyle(
                  depth: -_animation.value,
                  intensity: 0.5,
                  boxShape: const np.NeumorphicBoxShape.circle(),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Neumorphic Badge/Chip - small label with soft shadows
class NeumorphicBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final bool isConvex;

  const NeumorphicBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.isConvex = true,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? const Color(0xFF6366F1);

    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: isConvex ? 2 : -1,
        intensity: 0.5,
        color: badgeColor.withValues(alpha: 0.15),
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Neumorphic Progress Bar
class NeumorphicProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color? activeColor;
  final double borderRadius;

  const NeumorphicProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.activeColor,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: -2,
        intensity: 0.4,
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(borderRadius),
        ),
      ),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: activeColor ?? const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Neumorphic Icon Button - small interactive button with icon
class NeumorphicIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  State<NeumorphicIconButton> createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: np.Neumorphic(
          style: np.NeumorphicStyle(
            depth: _isPressed ? -2 : 3,
            intensity: 0.5,
            boxShape: np.NeumorphicBoxShape.roundRect(
              BorderRadius.circular(10),
            ),
          ),
          padding: EdgeInsets.all((widget.size - 20) / 2),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.iconColor,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    return button;
  }
}
