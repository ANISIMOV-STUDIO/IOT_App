import 'package:flutter/material.dart';
import 'neumorphic_colors.dart';

/// Neumorphic Shadow System
/// Provides convex (raised) and concave (pressed) shadow effects
class NeumorphicShadows {
  final bool isDark;
  
  const NeumorphicShadows._({required this.isDark});
  
  /// Light theme shadows
  static const light = NeumorphicShadows._(isDark: false);
  
  /// Dark theme shadows
  static const dark = NeumorphicShadows._(isDark: true);
  
  /// Get shadow colors based on theme
  Color get shadowDark => isDark 
      ? NeumorphicColors.darkShadowDark 
      : NeumorphicColors.lightShadowDark;
      
  Color get shadowLight => isDark 
      ? NeumorphicColors.darkShadowLight 
      : NeumorphicColors.lightShadowLight;

  // ============================================
  // CONVEX (Raised) Shadows - For cards, buttons
  // ============================================
  
  /// Small convex shadow (subtle elevation)
  List<BoxShadow> get convexSmall => [
    BoxShadow(
      color: shadowDark.withValues(alpha: 0.15),
      offset: const Offset(3, 3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight.withValues(alpha: 0.8),
      offset: const Offset(-3, -3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  /// Medium convex shadow (default cards)
  List<BoxShadow> get convexMedium => [
    BoxShadow(
      color: shadowDark.withValues(alpha: 0.2),
      offset: const Offset(6, 6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight.withValues(alpha: 0.9),
      offset: const Offset(-6, -6),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  /// Large convex shadow (prominent elements)
  List<BoxShadow> get convexLarge => [
    BoxShadow(
      color: shadowDark.withValues(alpha: 0.25),
      offset: const Offset(10, 10),
      blurRadius: 20,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight.withValues(alpha: 1.0),
      offset: const Offset(-10, -10),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // ============================================
  // CONCAVE (Pressed) Shadows - For inputs, pressed states
  // ============================================
  
  /// Small concave shadow (subtle inset)
  List<BoxShadow> get concaveSmall => [
    BoxShadow(
      color: shadowDark.withValues(alpha: 0.15),
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: shadowLight.withValues(alpha: 0.7),
      offset: const Offset(-2, -2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  /// Medium concave shadow (inputs, pressed buttons)
  List<BoxShadow> get concaveMedium => [
    BoxShadow(
      color: shadowDark.withValues(alpha: 0.2),
      offset: const Offset(4, 4),
      blurRadius: 8,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: shadowLight.withValues(alpha: 0.8),
      offset: const Offset(-4, -4),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  // ============================================
  // FLAT Shadows - Minimal depth
  // ============================================
  
  List<BoxShadow> get flat => [
    BoxShadow(
      color: shadowDark.withValues(alpha: 0.08),
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  // ============================================
  // INNER Shadows (using gradient simulation)
  // ============================================
  
  /// Creates an inner shadow decoration for concave effect
  BoxDecoration innerShadowDecoration({
    required Color baseColor,
    double radius = 16,
  }) {
    return BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          shadowDark.withValues(alpha: 0.1),
          baseColor,
          shadowLight.withValues(alpha: 0.3),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }
}
