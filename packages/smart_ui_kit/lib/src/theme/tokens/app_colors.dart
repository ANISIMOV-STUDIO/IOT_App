import 'package:flutter/material.dart';

/// Semantic Color Palette
abstract class AppColors {
  // Primitives (Palette)
  static const _blue600 = Color(0xFF2563EB);
  static const _blue700 = Color(0xFF1D4ED8);
  
  static const _slate50 = Color(0xFFF8FAFC);
  static const _slate100 = Color(0xFFF1F5F9);
  static const _slate200 = Color(0xFFE2E8F0);
  static const _slate400 = Color(0xFF94A3B8);
  static const _slate700 = Color(0xFF334155);
  static const _slate800 = Color(0xFF1E293B);
  static const _slate900 = Color(0xFF0F172A);

  static const _green500 = Color(0xFF10B981);
  static const _red500 = Color(0xFFEF4444);
  static const _orange500 = Color(0xFFF59E0B);

  // Light Theme Scheme
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: _blue600,
    onPrimary: Colors.white,
    secondary: _blue700,
    onSecondary: Colors.white,
    error: _red500,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: _slate900,
    surfaceContainerHighest: _slate100, // For cards
    outline: _slate200,
  );

  // Dark Theme Scheme
  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _blue600,
    onPrimary: Colors.white,
    secondary: _blue700,
    onSecondary: Colors.white,
    error: _red500,
    onError: Colors.white,
    surface: _slate800,
    onSurface: _slate50,
    surfaceContainerHighest: _slate900, // For cards
    outline: _slate700,
  );
  
  // Semantic Colors (Helpers)
  static Color get success => _green500;
  static Color get warning => _orange500;
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [_blue600, Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy/Default Colors (for AppTypography)
  static const Color textPrimary = _slate900;
  static const Color textSecondary = _slate400;
  static const Color textDisabled = _slate200;
  static const Color primary = _blue600;
  static const Color surface = Colors.white;
  static const Color surfaceHighlight = _slate100;
}
