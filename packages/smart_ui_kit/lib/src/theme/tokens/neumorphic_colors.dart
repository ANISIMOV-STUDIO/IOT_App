import 'package:flutter/material.dart';

/// Neumorphic Design System - Color Tokens
/// Based on Smart Home Dashboard reference
abstract class NeumorphicColors {
  // ============================================
  // LIGHT THEME PALETTE
  // ============================================
  
  /// Base surface color for light theme (soft gray)
  static const Color lightSurface = Color(0xFFE8EAEC);
  
  /// Darker shade for inner shadows (light theme)
  static const Color lightShadowDark = Color(0xFFBEC3C9);
  
  /// Lighter shade for outer shadows (light theme)
  static const Color lightShadowLight = Color(0xFFFFFFFF);
  
  /// Card/elevated surface color (light theme)
  static const Color lightCardSurface = Color(0xFFF0F2F4);
  
  /// Primary text color (light theme)
  static const Color lightTextPrimary = Color(0xFF2D3436);
  
  /// Secondary text color (light theme)
  static const Color lightTextSecondary = Color(0xFF636E72);
  
  /// Tertiary/muted text (light theme)
  static const Color lightTextTertiary = Color(0xFF949CA0);

  // ============================================
  // DARK THEME PALETTE
  // ============================================
  
  /// Base surface color for dark theme
  static const Color darkSurface = Color(0xFF2D3436);
  
  /// Darker shade for inner shadows (dark theme)
  static const Color darkShadowDark = Color(0xFF1E2426);
  
  /// Lighter shade for outer shadows (dark theme)
  static const Color darkShadowLight = Color(0xFF3C4446);
  
  /// Card/elevated surface color (dark theme)
  static const Color darkCardSurface = Color(0xFF353B3D);
  
  /// Primary text color (dark theme)
  static const Color darkTextPrimary = Color(0xFFF5F6FA);
  
  /// Secondary text color (dark theme)
  static const Color darkTextSecondary = Color(0xFFB2BEC3);
  
  /// Tertiary/muted text (dark theme)
  static const Color darkTextTertiary = Color(0xFF636E72);

  // ============================================
  // ACCENT COLORS (shared)
  // ============================================
  
  /// Primary accent - Blue
  static const Color accentPrimary = Color(0xFF0984E3);
  
  /// Success - Green
  static const Color accentSuccess = Color(0xFF00B894);
  
  /// Warning - Orange
  static const Color accentWarning = Color(0xFFFDAA5D);
  
  /// Error - Red
  static const Color accentError = Color(0xFFD63031);
  
  /// Info - Cyan
  static const Color accentInfo = Color(0xFF74B9FF);

  // ============================================
  // CLIMATE CONTROL COLORS
  // ============================================
  
  /// Heating mode - warm orange/red
  static const Color modeHeating = Color(0xFFE17055);
  
  /// Cooling mode - cool blue
  static const Color modeCooling = Color(0xFF74B9FF);
  
  /// Dry mode - neutral
  static const Color modeDry = Color(0xFF636E72);
  
  /// Auto mode - green
  static const Color modeAuto = Color(0xFF00B894);

  // ============================================
  // AIR QUALITY INDICATORS
  // ============================================
  
  static const Color airQualityExcellent = Color(0xFF00B894);
  static const Color airQualityGood = Color(0xFF55EFC4);
  static const Color airQualityModerate = Color(0xFFFDAA5D);
  static const Color airQualityPoor = Color(0xFFE17055);
  static const Color airQualityHazardous = Color(0xFFD63031);

  // ============================================
  // TOGGLE / SWITCH COLORS
  // ============================================
  
  static const Color toggleActiveTrack = Color(0xFF0984E3);
  static const Color toggleActiveThumb = Color(0xFFFFFFFF);
  static const Color toggleInactiveTrack = Color(0xFFB2BEC3);
  static const Color toggleInactiveThumb = Color(0xFFFFFFFF);
}
