/// Settings Controller
///
/// Business logic handler for Settings Screen
/// Single Responsibility: Manages settings state and persistence
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  final VoidCallback onSettingChanged;
  final SharedPreferences _prefs;

  // Settings state
  bool _darkMode = true;
  bool _celsius = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _language = 'Russian'; // Default language
  int _selectedSection = 0; // For desktop navigation

  SettingsController({
    required this.onSettingChanged,
    required SharedPreferences prefs,
  }) : _prefs = prefs {
    loadSettings();
  }

  // Getters
  bool get darkMode => _darkMode;
  bool get celsius => _celsius;
  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  String get language => _language;
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

  void setLanguage(String value) {
    _language = value;
    onSettingChanged();
    _persistSetting('language', value);
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
    _language = _prefs.getString('language') ?? 'Russian';
    notifyListeners();
  }

  /// Save all settings to persistent storage
  Future<void> saveSettings() async {
    await Future.wait([
      _prefs.setBool('darkMode', _darkMode),
      _prefs.setBool('celsius', _celsius),
      _prefs.setBool('pushNotifications', _pushNotifications),
      _prefs.setBool('emailNotifications', _emailNotifications),
      _prefs.setString('language', _language),
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
    saveSettings();
    super.dispose();
  }
}
