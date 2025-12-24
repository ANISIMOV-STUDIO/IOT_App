/// BREEZ Card & Button Components (Material Design)
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// BREEZ styled card using Material Card
class BreezCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool disabled;
  final String? title;
  final String? description;

  const BreezCard({
    super.key,
    required this.child,
    this.padding,
    this.disabled = false,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: disabled ? 0.3 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(AppColors.cardRadius),
          border: Border.all(color: AppColors.darkBorder),
        ),
        padding: padding ?? const EdgeInsets.all(24),
        child: IgnorePointer(
          ignoring: disabled,
          child: title != null || description != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          title!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (description != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ),
                    child,
                  ],
                )
              : child,
        ),
      ),
    );
  }
}

/// Base BREEZ button with consistent styling
class BreezButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? hoverColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double borderRadius;
  final List<BoxShadow>? shadows;
  final Border? border;

  const BreezButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.hoverColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppColors.buttonRadius,
    this.shadows,
    this.border,
  });

  @override
  State<BreezButton> createState() => _BreezButtonState();
}

class _BreezButtonState extends State<BreezButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? Colors.white.withValues(alpha: 0.05);
    final hover = widget.hoverColor ?? Colors.white.withValues(alpha: 0.1);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? hover : bg,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.border ?? Border.all(color: AppColors.darkBorder),
            boxShadow: widget.shadows,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Icon button with consistent styling
class BreezIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool isActive;
  final double size;

  const BreezIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.isActive = false,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      backgroundColor: isActive
          ? AppColors.accent
          : Colors.white.withValues(alpha: 0.05),
      hoverColor: isActive
          ? AppColors.accentLight
          : Colors.white.withValues(alpha: 0.1),
      child: Icon(
        icon,
        size: size,
        color: iconColor ?? (isActive ? Colors.white : AppColors.darkTextMuted),
      ),
    );
  }
}

/// Circular action button (for +/- temperature)
class BreezCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const BreezCircleButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      borderRadius: size / 2,
      backgroundColor: AppColors.accent,
      hoverColor: AppColors.accentLight,
      border: Border.all(color: Colors.transparent),
      shadows: [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.4),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}

/// Status indicator dot
class StatusDot extends StatelessWidget {
  final bool isActive;
  final double size;

  const StatusDot({
    super.key,
    required this.isActive,
    this.size = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentGreen : AppColors.accentRed,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.accentGreen.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Label with uppercase styling
class BreezLabel extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const BreezLabel(
    this.text, {
    super.key,
    this.fontSize = 8,
    this.color,
    this.fontWeight = FontWeight.w900,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: 2,
        color: color ?? AppColors.darkTextMuted,
      ),
    );
  }
}

/// Power button
class BreezPowerButton extends StatelessWidget {
  final bool isPowered;
  final VoidCallback? onTap;
  final double size;

  const BreezPowerButton({
    super.key,
    required this.isPowered,
    this.onTap,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      width: size,
      height: size,
      padding: EdgeInsets.zero,
      borderRadius: size / 2,
      backgroundColor: isPowered
          ? AppColors.accentGreen.withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.05),
      hoverColor: isPowered
          ? AppColors.accentGreen.withValues(alpha: 0.25)
          : Colors.white.withValues(alpha: 0.1),
      border: Border.all(
        color: isPowered
            ? AppColors.accentGreen.withValues(alpha: 0.3)
            : AppColors.darkBorder,
      ),
      child: Center(
        child: Icon(
          Icons.power_settings_new,
          size: size * 0.45,
          color: isPowered ? AppColors.accentGreen : AppColors.darkTextMuted,
        ),
      ),
    );
  }
}
