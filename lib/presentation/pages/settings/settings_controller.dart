/// Settings Controller
///
/// Business logic handler for Settings Screen
/// Single Responsibility: Manages settings state and persistence
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/language_service.dart';

class SettingsController extends ChangeNotifier {
  final VoidCallback onSettingChanged;
  final SharedPreferences _prefs;
  final LanguageService _languageService;

  // Settings state
  bool _darkMode = true;
  bool _celsius = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  int _selectedSection = 0; // For desktop navigation

  SettingsController({
    required this.onSettingChanged,
    required SharedPreferences prefs,
    required LanguageService languageService,
  })  : _prefs = prefs,
        _languageService = languageService {
    loadSettings();
    // Listen to language service changes
    _languageService.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    notifyListeners();
  }

  // Getters
  bool get darkMode => _darkMode;
  bool get celsius => _celsius;
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  AppLanguage get currentLanguage => _languageService.currentLanguage;
  int get selectedSection => _selectedSection;

  // Setters with notification
  void setDarkMode(bool value) {
    _darkMode = value;
    onSettingChanged();
    _persistSetting('darkMode', value);
  }

  void setCelsius(bool value) {
    _celsius = value;
    onSettingChanged();
    _persistSetting('celsius', value);
  }

  void setPushNotifications(bool value) {
    _pushNotifications = value;
    onSettingChanged();
    _persistSetting('pushNotifications', value);
  }

  void setEmailNotifications(bool value) {
    _emailNotifications = value;
    onSettingChanged();
    _persistSetting('emailNotifications', value);
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _languageService.setLanguage(language);
    onSettingChanged();
  }

  void selectSection(int index) {
    _selectedSection = index;
    onSettingChanged();
  }

  /// Load settings from persistent storage
  Future<void> loadSettings() async {
    _darkMode = _prefs.getBool('darkMode') ?? true;
    _celsius = _prefs.getBool('celsius') ?? true;
    _pushNotifications = _prefs.getBool('pushNotifications') ?? true;
    _emailNotifications = _prefs.getBool('emailNotifications') ?? false;
    notifyListeners();
  }

  /// Save all settings to persistent storage
  Future<void> saveSettings() async {
    await Future.wait([
      _prefs.setBool('darkMode', _darkMode),
      _prefs.setBool('celsius', _celsius),
      _prefs.setBool('pushNotifications', _pushNotifications),
      _prefs.setBool('emailNotifications', _emailNotifications),
    ]);
  }

  /// Persist individual setting
  void _persistSetting(String key, dynamic value) {
    if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    saveSettings();
    super.dispose();
  }
}
