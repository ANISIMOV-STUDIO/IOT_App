# Локализация BREEZ Home

## Быстрый старт

### Поддерживаемые языки

- 🇷🇺 **Русский** (по умолчанию)
- 🇬🇧 **English**

### Структура файлов

```
lib/
├── l10n/                    # ARB файлы переводов
│   ├── app_ru.arb          # Русский (шаблон) - 308 ключей
│   └── app_en.arb          # Английский - 308 ключей
│
├── generated/l10n/          # Автогенерируемые файлы (НЕ РЕДАКТИРОВАТЬ!)
│   ├── app_localizations.dart
│   ├── app_localizations_ru.dart
│   └── app_localizations_en.dart
│
└── core/services/
    └── language_service.dart   # Сервис управления языком
```

## Использование в коде

### Получить текущий перевод

```dart
import 'package:hvac_control/generated/l10n/app_localizations.dart';

// В виджете:
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Text(l10n.appTitle); // "BREEZ Home"
  return Text(l10n.settings); // "Настройки" или "Settings"
}
```

### Переключить язык программно

```dart
import 'package:hvac_control/core/services/language_service.dart';
import 'package:hvac_control/core/di/injection_container.dart' as di;

// Получить сервис
final languageService = di.sl<LanguageService>();

// Переключить на английский
await languageService.setLanguage(AppLanguage.english);

// Переключить на русский
await languageService.setLanguage(AppLanguage.russian);

// Получить текущий язык
final current = languageService.currentLanguage;
print(current.nativeName); // "Русский" или "English"
print(current.code);       // "ru" или "en"
```

### Проверить доступные языки

```dart
// Все доступные языки
for (var lang in AppLanguage.values) {
  print('${lang.nativeName} (${lang.code})');
}
// Вывод:
// Русский (ru)
// English (en)

// Получить язык по коду
final russian = AppLanguage.fromCode('ru');
final english = AppLanguage.fromCode('en');
final unknown = AppLanguage.fromCode('xyz'); // вернет русский (fallback)
```

## Добавление новых переводов

### Шаг 1: Добавить ключ в ARB файлы

Откройте `lib/l10n/app_ru.arb` и добавьте:

```json
{
  "newFeature": "Новая функция",
  "@newFeature": {
    "description": "Label for new feature button"
  }
}
```

Откройте `lib/l10n/app_en.arb` и добавьте:

```json
{
  "newFeature": "New Feature",
  "@newFeature": {
    "description": "Label for new feature button"
  }
}
```

### Шаг 2: Регенерировать локализацию

```bash
flutter gen-l10n
```

### Шаг 3: Использовать в коде

```dart
Text(l10n.newFeature)
```

## Переводы с параметрами

### В ARB файле:

```json
{
  "greeting": "Привет, {name}!",
  "@greeting": {
    "description": "Greeting message",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

### В коде:

```dart
Text(l10n.greeting('Иван')) // "Привет, Иван!"
```

## Множественные формы (Plural)

### В ARB файле:

```json
{
  "itemCount": "{count, plural, =0{Нет элементов} =1{Один элемент} other{{count} элементов}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### В коде:

```dart
Text(l10n.itemCount(0))  // "Нет элементов"
Text(l10n.itemCount(1))  // "Один элемент"
Text(l10n.itemCount(5))  // "5 элементов"
```

## Валидация переводов

Запустите скрипт валидации:

```bash
python scripts/validate_localization.py
```

Проверяет:
- ✅ Синхронизацию ключей между RU и EN
- ✅ Отсутствие запрещенных языков (китайский, немецкий)
- ✅ Наличие метаданных для всех ключей

## Организация переводов

ARB файлы разделены на секции для удобства:

```json
{
  "@@_AUTHENTICATION": "=== Authentication ===",
  "login": "Войти",
  "register": "Регистрация",

  "@@_SETTINGS": "=== Settings Screen ===",
  "settings": "Настройки",
  "language": "Язык"
}
```

Секции (для справки):
- `@@_APPLICATION` - Метаданные приложения
- `@@_AUTHENTICATION` - Авторизация
- `@@_ONBOARDING` - Онбординг
- `@@_NAVIGATION` - Навигация
- `@@_SETTINGS` - Настройки
- `@@_DEVICE_MANAGEMENT` - Управление устройствами
- `@@_HVAC_CONTROL` - Управление HVAC
- `@@_ERRORS` - Сообщения об ошибках
- `@@_VALIDATION` - Валидация форм
- `@@_COMMON_ACTIONS` - Общие действия
- И другие...

## Настройка (l10n.yaml)

```yaml
arb-dir: lib/l10n
template-arb-file: app_ru.arb              # Русский - шаблон
output-localization-file: app_localizations.dart
output-dir: lib/generated/l10n
preferred-supported-locales: ["ru"]         # Русский по умолчанию
```

## Добавление нового языка

Если нужно добавить украинский:

### 1. Создайте `lib/l10n/app_uk.arb`

Скопируйте структуру из `app_ru.arb` и переведите все значения.

### 2. Обновите `language_service.dart`

```dart
enum AppLanguage {
  russian('ru', 'Русский', 'RU'),
  english('en', 'English', 'EN'),
  ukrainian('uk', 'Українська', 'UK'), // Добавить
}
```

### 3. Регенерируйте

```bash
flutter gen-l10n
```

## Отладка

### Язык не переключается

1. Проверьте, что `MaterialApp` обернут в `ListenableBuilder`:

```dart
ListenableBuilder(
  listenable: di.sl<LanguageService>(),
  builder: (context, child) {
    return MaterialApp.router(
      locale: di.sl<LanguageService>().currentLocale,
      // ...
    );
  },
)
```

2. Проверьте логи:

```dart
final service = di.sl<LanguageService>();
print('Current locale: ${service.currentLocale}');
print('Current language: ${service.currentLanguage}');
```

### Ключ не найден

Ошибка: `The getter 'someKey' isn't defined for the type 'AppLocalizationsRu'`

**Решение:**
1. Добавьте ключ в `app_ru.arb` и `app_en.arb`
2. Запустите `flutter gen-l10n`
3. Перезапустите приложение

### Отображается английский вместо русского

**Причина:** `currentLocale` возвращает `null` или `'en'`

**Решение:**
```dart
// Принудительно установить русский
await di.sl<LanguageService>().setLanguage(AppLanguage.russian);
```

## Best Practices

### ✅ Правильно

```dart
// Использовать l10n для всех текстов
Text(l10n.appTitle)

// Группировать связанные переводы
l10n.emailRequired
l10n.emailInvalid

// Добавлять метаданные
"@emailRequired": {
  "description": "Email validation error message"
}
```

### ❌ Неправильно

```dart
// Хардкод текста
Text('BREEZ Home')

// Использовать строки вместо enum
setLanguage('Russian') // Используйте AppLanguage.russian

// Пропускать метаданные
{
  "newKey": "Новый ключ"
  // Нет @newKey
}
```

## Статистика

- **Поддерживаемых языков:** 2 (русский, английский)
- **Переведенных ключей:** 308
- **Общих записей в ARB:** 648 (включая метаданные)
- **Секций организации:** 29

## Полезные ссылки

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Intl package](https://pub.dev/packages/intl)

## Файлы документации

- `LOCALIZATION_UPDATE.md` - Подробное описание изменений
- `MIGRATION_GUIDE.md` - Гайд по миграции с предыдущей версии
- `LOCALIZATION_README.md` - Этот файл

---

**Последнее обновление:** 2025-11-09
**Версия:** 2.0.0
