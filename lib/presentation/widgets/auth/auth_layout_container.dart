/// Authentication Layout Container
///
/// Responsive container that adapts to different screen sizes
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import 'responsive_utils.dart';

class AuthLayoutContainer extends StatelessWidget {
  final Widget child;
  final bool showDecoration;

  const AuthLayoutContainer({
    super.key,
    required this.child,
    this.showDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient for desktop
          if (responsive.isDesktop && showDecoration)
            _buildBackgroundDecoration(context),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.horizontalPadding,
                    vertical: 24,
                  ),
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: responsive.formMaxWidth,
                      ),
                      child: responsive.isDesktop
                          ? _buildDesktopCard(context, child)
                          : child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCard(BuildContext context, Widget child) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: HvacRadius.xxlRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    ).animate().fadeIn(duration: 400.ms).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildBackgroundDecoration(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withAlpha(5),
            Theme.of(context).primaryColor.withAlpha(13),
            Theme.of(context).primaryColor.withAlpha(5),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _PatternPainter(context),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final BuildContext context;

  _PatternPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).primaryColor.withAlpha(5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({
    super.key,
    this.text = 'OR',
  });

  @override
  Widget build(BuildContext context) {
    final responsive = AuthResponsive(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Theme.of(context).dividerColor,
                ],
                stops: const [0.0, 0.3],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: (13 * responsive.fontMultiplier).rsp(context),
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).dividerColor,
                  Colors.transparent,
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}
