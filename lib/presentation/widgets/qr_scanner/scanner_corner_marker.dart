/// Scanner Corner Marker Widget
///
/// Provides corner markers for QR scanner frame
library;

import 'package:flutter/material.dart';

class ScannerCornerMarker extends StatelessWidget {
  final double size;
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  const ScannerCornerMarker({
    super.key,
    required this.size,
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: (topLeft || topRight)
              ? BorderSide(color: color, width: 4.0)
              : BorderSide.none,
          bottom: (bottomLeft || bottomRight)
              ? BorderSide(color: color, width: 4.0)
              : BorderSide.none,
          left: (topLeft || bottomLeft)
              ? BorderSide(color: color, width: 4.0)
              : BorderSide.none,
          right: (topRight || bottomRight)
              ? BorderSide(color: color, width: 4.0)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? const Radius.circular(8.0) : Radius.zero,
          topRight: topRight ? const Radius.circular(8.0) : Radius.zero,
          bottomLeft: bottomLeft ? const Radius.circular(8.0) : Radius.zero,
          bottomRight: bottomRight ? const Radius.circular(8.0) : Radius.zero,
        ),
      ),
    );
  }
}
