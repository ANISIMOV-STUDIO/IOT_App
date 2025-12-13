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
