import 'package:flutter/material.dart';

/// Premium Glass Design System - Color Tokens
/// Clean, minimal palette inspired by Apple/Tesla
abstract class GlassColors {
  // ============================================
  // LIGHT THEME - Clean whites and soft grays
  // ============================================

  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightGlass = Color(0xF2FFFFFF); // 95% white
  static const Color lightGlassBorder = Color(0x1A000000); // 10% black
  static const Color lightCardSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  // ============================================
  // DARK THEME - Deep blacks with subtle blue
  // ============================================

  static const Color darkSurface = Color(0xFF000000);
  static const Color darkGlass = Color(0xF21C1C1E); // 95% dark
  static const Color darkGlassBorder = Color(0x33FFFFFF); // 20% white
  static const Color darkCardSurface = Color(0xFF1C1C1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color darkTextTertiary = Color(0xFF636366);

  // ============================================
  // ACCENT - Vibrant, saturated colors
  // ============================================

  static const Color accentPrimary = Color(0xFF007AFF); // iOS Blue
  static const Color accentSuccess = Color(0xFF34C759); // iOS Green
  static const Color accentWarning = Color(0xFFFF9500); // iOS Orange
  static const Color accentError = Color(0xFFFF3B30); // iOS Red
  static const Color accentInfo = Color(0xFF5AC8FA); // iOS Teal

  // ============================================
  // CLIMATE MODES - Rich, distinct colors
  // ============================================

  static const Color modeHeating = Color(0xFFFF6B35); // Warm orange
  static const Color modeCooling = Color(0xFF00B4D8); // Cool cyan
  static const Color modeDry = Color(0xFF8B5CF6); // Purple
  static const Color modeAuto = Color(0xFF34C759); // Green

  // ============================================
  // AIR QUALITY - Clear indicators
  // ============================================

  static const Color airQualityExcellent = Color(0xFF34C759);
  static const Color airQualityGood = Color(0xFF30D158);
  static const Color airQualityModerate = Color(0xFFFFCC00);
  static const Color airQualityPoor = Color(0xFFFF9500);
  static const Color airQualityHazardous = Color(0xFFFF3B30);

  // ============================================
  // TOGGLE
  // ============================================

  static const Color toggleActiveTrack = Color(0xFF34C759);
  static const Color toggleActiveThumb = Color(0xFFFFFFFF);
  static const Color toggleInactiveTrack = Color(0xFFE5E5EA);
  static const Color toggleInactiveThumb = Color(0xFFFFFFFF);

  // ============================================
  // GRADIENTS - Subtle, elegant
  // ============================================

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF2F2F7), Color(0xFFFFFFFF)],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF000000), Color(0xFF1C1C1E)],
  );

  static const LinearGradient glassBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40FFFFFF), Color(0x10FFFFFF)],
  );
}

typedef NeumorphicColors = GlassColors;
