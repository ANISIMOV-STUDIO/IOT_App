/// Add Device Button Widget
///
/// A prominent button for adding new HVAC devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

class DeviceAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const DeviceAddButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(HvacSpacing.md),
      child: HvacInteractiveScale(
        child: Container(
          decoration: HvacDecorations.gradientBlue(),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: HvacRadius.lgRadius,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.lg,
                  vertical: HvacSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle_outline_rounded,
                      color: HvacColors.textPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: HvacSpacing.sm),
                    Text(
                      l10n.addDevice,
                      style: const TextStyle(
                        color: HvacColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}