/// Control Buttons Widget
///
/// Displays power and mode control buttons with neumorphic design
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';

class OverviewControlButtons extends StatelessWidget {
  final HvacUnit unit;
  final VoidCallback? onPowerTap;
  final VoidCallback? onModeTap;

  const OverviewControlButtons({
    super.key,
    required this.unit,
    this.onPowerTap,
    this.onModeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Управление',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.0,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildPowerButton(),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildModeButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerButton() {
    return HvacInteractiveScale(
      onTap: onPowerTap,
      child: HvacNeumorphicButton(
        onPressed: onPowerTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              unit.power ? Icons.power_off : Icons.power_settings_new,
              color: unit.power ? HvacColors.error : HvacColors.success,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              unit.power ? 'Выключить' : 'Включить',
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton() {
    return HvacInteractiveScale(
      onTap: onModeTap,
      child: HvacNeumorphicButton(
        onPressed: onModeTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.settings,
              color: HvacColors.primaryOrange,
              size: 20.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Режим',
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
