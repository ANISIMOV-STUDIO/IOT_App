/// Language Service
///
/// Manages application locale with persistence
/// Following best practices from Google, Apple, and Microsoft
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

/// Supported languages in the application
enum AppLanguage {
  russian('ru', 'Русский', 'RU'),
  english('en', 'English', 'EN');

  const AppLanguage(this.code, this.nativeName, this.shortCode);

  final String code;
  final String nativeName;
  final String shortCode;

  Locale get locale => Locale(code);

  static AppLanguage? fromCode(String? code) {
    if (code == null) return null;
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english, // Fallback to English if code not found
    );
  }
}

/// Service for managing application locale
class LanguageService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';

  final SharedPreferences _prefs;
  Locale? _currentLocale; // If null, use system

  LanguageService(this._prefs) {
    _loadSavedLocale();
  }

  /// Initialize default - do nothing, let system default take over
  Future<void> initializeDefaults() async {
    // No-op: Do not force any language.
    // If prefs are empty, _currentLocale is null, which means use system.
  }

  /// Currently selected locale to be used by MaterialApp
  /// Returns null if system default should be used (MaterialApp handles null by using device locale)
  Locale? get currentLocale => _currentLocale;

  /// Currently active language (resolved)
  AppLanguage get currentLanguage {
    if (_currentLocale != null) {
      return AppLanguage.fromCode(_currentLocale!.languageCode) ?? AppLanguage.english;
    }
    
    // Resolve system locale
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    // Check if system locale is supported
    try {
      return AppLanguage.values.firstWhere(
        (lang) => lang.code == systemLocale.languageCode,
      );
    } catch (_) {
      // If system locale is not Russian or English, default to English (standard practice)
      return AppLanguage.english;
    }
  }

  /// List of supported locales for MaterialApp
  static List<Locale> get supportedLocales =>
      AppLanguage.values.map((lang) => lang.locale).toList();

  /// Load saved locale from persistent storage
  void _loadSavedLocale() {
    final savedCode = _prefs.getString(_localeKey);
    if (savedCode != null) {
      _currentLocale = Locale(savedCode);
    } else {
      _currentLocale = null; // Use system
    }
    notifyListeners();
  }

  /// Set locale and persist to storage
  ///
  /// If [language] is null, will use system default
  Future<void> setLanguage(AppLanguage? language) async {
    if (language == null) {
      // Use system default
      await _prefs.remove(_localeKey);
      _currentLocale = null;
    } else {
      // Set specific language
      await _prefs.setString(_localeKey, language.code);
      _currentLocale = language.locale;
    }
    notifyListeners();
  }

  /// Set locale by code (for backward compatibility)
  Future<void> setLocale(String languageCode) async {
    final language = AppLanguage.fromCode(languageCode);
    await setLanguage(language);
  }

  /// Reset to system default
  Future<void> useSystemDefault() async {
    await setLanguage(null);
  }
}
