/// Camera Toolbar Widget
///
/// Provides camera controls for QR scanner
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/spacing.dart';

class CameraToolbar extends StatelessWidget {
  final MobileScannerController controller;
  final VoidCallback? onTorchToggle;

  const CameraToolbar({
    super.key,
    required this.controller,
    this.onTorchToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSpacing.md,
      left: AppSpacing.md,
      right: AppSpacing.md,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Camera switch button
          _ToolbarButton(
            icon: Icons.cameraswitch,
            onTap: () => controller.switchCamera(),
          ),

          // Torch toggle button
          _ToolbarButton(
            icon: controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
            onTap: () {
              controller.toggleTorch();
              onTorchToggle?.call();
            },
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      borderRadius: HvacRadius.xxlRadius,
      child: InkWell(
        borderRadius: HvacRadius.xxlRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}