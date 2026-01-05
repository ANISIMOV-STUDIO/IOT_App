/// BREEZ Card & Button Components (Material Design)
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

/// Минимальный размер touch target по Material Design
const double kMinTouchTarget = 48.0;

/// BREEZ styled card using Material Card
class BreezCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool disabled;
  final bool isLoading;
  final String? title;
  final String? description;

  const BreezCard({
    super.key,
    required this.child,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: disabled ? 0.3 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.border),
        ),
        padding: padding ?? const EdgeInsets.all(24),
        child: IgnorePointer(
          ignoring: disabled,
          child: isLoading
              ? _buildShimmer(context, colors, isDark)
              : (title != null || description != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              (title ?? '').toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: colors.text,
                              ),
                            ),
                          ),
                        if (description != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              description ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textMuted,
                              ),
                            ),
                          ),
                        child,
                      ],
                    )
                  : child),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context, BreezColors colors, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (title != null) const SizedBox(height: 4),
          if (description != null)
            Container(
              width: 120,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (description != null) const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
          ),
        ],
      ),
    );
  }
}

/// Base BREEZ button with premium animations
///
/// Единый базовый класс для всех кнопок приложения.
/// Поддерживает hover, press, loading состояния с плавными анимациями.
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
  final bool isLoading;
  final bool showBorder;
  final bool enableScale;
  final bool enableGlow;
  final bool enforceMinTouchTarget;

  const BreezButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.hoverColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppRadius.button,
    this.shadows,
    this.border,
    this.isLoading = false,
    this.showBorder = true,
    this.enableScale = true,
    this.enableGlow = false,
    this.enforceMinTouchTarget = true,
  });

  @override
  State<BreezButton> createState() => _BreezButtonState();
}

class _BreezButtonState extends State<BreezButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    // Spring-like scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    if (widget.enableScale) _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    if (widget.enableScale) _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    if (widget.enableScale) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final bg = widget.backgroundColor ?? colors.buttonBg;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Touch target constraints (only enforce if enforceMinTouchTarget is true)
    final minTarget = widget.enforceMinTouchTarget ? kMinTouchTarget : 0.0;
    final buttonWidth = widget.width != null
        ? ((widget.width ?? 0) < minTarget ? minTarget : widget.width)
        : null;
    final buttonHeight = widget.height != null
        ? ((widget.height ?? 0) < minTarget ? minTarget : widget.height)
        : null;

    // State-based colors
    final effectiveBg = _isPressed
        ? Color.lerp(bg, isDark ? Colors.white : Colors.black, 0.1)!
        : _isHovered
            ? (widget.hoverColor ?? Color.lerp(bg, isDark ? Colors.white : Colors.black, 0.05)!)
            : bg;

    final effectiveBorder = widget.showBorder
        ? (_isHovered ? colors.borderAccent : colors.border)
        : Colors.transparent;

    // Hover glow for accent buttons
    final glowShadows = widget.enableGlow && _isHovered
        ? [BoxShadow(
            color: (widget.backgroundColor ?? AppColors.accent).withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: -2,
          )]
        : widget.shadows;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isLoading || widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = widget.enableScale ? _scaleAnimation.value : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                constraints: BoxConstraints(
                  minHeight: minTarget,
                  minWidth: buttonWidth ?? 0,
                ),
                padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: effectiveBg,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: widget.showBorder ? Border.all(color: effectiveBorder) : null,
                  boxShadow: glowShadows,
                ),
                child: child,
              ),
            );
          },
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.text),
                    ),
                  ),
                )
              : widget.child,
        ),
      ),
    );
  }
}

/// Icon button with consistent styling and optional badge
class BreezIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isActive;
  final double size;
  final String? badge;
  final bool showBorder;

  const BreezIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.isActive = false,
    this.size = 20,
    this.badge,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    const padding = 12.0;
    final buttonSize = (size + padding * 2) < kMinTouchTarget
        ? kMinTouchTarget
        : (size + padding * 2);
    final iconPadding = (buttonSize - size) / 2;

    final bg = backgroundColor ?? (isActive ? AppColors.accent : colors.card);
    final effectiveIconColor = iconColor ?? (isActive ? Colors.white : colors.textMuted);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        BreezButton(
          onTap: onTap,
          width: buttonSize,
          height: buttonSize,
          padding: EdgeInsets.all(iconPadding),
          backgroundColor: bg,
          hoverColor: isActive ? AppColors.accentLight : colors.cardLight,
          showBorder: showBorder,
          enableGlow: isActive,
          child: Icon(
            icon,
            size: size,
            color: effectiveIconColor,
          ),
        ),
        // Badge
        if (badge != null)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: AppColors.critical,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
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
    // Обеспечиваем минимальный touch target
    final buttonSize = size < kMinTouchTarget ? kMinTouchTarget : size;

    return BreezButton(
      onTap: onTap,
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.zero,
      borderRadius: buttonSize / 2,
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
          size: buttonSize * 0.5,
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
    final colors = BreezColors.of(context);
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: 2,
        color: color ?? colors.textMuted,
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
    final colors = BreezColors.of(context);
    // Обеспечиваем минимальный touch target
    final buttonSize = size < kMinTouchTarget ? kMinTouchTarget : size;

    return BreezButton(
      onTap: onTap,
      width: buttonSize,
      height: buttonSize,
      padding: EdgeInsets.zero,
      borderRadius: buttonSize / 2,
      backgroundColor: isPowered
          ? AppColors.accentGreen.withValues(alpha: 0.15)
          : colors.buttonBg,
      hoverColor: isPowered
          ? AppColors.accentGreen.withValues(alpha: 0.25)
          : colors.cardLight,
      border: Border.all(
        color: isPowered
            ? AppColors.accentGreen.withValues(alpha: 0.3)
            : colors.border,
      ),
      child: Center(
        child: Icon(
          Icons.power_settings_new,
          size: buttonSize * 0.45,
          color: isPowered ? AppColors.accentGreen : colors.textMuted,
        ),
      ),
    );
  }
}

/// Dialog action button (primary/secondary with optional loading)
class BreezDialogButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isLoading;
  final bool isDanger;

  const BreezDialogButton({
    super.key,
    required this.label,
    this.onTap,
    this.isPrimary = false,
    this.isLoading = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    final Color bgColor;
    final Color textColor;
    final Color hoverColor;
    final Color splashColor;

    if (isDanger) {
      bgColor = AppColors.accentRed;
      textColor = Colors.white;
      hoverColor = AppColors.accentRed.withValues(alpha: 0.8);
      splashColor = Colors.white.withValues(alpha: 0.2);
    } else if (isPrimary) {
      bgColor = AppColors.accent;
      textColor = Colors.white;
      hoverColor = AppColors.accentLight;
      splashColor = AppColors.accent.withValues(alpha: 0.3);
    } else {
      bgColor = Colors.transparent;
      textColor = colors.textMuted;
      hoverColor = colors.text.withValues(alpha: 0.05);
      splashColor = AppColors.accent.withValues(alpha: 0.1);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        hoverColor: hoverColor,
        splashColor: splashColor,
        highlightColor: splashColor.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: (isPrimary || isDanger) ? null : Border.all(color: colors.border),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: (isPrimary || isDanger) ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Settings row button with icon, label, subtitle
class BreezSettingsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDanger;

  const BreezSettingsButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = isDanger ? AppColors.accentRed : colors.text;
    final bgColor = isDanger
        ? AppColors.accentRed.withValues(alpha: 0.1)
        : colors.cardLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        hoverColor: isDanger
            ? AppColors.accentRed.withValues(alpha: 0.15)
            : colors.border.withValues(alpha: 0.3),
        splashColor: isDanger
            ? AppColors.accentRed.withValues(alpha: 0.2)
            : AppColors.accent.withValues(alpha: 0.1),
        highlightColor: isDanger
            ? AppColors.accentRed.withValues(alpha: 0.1)
            : AppColors.accent.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDanger
                  ? AppColors.accentRed.withValues(alpha: 0.3)
                  : colors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
