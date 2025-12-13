import 'package:flutter/material.dart';
import '../../theme/design_system.dart';

/// Golden Ratio based row layout
/// Splits children in 61.8% / 38.2% proportion
class GoldenRow extends StatelessWidget {
  final Widget primary;
  final Widget secondary;
  final double gap;
  final bool reversed;
  final CrossAxisAlignment crossAxisAlignment;

  const GoldenRow({
    super.key,
    required this.primary,
    required this.secondary,
    this.gap = DesignSystem.space3,
    this.reversed = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      Expanded(
        flex: 618, // 61.8%
        child: primary,
      ),
      SizedBox(width: gap),
      Expanded(
        flex: 382, // 38.2%
        child: secondary,
      ),
    ];

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: reversed ? children.reversed.toList() : children,
    );
  }
}

/// Two-thirds / One-third row layout
class TwoThirdsRow extends StatelessWidget {
  final Widget large;
  final Widget small;
  final double gap;
  final bool reversed;
  final CrossAxisAlignment crossAxisAlignment;

  const TwoThirdsRow({
    super.key,
    required this.large,
    required this.small,
    this.gap = DesignSystem.space3,
    this.reversed = false,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      Expanded(
        flex: 2,
        child: large,
      ),
      SizedBox(width: gap),
      Expanded(
        flex: 1,
        child: small,
      ),
    ];

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: reversed ? children.reversed.toList() : children,
    );
  }
}

/// Equal split row with configurable columns
class EqualRow extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;

  const EqualRow({
    super.key,
    required this.children,
    this.gap = DesignSystem.space3,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i < children.length - 1) SizedBox(width: gap),
        ],
      ],
    );
  }
}

/// Dashboard section with title and optional action
class DashboardSection extends StatelessWidget {
  final String? title;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const DashboardSection({
    super.key,
    this.title,
    this.action,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (title == null) {
      return Padding(padding: padding, child: child);
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: const TextStyle(
                  fontSize: DesignSystem.fontSize4,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const VGap.md(),
          child,
        ],
      ),
    );
  }
}

/// Primary hero card (larger, more prominent)
class HeroCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const HeroCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(DesignSystem.space4),
    this.borderRadius = DesignSystem.radiusXl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Standard card with consistent styling
class StandardCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;

  const StandardCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(DesignSystem.space3),
    this.borderRadius = DesignSystem.radiusMd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );
  }
}

/// Stat display widget with label, value, and unit
class StatDisplay extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color? valueColor;
  final IconData? icon;
  final Color? iconColor;

  const StatDisplay({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.valueColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(DesignSystem.space1),
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.blue).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
            ),
            child: Icon(icon, size: DesignSystem.iconSm, color: iconColor),
          ),
          const VGap.sm(),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: DesignSystem.fontSize1,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: DesignSystem.fontSize6,
                fontWeight: FontWeight.w700,
                color: valueColor ?? Colors.black87,
                height: 1,
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(
                unit!,
                style: TextStyle(
                  fontSize: DesignSystem.fontSize2,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
