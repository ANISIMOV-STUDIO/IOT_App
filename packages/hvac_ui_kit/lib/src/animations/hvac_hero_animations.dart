/// HVAC UI Kit - Hero Animations
///
/// Enhanced Hero animations for cross-screen transitions
library;

import 'package:flutter/material.dart';

/// Temperature hero animation
class HvacTemperatureHero extends StatelessWidget {
  final String tag;
  final String temperature;
  final TextStyle? style;

  const HvacTemperatureHero({
    super.key,
    required this.tag,
    required this.temperature,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: Text(
          temperature,
          style: style ?? const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// Device status hero animation
class HvacStatusHero extends StatelessWidget {
  final String tag;
  final Widget child;

  const HvacStatusHero({
    super.key,
    required this.tag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}

/// Icon hero animation
class HvacIconHero extends StatelessWidget {
  final String tag;
  final IconData icon;
  final double? size;
  final Color? color;

  const HvacIconHero({
    super.key,
    required this.tag,
    required this.icon,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Icon(
        icon,
        size: size ?? 64,
        color: color,
      ),
    );
  }
}

/// Custom page route with Hero support
class HvacHeroPageRoute<T> extends MaterialPageRoute<T> {
  HvacHeroPageRoute({
    required super.builder,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 400);
}

/// Hero animation helper methods
class HvacHeroHelper {
  /// Create a hero widget with tag
  static Widget createHero({
    required String tag,
    required Widget child,
    HeroFlightShuttleBuilder? flightShuttleBuilder,
  }) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: flightShuttleBuilder ??
          (flightContext, animation, direction, fromContext, toContext) {
            return DefaultTextStyle(
              style: DefaultTextStyle.of(toContext).style,
              child: toContext.widget,
            );
          },
      child: child,
    );
  }

  /// Navigate with hero animation
  static Future<T?> navigateWithHero<T>(
    BuildContext context,
    Widget destination,
  ) {
    return Navigator.push(
      context,
      HvacHeroPageRoute(builder: (_) => destination),
    );
  }
}
