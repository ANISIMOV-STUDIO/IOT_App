import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Card variant
enum HvacCardVariant {
  standard, // Standard card
  elevated, // Card with shadow
  glass, // Glassmorphism
  outlined, // Outlined card
}

/// Card size variant
enum HvacCardSize {
  compact, // Minimal padding
  medium, // Default padding
  large, // Generous padding
}

/// Professional card component
///
/// Usage:
/// ```dart
/// HvacCard(
///   variant: HvacCardVariant.glass,
///   child: Text('Content'),
/// )
/// ```
class HvacCard extends StatefulWidget {
  /// Card content
  final Widget child;

  /// Card variant
  final HvacCardVariant variant;

  /// Card size
  final HvacCardSize size;

  /// Enable hover effects
  final bool enableHover;

  /// On tap callback
  final VoidCallback? onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom border color
  final Color? borderColor;

  /// Enable border
  final bool showBorder;

  /// Custom padding (overrides size padding)
  final EdgeInsets? padding;

  /// Minimum height constraint
  final double? minHeight;

  const HvacCard({
    super.key,
    required this.child,
    this.variant = HvacCardVariant.standard,
    this.size = HvacCardSize.medium,
    this.enableHover = true,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.showBorder = true,
    this.padding,
    this.minHeight,
  });

  @override
  State<HvacCard> createState() => _HvacCardState();
}

class _HvacCardState extends State<HvacCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter:
          widget.enableHover ? (_) => setState(() => _isHovered = true) : null,
      onExit:
          widget.enableHover ? (_) => setState(() => _isHovered = false) : null,
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          constraints: widget.minHeight != null
              ? BoxConstraints(minHeight: widget.minHeight!)
              : null,
          padding: _getPadding(),
          decoration: _buildDecoration(),
          child: widget.child,
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    if (widget.padding != null) return widget.padding!;

    switch (widget.size) {
      case HvacCardSize.compact:
        return const EdgeInsets.all(HvacSpacing.md);
      case HvacCardSize.medium:
        return const EdgeInsets.all(HvacSpacing.lg);
      case HvacCardSize.large:
        return const EdgeInsets.all(HvacSpacing.xl);
    }
  }

  BoxDecoration _buildDecoration() {
    switch (widget.variant) {
      case HvacCardVariant.standard:
        return BoxDecoration(
          color: widget.backgroundColor ?? HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
          border: widget.showBorder
              ? Border.all(
                  color: _isHovered
                      ? (widget.borderColor ??
                          HvacColors.backgroundCardBorderHover)
                      : (widget.borderColor ??
                          HvacColors.backgroundCardBorder),
                  width: _isHovered ? 2 : 1.5,
                )
              : null,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
        );

      case HvacCardVariant.elevated:
        return BoxDecoration(
          color: widget.backgroundColor ?? HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
          border: widget.showBorder
              ? Border.all(
                  color: _isHovered
                      ? HvacColors.backgroundCardBorderActive
                      : (widget.borderColor ??
                          HvacColors.backgroundCardBorder),
                  width: _isHovered ? 2.5 : 1.5,
                )
              : null,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.22),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.16),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: -1,
                  ),
                ],
        );

      case HvacCardVariant.glass:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HvacColors.glassWhite.withValues(alpha: 0.15),
              HvacColors.glassWhite.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
          border: Border.all(
            color: HvacColors.glassBorder,
            width: 1,
          ),
        );

      case HvacCardVariant.outlined:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
          border: Border.all(
            color: widget.borderColor ?? HvacColors.accent,
            width: _isHovered ? 2 : 1,
          ),
        );
    }
  }
}

/// Stat card for displaying statistics
///
/// Usage:
/// ```dart
/// HvacStatCard(
///   title: 'Temperature',
///   value: '24°C',
///   icon: Icons.thermostat,
/// )
/// ```
class HvacStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const HvacStatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HvacCard(
      variant: HvacCardVariant.elevated,
      size: HvacCardSize.medium,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon and title
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? HvacColors.accent,
                ),
                const SizedBox(width: HvacSpacing.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: HvacColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.md),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              color: HvacColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: HvacSpacing.xs),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: HvacColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Info card with icon
///
/// Usage:
/// ```dart
/// HvacInfoCard(
///   icon: Icons.info_outline,
///   title: 'Information',
///   message: 'System is operating normally',
/// )
/// ```
class HvacInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color? iconColor;
  final VoidCallback? onTap;

  const HvacInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HvacCard(
      variant: HvacCardVariant.standard,
      size: HvacCardSize.medium,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 48,
            color: iconColor ?? HvacColors.info,
          ),
          const SizedBox(width: HvacSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: HvacColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: HvacSpacing.xs),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
