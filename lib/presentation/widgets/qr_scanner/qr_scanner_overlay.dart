/// QR Scanner Overlay Widget
///
/// Provides visual frame and corner markers for QR code scanning
/// Responsive design for mobile, tablet, and web
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../core/theme/spacing.dart';
import 'qr_scanner_responsive.dart';
import 'scanner_animation_line.dart';
import 'scanner_corner_marker.dart';

class QrScannerOverlay extends StatelessWidget {
  final bool isScanning;
  final String? statusMessage;
  final Color? frameColor;
  final double? frameSize;

  const QrScannerOverlay({
    super.key,
    this.isScanning = true,
    this.statusMessage,
    this.frameColor,
    this.frameSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsive = QrScannerResponsive(context);
    final effectiveFrameSize = frameSize ?? responsive.scannerFrameSize;
    final effectiveFrameColor = frameColor ?? theme.colorScheme.primary;

    return Stack(
      children: [
        // Semi-transparent overlay with cutout
        CustomPaint(
          size: Size.infinite,
          painter: _OverlayPainter(
            frameSize: effectiveFrameSize,
            frameColor: effectiveFrameColor,
          ),
        ),

        // Scanner frame with corners
        Center(
          child: Container(
            width: effectiveFrameSize,
            height: effectiveFrameSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: effectiveFrameColor.withValues(alpha: 0.3),
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(responsive.borderRadius),
            ),
            child: Stack(
              children: [
                // Top-left corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: ScannerCornerMarker(
                    size: responsive.cornerMarkerSize,
                    color: effectiveFrameColor,
                    topLeft: true,
                  ),
                ),
                // Top-right corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: ScannerCornerMarker(
                    size: responsive.cornerMarkerSize,
                    color: effectiveFrameColor,
                    topRight: true,
                  ),
                ),
                // Bottom-left corner
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: ScannerCornerMarker(
                    size: responsive.cornerMarkerSize,
                    color: effectiveFrameColor,
                    bottomLeft: true,
                  ),
                ),
                // Bottom-right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ScannerCornerMarker(
                    size: responsive.cornerMarkerSize,
                    color: effectiveFrameColor,
                    bottomRight: true,
                  ),
                ),

                // Scanning animation line
                if (isScanning)
                  ScannerAnimationLine(
                    frameSize: effectiveFrameSize,
                    color: effectiveFrameColor,
                  ),
              ],
            ),
          ),
        ),

        // Status message
        if (statusMessage != null)
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lgR,
                  vertical: AppSpacing.smR,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: HvacRadius.xxlRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isScanning) ...[
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: AppSpacing.xsR),
                    ],
                    Text(
                      statusMessage!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double frameSize;
  final Color frameColor;

  _OverlayPainter({
    required this.frameSize,
    required this.frameColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: frameSize,
      height: frameSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(12.r))),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) {
    return oldDelegate.frameSize != frameSize ||
        oldDelegate.frameColor != frameColor;
  }
}