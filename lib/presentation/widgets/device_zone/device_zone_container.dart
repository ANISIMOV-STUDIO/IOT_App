/// Device Zone Container - visual wrapper for device-specific widgets
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Container that visually separates device-specific widgets from global ones
/// Uses accent border and subtle background tint
class DeviceZoneContainer extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final EdgeInsets? padding;
  final Color? accentColor;

  const DeviceZoneContainer({
    super.key,
    required this.child,
    this.header,
    this.padding,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? GlassColors.accentPrimary;

    return Container(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: accent,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header!,
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(GlassSpacing.md),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Visual divider between Device Zone and Global Zone
class ZoneDivider extends StatelessWidget {
  final String? label;
  final IconData? icon;

  const ZoneDivider({
    super.key,
    this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlassTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: GlassSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    t.colors.textTertiary.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          if (label != null || icon != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: t.colors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: t.shadows.convexSmall,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 14, color: t.colors.textTertiary),
                    const SizedBox(width: 6),
                  ],
                  if (label != null)
                    Text(
                      label!,
                      style: t.typography.labelSmall.copyWith(
                        color: t.colors.textTertiary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    t.colors.textTertiary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
