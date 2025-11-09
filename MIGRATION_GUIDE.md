# Миграционный гайд: Обновление локализации

## Для разработчиков, которые уже работали с проектом

### Что изменилось?

#### 🔴 Критические изменения (Breaking Changes)

1. **Удалены языки:**
   - ❌ Китайский (`zh`) - полностью удален
   - ❌ Немецкий (`de`) - упоминания удалены

2. **Изменения в API:**
   ```dart
   // СТАРЫЙ КОД (не работает):
   LanguageSection(
     selectedLanguage: 'Russian', // String
     onLanguageChanged: (String language) { ... }
   )

   // НОВЫЙ КОД (используйте это):
   LanguageSection(
     selectedLanguage: AppLanguage.russian, // Enum
     onLanguageChanged: (AppLanguage language) { ... }
   )
   ```

3. **SettingsController:**
   ```dart
   // СТАРЫЙ КОД (удалено):
   controller.language // String
   controller.setLanguage('Russian')

   // НОВЫЙ КОД:
   controller.currentLanguage // AppLanguage enum
   controller.setLanguage(AppLanguage.russian)
   ```

### Шаги миграции

#### Шаг 1: Обновите код, если вы используете LanguageSection

**Было:**
```dart
LanguageSection(
  selectedLanguage: 'Русский',
  onLanguageChanged: (language) {
    // language - это String
    print('Selected: $language'); // 'Русский'
  },
)
```

**Стало:**
```dart
LanguageSection(
  selectedLanguage: AppLanguage.russian,
  onLanguageChanged: (language) {
    // language - это AppLanguage enum
    print('Selected: ${language.nativeName}'); // 'Русский'
    print('Code: ${language.code}'); // 'ru'
  },
)
```

#### Шаг 2: Обновите прямые вызовы LanguageService

**Было:**
```dart
import 'package:shared_preferences/shared_preferences.dart';

// Прямая работа с SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString('language', 'Russian');
```

**Стало:**
```dart
import 'package:hvac_control/core/services/language_service.dart';
import 'package:hvac_control/core/di/injection_container.dart' as di;

// Используйте LanguageService из DI
final languageService = di.sl<LanguageService>();
await languageService.setLanguage(AppLanguage.russian);
```

#### Шаг 3: Удалите ссылки на удаленные языки

Если в вашем коде есть:

```dart
// УДАЛИТЕ ЭТО:
if (language == 'Chinese') { ... }
if (locale.languageCode == 'zh') { ... }
if (language == l10n.german) { ... }
```

#### Шаг 4: Регенерируйте локализацию

```bash
# Удалите старые сгенерированные файлы
rm -rf lib/generated/l10n/

# Регенерируйте с новыми настройками
flutter gen-l10n

# Или полная пересборка
flutter clean
flutter pub get
flutter gen-l10n
```

#### Шаг 5: Обновите тесты

**Было:**
```dart
test('should change language to Russian', () {
  controller.setLanguage('Russian');
  expect(controller.language, 'Russian');
});
```

**Стало:**
```dart
test('should change language to Russian', () async {
  await controller.setLanguage(AppLanguage.russian);
  expect(controller.currentLanguage, AppLanguage.russian);
});
```

### Совместимость со старыми данными

#### SharedPreferences Migration

Если у пользователей сохранен старый формат языка:

```dart
// Старый формат (String):
SharedPreferences: 'language' = 'Russian'

// Новый формат (String, но код языка):
SharedPreferences: 'app_locale' = 'ru'
```

**Автоматическая миграция:** ✅ Уже реализована в `LanguageService.initializeDefaults()`

При первом запуске после обновления:
1. Если ключ `app_locale` не существует → устанавливается русский
2. Старый ключ `language` игнорируется

### Список доступных языков

```dart
// Доступные языки (enum AppLanguage):
AppLanguage.russian  // code: 'ru', nativeName: 'Русский'
AppLanguage.english  // code: 'en', nativeName: 'English'

// Получить все языки:
AppLanguage.values // [AppLanguage.russian, AppLanguage.english]

// Получить по коду:
AppLanguage.fromCode('ru')  // AppLanguage.russian
AppLanguage.fromCode('en')  // AppLanguage.english
AppLanguage.fromCode('xyz') // AppLanguage.russian (fallback)
```

### Часто задаваемые вопросы (FAQ)

#### Q: Почему удалили китайский и немецкий?
**A:** По требованию проекта. Оставлены только русский (по умолчанию) и английский.

#### Q: Можно ли вернуть китайский?
**A:** Да, но потребуется:
1. Создать `app_zh.arb` с переводами всех 309 ключей
2. Добавить `AppLanguage.chinese('zh', '中文', 'ZH')` в enum
3. Обновить `l10n.yaml`
4. Запустить `flutter gen-l10n`

#### Q: Как добавить новый язык (например, украинский)?
**A:**
```dart
// 1. В language_service.dart добавьте в enum:
enum AppLanguage {
  russian('ru', 'Русский', 'RU'),
  english('en', 'English', 'EN'),
  ukrainian('uk', 'Українська', 'UK'), // Добавить
}

// 2. Создайте lib/l10n/app_uk.arb с переводами
// 3. Запустите flutter gen-l10n
```

#### Q: Язык не переключается после обновления
**A:** Проверьте:
1. Запустили ли `flutter gen-l10n`?
2. Есть ли `ListenableBuilder` в main.dart, который слушает `LanguageService`?
3. Вызываете ли `await controller.setLanguage()`?

#### Q: Ошибка "german is not defined"
**A:** Сгенерированные файлы устарели. Решение:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

#### Q: Что произойдет с пользователями, у которых был выбран китайский?
**A:** При первом запуске после обновления:
- Если в SharedPreferences был `zh` → сбросится на `ru` (русский по умолчанию)
- Пользователь может вручную переключить на английский в настройках

### Проверка миграции

Чеклист для проверки успешной миграции:

- [ ] Проект компилируется без ошибок
- [ ] `flutter gen-l10n` выполняется успешно
- [ ] Приложение запускается на русском языке
- [ ] В настройках доступны только Русский и English
- [ ] Переключение языка работает корректно
- [ ] Весь UI переводится при переключении
- [ ] Нет упоминаний китайского/немецкого в коде
- [ ] Тесты проходят успешно

### Откат изменений (если нужно)

Если миграция вызвала проблемы:

```bash
# Откатить изменения git
git checkout feature/ui-kit-migration

# Или откатить конкретные файлы
git checkout HEAD -- lib/core/services/language_service.dart
git checkout HEAD -- lib/presentation/pages/settings/settings_controller.dart
# и т.д.
```

### Дополнительные ресурсы

- `LOCALIZATION_UPDATE.md` - полная документация изменений
- `lib/core/services/language_service.dart` - исходный код сервиса
- `lib/l10n/` - ARB файлы с переводами

### Получить помощь

Если возникли проблемы после миграции:

1. Проверьте логи: `flutter run --verbose`
2. Убедитесь, что выполнены все шаги миграции
3. Проверьте, что `flutter gen-l10n` выполнен успешно
4. Создайте issue с описанием проблемы

---

**Последнее обновление:** 2025-11-09
**Версия миграции:** 1.0.0 → 2.0.0 (локализация)
