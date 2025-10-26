/// Language Service
///
/// Manages application locale with persistence
/// Following best practices from Google, Apple, and Microsoft
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in the application
enum AppLanguage {
  english('en', 'English', 'EN'),
  russian('ru', 'Русский', 'RU'),
  chinese('zh', '中文', 'ZH');

  const AppLanguage(this.code, this.nativeName, this.shortCode);

  final String code;
  final String nativeName;
  final String shortCode;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Service for managing application locale
///
/// Best practices implemented:
/// - Persistent storage of user preference
/// - System locale detection
/// - Reactive updates via ChangeNotifier
/// - Fallback to system locale
/// - Type-safe language selection
class LanguageService extends ChangeNotifier {
  static const String _localeKey = 'app_locale';

  final SharedPreferences _prefs;
  Locale? _currentLocale;

  LanguageService(this._prefs) {
    _loadSavedLocale();
  }

  /// Currently selected locale
  /// Returns null if system default should be used
  Locale? get currentLocale => _currentLocale;

  /// Currently selected language
  AppLanguage get currentLanguage {
    if (_currentLocale == null) {
      return AppLanguage.english; // Default fallback
    }
    return AppLanguage.fromCode(_currentLocale!.languageCode);
  }

  /// List of supported locales for MaterialApp
  static List<Locale> get supportedLocales => AppLanguage.values
      .map((lang) => lang.locale)
      .toList();

  /// Check if a locale is supported
  static bool isSupported(Locale locale) {
    return AppLanguage.values.any(
      (lang) => lang.code == locale.languageCode,
    );
  }

  /// Load saved locale from persistent storage
  Future<void> _loadSavedLocale() async {
    final savedCode = _prefs.getString(_localeKey);
    if (savedCode != null) {
      _currentLocale = Locale(savedCode);
      notifyListeners();
    }
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
