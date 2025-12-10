import 'package:flutter/material.dart';
import 'app_strings.dart';
import 'ru_strings.dart';
import 'en_strings.dart';

export 'app_strings.dart';

/// Поддерживаемые языки
enum AppLocale {
  ru('ru', 'Русский'),
  en('en', 'English');

  final String code;
  final String name;
  const AppLocale(this.code, this.name);

  static AppLocale fromCode(String code) {
    return AppLocale.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLocale.ru, // Русский по умолчанию
    );
  }
}

/// Провайдер локализации через InheritedWidget
class L10n extends InheritedWidget {
  final AppStrings strings;
  final AppLocale locale;
  final ValueChanged<AppLocale>? onLocaleChanged;

  const L10n({
    super.key,
    required this.strings,
    required this.locale,
    this.onLocaleChanged,
    required super.child,
  });

  /// Получить строки локализации из контекста
  static AppStrings of(BuildContext context) {
    final l10n = context.dependOnInheritedWidgetOfExactType<L10n>();
    return l10n?.strings ?? const RuStrings();
  }

  /// Получить текущую локаль
  static AppLocale localeOf(BuildContext context) {
    final l10n = context.dependOnInheritedWidgetOfExactType<L10n>();
    return l10n?.locale ?? AppLocale.ru;
  }

  /// Сменить язык
  static void setLocale(BuildContext context, AppLocale locale) {
    final l10n = context.dependOnInheritedWidgetOfExactType<L10n>();
    l10n?.onLocaleChanged?.call(locale);
  }

  /// Получить строки по локали
  static AppStrings getStrings(AppLocale locale) {
    switch (locale) {
      case AppLocale.ru:
        return const RuStrings();
      case AppLocale.en:
        return const EnStrings();
    }
  }

  @override
  bool updateShouldNotify(L10n oldWidget) => locale != oldWidget.locale;
}

/// Виджет-обёртка с поддержкой смены языка
class L10nProvider extends StatefulWidget {
  final Widget child;
  final AppLocale initialLocale;

  const L10nProvider({
    super.key,
    required this.child,
    this.initialLocale = AppLocale.ru, // Русский по умолчанию!
  });

  @override
  State<L10nProvider> createState() => _L10nProviderState();
}

class _L10nProviderState extends State<L10nProvider> {
  late AppLocale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void _setLocale(AppLocale locale) {
    if (_locale != locale) {
      setState(() => _locale = locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return L10n(
      strings: L10n.getStrings(_locale),
      locale: _locale,
      onLocaleChanged: _setLocale,
      child: widget.child,
    );
  }
}

/// Extension для удобного доступа к строкам
extension L10nExtension on BuildContext {
  AppStrings get l10n => L10n.of(this);
  AppLocale get locale => L10n.localeOf(this);
  void setLocale(AppLocale locale) => L10n.setLocale(this, locale);
}
