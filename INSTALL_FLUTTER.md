# Установка Flutter - Быстрая Инструкция

## ⚡ Автоматическая Установка (Рекомендуется)

### Шаг 1: Запустите PowerShell скрипт

1. **Откройте PowerShell** (от имени администратора):
   - Нажмите `Win + X`
   - Выберите "Windows PowerShell (Администратор)"

2. **Разрешите выполнение скриптов** (однократно):
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
   Нажмите `Y` для подтверждения

3. **Перейдите в папку проекта**:
   ```powershell
   cd "C:\Users\goldb\OneDrive\Рабочий стол\Projects\IOT_App"
   ```

4. **Запустите скрипт установки**:
   ```powershell
   .\install_flutter.ps1
   ```

5. **Дождитесь завершения** (5-10 минут)
   - Скачивание ~700 MB
   - Распаковка
   - Настройка PATH
   - Проверка установки

### Шаг 2: Перезапустите терминал

Закройте и откройте PowerShell заново, чтобы PATH обновился.

### Шаг 3: Проверьте установку

```powershell
flutter --version
```

Если видите версию Flutter - установка прошла успешно! ✅

---

## 📱 Ручная Установка (Альтернатива)

Если автоматический скрипт не сработал:

### 1. Скачайте Flutter

Перейдите на: https://docs.flutter.dev/get-started/install/windows

Или скачайте напрямую:
```
https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip
```

### 2. Распакуйте

Распакуйте ZIP в: `C:\src\flutter`

(Убедитесь, что путь: `C:\src\flutter\bin\flutter.bat`)

### 3. Добавьте в PATH

1. Откройте "Изменение переменных среды системы"
   - Нажмите `Win + R`
   - Введите: `sysdm.cpl`
   - Вкладка "Дополнительно" → "Переменные среды"

2. В разделе "Переменные пользователя":
   - Найдите `Path`
   - Нажмите "Изменить"
   - Нажмите "Создать"
   - Добавьте: `C:\src\flutter\bin`
   - Нажмите "ОК" везде

3. Перезапустите терминал

### 4. Проверьте установку

```powershell
flutter doctor
```

---

## 🚀 После Установки Flutter

### Установите зависимости проекта:

```powershell
cd "C:\Users\goldb\OneDrive\Рабочий стол\Projects\IOT_App"
flutter pub get
```

### Запустите приложение:

```powershell
flutter run
```

Или нажмите `F5` в VS Code!

---

## 🔧 Дополнительные Зависимости (Опционально)

### Для Android разработки:

1. **Android Studio**: https://developer.android.com/studio
2. После установки запустите:
   ```
   flutter doctor --android-licenses
   ```

### Для Desktop разработки:

**Windows:**
- Visual Studio 2022: https://visualstudio.microsoft.com/downloads/
- Выберите "Desktop development with C++"

---

## ❓ Решение Проблем

### Проблема: "flutter: command not found"

**Решение:**
1. Убедитесь, что Flutter добавлен в PATH
2. Перезапустите терминал
3. Проверьте: `echo $env:Path` должен содержать путь к Flutter

### Проблема: "Execution policy error"

**Решение:**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Проблема: Скачивание идет медленно

**Решение:**
1. Используйте менеджер загрузок (IDM, FDM)
2. Или скачайте вручную по ссылке выше

### Проблема: "Unable to find git"

**Решение:**
Установите Git: https://git-scm.com/download/win

---

## ✅ Проверка Готовности

После установки запустите:

```powershell
flutter doctor -v
```

Идеальный результат:
```
[✓] Flutter (Channel stable, 3.24.5)
[✓] Windows Version
[✓] VS Code
```

Для запуска нашего проекта достаточно:
- ✓ Flutter SDK
- ✓ Windows Version

Android Studio и VS Code опциональны!

---

## 🎯 Быстрый Старт После Установки

```powershell
# 1. Перейдите в проект
cd "C:\Users\goldb\OneDrive\Рабочий стол\Projects\IOT_App"

# 2. Установите зависимости
flutter pub get

# 3. Запустите приложение
flutter run -d windows
```

**Приложение запустится на Windows!** 🎉

---

## 📞 Если Ничего Не Помогло

1. Прочитайте официальную документацию:
   https://docs.flutter.dev/get-started/install/windows

2. Убедитесь в требованиях:
   - Windows 10/11 (64-bit)
   - Минимум 2.5 GB свободного места
   - PowerShell 5.0 или выше

3. Перезагрузите компьютер после установки

---

**Удачи! После установки Flutter приложение запустится за 2 минуты!** 🚀
