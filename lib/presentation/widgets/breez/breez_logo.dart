/// BREEZ Logo Component
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hvac_control/core/theme/app_theme.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezLogo
abstract class _LogoConstants {
  static const double textLineHeight = 1;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// BREEZ logo with icon and text
class BreezLogo extends StatelessWidget {

  const BreezLogo({
    super.key,
    this.iconSize,
    this.titleSize,
    this.subtitleSize,
    this.spacing = 8,
  });

  /// Default size logo (32px icon, 20/8 text)
  const BreezLogo.medium({
    super.key,
    this.spacing = 8,
  })  : iconSize = 32,
        titleSize = 20,
        subtitleSize = 8;

  /// Small size logo (24px icon, 14px title only)
  const BreezLogo.small({
    super.key,
    this.spacing = 6,
  })  : iconSize = 24,
        titleSize = 14,
        subtitleSize = null;

  /// Large size logo (40px icon, 24/10 text)
  const BreezLogo.large({
    super.key,
    this.spacing = 10,
  })  : iconSize = 40,
        titleSize = 24,
        subtitleSize = 10;
  final double? iconSize;
  final double? titleSize;
  final double? subtitleSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final effectiveIconSize = iconSize ?? 32;
    final effectiveTitleSize = titleSize ?? 20;
    final effectiveSubtitleSize = subtitleSize ?? 8;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon
        SvgPicture.asset(
          'assets/images/breez-logo.svg',
          width: effectiveIconSize,
          height: effectiveIconSize,
          colorFilter: ColorFilter.mode(
            colors.text,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: spacing),
        // Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BREEZ',
              style: TextStyle(
                fontSize: effectiveTitleSize,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
                height: _LogoConstants.textLineHeight,
                color: colors.text,
              ),
            ),
            if (subtitleSize != null)
              Text(
                'SMART SYSTEMS',
                style: TextStyle(
                  fontSize: effectiveSubtitleSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: colors.textMuted,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
