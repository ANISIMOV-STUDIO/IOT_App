/// Сервис управления языком приложения
///
/// Управляет локалью с сохранением в хранилище.
/// Реализует паттерны Strategy и Observer.
///
/// Возможности:
/// - Сохранение выбора через SharedPreferences
/// - Определение системной локали с fallback
/// - Реактивные обновления через ChangeNotifier
/// - Легкое добавление новых языков
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Поддерживаемые языки приложения.
///
/// Для добавления нового языка:
/// 1. Добавить значение enum с code, nativeName, shortCode, flag
/// 2. Создать соответствующий .arb файл в lib/l10n/
/// 3. Запустить `flutter gen-l10n` для генерации
enum AppLanguage {
  russian('ru', 'Русский', 'RU', '🇷🇺'),
  english('en', 'English', 'EN', '🇬🇧');

  const AppLanguage(this.code, this.nativeName, this.shortCode, this.flag);

  /// Код языка ISO 639-1
  final String code;

  /// Название языка на родном языке
  final String nativeName;

  /// Короткий код для компактного отображения
  final String shortCode;

  /// Эмодзи флага для визуальной идентификации
  final String flag;

  /// Получить Locale для MaterialApp
  Locale get locale => Locale(code);

  /// Найти язык по коду, возвращает null если не найден
  static AppLanguage? fromCode(String? code) {
    if (code == null) {
      return null;
    }
    for (final lang in AppLanguage.values) {
      if (lang.code == code) {
        return lang;
      }
    }
    return null;
  }

  /// Получить список всех доступных языков
  static List<AppLanguage> get all => AppLanguage.values.toList();
}

/// Сервис управления локалью приложения.
///
/// Observer Pattern - реактивные обновления UI через ChangeNotifier.
/// Strategy Pattern - стратегия выбора локали (явный выбор или системный).
class LanguageService extends ChangeNotifier { // null = использовать системный

  LanguageService(this._prefs) {
    _loadSavedLocale();
  }
  static const String _localeKey = 'app_locale';

  final SharedPreferences _prefs;
  Locale? _currentLocale;

  /// Инициализация по умолчанию - ничего не делаем, используем системный
  Future<void> initializeDefaults() async {
    // Если в настройках пусто, _currentLocale = null, т.е. системный язык
  }

  // ============== Геттеры ==============

  /// Текущая локаль для MaterialApp.
  /// null = использовать системную локаль.
  Locale? get currentLocale => _currentLocale;

  /// Выбран ли язык явно (или используется системный)
  bool get isExplicitlySet => _currentLocale != null;

  /// Текущий активный язык (с учетом явного выбора или системного)
  AppLanguage get currentLanguage {
    if (_currentLocale != null) {
      return AppLanguage.fromCode(_currentLocale!.languageCode) ??
          AppLanguage.russian;
    }
    return _resolveSystemLanguage();
  }

  /// Системный язык устройства
  AppLanguage get systemLanguage => _resolveSystemLanguage();

  /// Список всех доступных языков
  List<AppLanguage> get availableLanguages => AppLanguage.all;

  /// Список поддерживаемых локалей для MaterialApp
  static List<Locale> get supportedLocales =>
      AppLanguage.values.map((lang) => lang.locale).toList();

  // ============== Сеттеры ==============

  /// Установить язык явно.
  /// Передать null для использования системного.
  Future<void> setLanguage(AppLanguage? language) async {
    if (language == null) {
      await _prefs.remove(_localeKey);
      _currentLocale = null;
    } else {
      await _prefs.setString(_localeKey, language.code);
      _currentLocale = language.locale;
    }
    notifyListeners();
  }

  /// Установить локаль по коду языка (для обратной совместимости)
  Future<void> setLocale(String languageCode) async {
    final language = AppLanguage.fromCode(languageCode);
    await setLanguage(language);
  }

  /// Сбросить на системный язык
  Future<void> useSystemDefault() async {
    await setLanguage(null);
  }

  // ============== Приватные методы ==============

  /// Загрузить сохраненную локаль из хранилища
  void _loadSavedLocale() {
    final savedCode = _prefs.getString(_localeKey);
    if (savedCode != null) {
      _currentLocale = Locale(savedCode);
    } else {
      _currentLocale = null;
    }
    notifyListeners();
  }

  /// Определить системный язык с fallback
  AppLanguage _resolveSystemLanguage() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final matched = AppLanguage.fromCode(systemLocale.languageCode);
    // Fallback на русский если системный язык не поддерживается
    return matched ?? AppLanguage.russian;
  }
}
