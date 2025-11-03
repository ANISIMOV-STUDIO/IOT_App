/// Camera Toolbar Widget
///
/// Provides camera controls for QR scanner
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      top: MediaQuery.of(context).padding.top + AppSpacing.mdR,
      left: AppSpacing.mdR,
      right: AppSpacing.mdR,
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
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.smR),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24.w,
          ),
        ),
      ),
    );
  }
}