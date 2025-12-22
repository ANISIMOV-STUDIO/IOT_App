/// Glowing status dot widget
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Status dot with optional glow effect
class GlowingStatusDot extends StatelessWidget {
  final Color color;
  final double size;
  final bool isGlowing;

  const GlowingStatusDot({
    super.key,
    required this.color,
    this.size = 8,
    this.isGlowing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: isGlowing
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: size,
                  spreadRadius: size * 0.3,
                ),
              ]
            : null,
      ),
    );
  }
}
