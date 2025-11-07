/// Room Detail Header Component
/// Header section with background and navigation
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

/// Room detail header with background image
class RoomDetailHeader extends StatelessWidget {
  final HvacUnit unit;

  const RoomDetailHeader({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final modeColor = HvacColors.getModeColor(unit.mode);

    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: HvacColors.backgroundDark,
      leading: _buildBackButton(context),
      actions: [_buildNotificationButton(context)],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          unit.location ?? unit.name,
          style: HvacTypography.titleLarge.copyWith(
            shadows: [
              const Shadow(
                color: Colors.black54,
                blurRadius: 8,
              ),
            ],
          ),
        ),
        background: _buildBackground(modeColor),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Semantics(
      label: 'Back',
      button: true,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24.0),
        constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
        onPressed: () {
          if (!kIsWeb) {
            HapticFeedback.lightImpact();
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    Widget button = Semantics(
      label: 'Notifications',
      button: true,
      child: IconButton(
        icon: const Icon(Icons.notifications_outlined, size: 24.0),
        constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
        onPressed: () {
          if (!kIsWeb) {
            HapticFeedback.lightImpact();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifications feature coming soon'),
              backgroundColor: HvacColors.info,
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );

    // Web enhancements
    if (kIsWeb) {
      button = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: button,
      );
    }

    return button;
  }

  Widget _buildBackground(Color modeColor) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image (placeholder for now)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                modeColor.withValues(alpha: 0.3),
                HvacColors.backgroundDark,
              ],
            ),
          ),
          child: Icon(
            Icons.home_outlined,
            size: 120.0,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                HvacColors.backgroundDark.withValues(alpha: 0.7),
                HvacColors.backgroundDark,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
