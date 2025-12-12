import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];

  /// Application title
  ///
  /// In ru, this message translates to:
  /// **'BREEZ Home'**
  String get appTitle;

  /// Application tagline
  ///
  /// In ru, this message translates to:
  /// **'Умное управление климатом'**
  String get smartClimateManagement;

  /// Login button text
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get login;

  /// Register button text
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get register;

  /// Login screen subtitle
  ///
  /// In ru, this message translates to:
  /// **'С возвращением! Войдите, чтобы продолжить'**
  String get loginSubtitle;

  /// Register screen subtitle
  ///
  /// In ru, this message translates to:
  /// **'Создайте аккаунт, чтобы начать'**
  String get registerSubtitle;

  /// Email field label
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get password;

  /// Confirm password field label
  ///
  /// In ru, this message translates to:
  /// **'Подтвердите пароль'**
  String get confirmPassword;

  /// Name field label
  ///
  /// In ru, this message translates to:
  /// **'Полное имя'**
  String get fullName;

  /// Welcome back message
  ///
  /// In ru, this message translates to:
  /// **'С возвращением'**
  String get welcomeBack;

  /// Create account title
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get createAccount;

  /// Sign in subtitle
  ///
  /// In ru, this message translates to:
  /// **'Войдите в свой аккаунт'**
  String get signInToAccount;

  /// Sign up subtitle
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрируйтесь для нового аккаунта'**
  String get signUpForAccount;

  /// Skip authentication button
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get skipForNow;

  /// Skip authentication button alternative
  ///
  /// In ru, this message translates to:
  /// **'Продолжить без регистрации'**
  String get skipAuth;

  /// Remember me checkbox
  ///
  /// In ru, this message translates to:
  /// **'Запомнить меня'**
  String get rememberMe;

  /// Terms and conditions link
  ///
  /// In ru, this message translates to:
  /// **'Условия и положения'**
  String get termsAndConditions;

  /// Guest user name
  ///
  /// In ru, this message translates to:
  /// **'Гость'**
  String get guestUser;

  /// Registration coming soon message
  ///
  /// In ru, this message translates to:
  /// **'Функция регистрации скоро будет доступна'**
  String get registrationComingSoon;

  /// Show password tooltip
  ///
  /// In ru, this message translates to:
  /// **'Показать пароль'**
  String get showPassword;

  /// Hide password tooltip
  ///
  /// In ru, this message translates to:
  /// **'Скрыть пароль'**
  String get hidePassword;

  /// Skip button
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get skip;

  /// Onboarding welcome title
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать в\nBREEZ Home'**
  String get welcomeToBreezHome;

  /// Onboarding welcome subtitle
  ///
  /// In ru, this message translates to:
  /// **'Умное управление климатом\nвашего дома под рукой'**
  String get smartHomeClimateControl;

  /// Swipe instruction
  ///
  /// In ru, this message translates to:
  /// **'Свайпните для продолжения'**
  String get swipeToContinue;

  /// Onboarding control title
  ///
  /// In ru, this message translates to:
  /// **'Управляйте\nустройствами'**
  String get controlYourDevices;

  /// Onboarding control subtitle
  ///
  /// In ru, this message translates to:
  /// **'Управляйте всеми системами HVAC\nиз любого места в любое время'**
  String get manageHvacSystems;

  /// Remote control feature
  ///
  /// In ru, this message translates to:
  /// **'Включение/выключение удаленно'**
  String get turnOnOffRemotely;

  /// Onboarding final title
  ///
  /// In ru, this message translates to:
  /// **'Готовы\nначать?'**
  String get readyToGetStarted;

  /// Onboarding final subtitle
  ///
  /// In ru, this message translates to:
  /// **'Начните управлять климатом вашего дома\nлегко и эффективно'**
  String get startControllingClimate;

  /// Get started button
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get getStarted;

  /// Terms and privacy agreement text
  ///
  /// In ru, this message translates to:
  /// **'Продолжая, вы соглашаетесь с нашими\nУсловиями обслуживания и Политикой конфиденциальности'**
  String get termsPrivacyAgreement;

  /// Loading screen text
  ///
  /// In ru, this message translates to:
  /// **'Загрузка BREEZ Home'**
  String get loadingBreezHome;

  /// Home tab label
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get home;

  /// Settings tab label
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// Back button
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// Next button
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get next;

  /// Previous button
  ///
  /// In ru, this message translates to:
  /// **'Предыдущий'**
  String get previous;

  /// Navigate back label
  ///
  /// In ru, this message translates to:
  /// **'Вернуться назад'**
  String get navigateBack;

  /// Settings screen title (Russian: Настройки)
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settingsTitle;

  /// Appearance section title (Russian: Внешний вид)
  ///
  /// In ru, this message translates to:
  /// **'Внешний вид'**
  String get appearance;

  /// Dark theme option (Russian: Темная тема)
  ///
  /// In ru, this message translates to:
  /// **'Темная тема'**
  String get darkTheme;

  /// Dark theme description (Russian: Использовать темную цветовую схему)
  ///
  /// In ru, this message translates to:
  /// **'Использовать темную цветовую схему'**
  String get useDarkColorScheme;

  /// Theme change message (Russian: Смена темы будет доступна в следующей версии)
  ///
  /// In ru, this message translates to:
  /// **'Смена темы будет доступна в следующей версии'**
  String get themeChangeNextVersion;

  /// Units section title (Russian: Единицы измерения)
  ///
  /// In ru, this message translates to:
  /// **'Единицы измерения'**
  String get units;

  /// Temperature units label (Russian: Температура)
  ///
  /// In ru, this message translates to:
  /// **'Температура'**
  String get temperatureUnits;

  /// Celsius option (Russian: Цельсий (°C))
  ///
  /// In ru, this message translates to:
  /// **'Цельсий (°C)'**
  String get celsius;

  /// Fahrenheit option (Russian: Фаренгейт (°F))
  ///
  /// In ru, this message translates to:
  /// **'Фаренгейт (°F)'**
  String get fahrenheit;

  /// Units changed message
  ///
  /// In ru, this message translates to:
  /// **'Единицы изменены на {unit}'**
  String unitsChangedTo(String unit);

  /// Notifications section (Russian: Уведомления)
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notifications;

  /// Push notifications option (Russian: Push-уведомления)
  ///
  /// In ru, this message translates to:
  /// **'Push-уведомления'**
  String get pushNotifications;

  /// Push notifications description (Russian: Получать мгновенные уведомления)
  ///
  /// In ru, this message translates to:
  /// **'Получать мгновенные уведомления'**
  String get receiveInstantNotifications;

  /// Email notifications option (Russian: Email-уведомления)
  ///
  /// In ru, this message translates to:
  /// **'Email-уведомления'**
  String get emailNotifications;

  /// Email notifications description (Russian: Получать отчеты на email)
  ///
  /// In ru, this message translates to:
  /// **'Получать отчеты на email'**
  String get receiveEmailReports;

  /// Notifications state message
  ///
  /// In ru, this message translates to:
  /// **'{type}-уведомления {state}'**
  String notificationsState(String type, String state);

  /// Language section (Russian: Язык)
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// Russian language option
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russian;

  /// English language option
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get english;

  /// Language changed message
  ///
  /// In ru, this message translates to:
  /// **'Язык изменен на {language}'**
  String languageChangedTo(String language);

  /// About section (Russian: О приложении)
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get about;

  /// Version label (Russian: Версия)
  ///
  /// In ru, this message translates to:
  /// **'Версия'**
  String get version;

  /// Developer label (Russian: Разработчик)
  ///
  /// In ru, this message translates to:
  /// **'Разработчик'**
  String get developer;

  /// License label (Russian: Лицензия)
  ///
  /// In ru, this message translates to:
  /// **'Лицензия'**
  String get license;

  /// Check updates button (Russian: Проверить обновления)
  ///
  /// In ru, this message translates to:
  /// **'Проверить обновления'**
  String get checkUpdates;

  /// Checking updates message (Russian: Проверка обновлений...)
  ///
  /// In ru, this message translates to:
  /// **'Проверка обновлений...'**
  String get checkingUpdates;

  /// Device management screen title
  ///
  /// In ru, this message translates to:
  /// **'Управление устройствами'**
  String get deviceManagement;

  /// Search title
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// Scan for devices button
  ///
  /// In ru, this message translates to:
  /// **'Сканировать устройства'**
  String get scanForDevices;

  /// Add device button
  ///
  /// In ru, this message translates to:
  /// **'Добавить устройство'**
  String get addDevice;

  /// Edit device dialog title
  ///
  /// In ru, this message translates to:
  /// **'Редактировать устройство'**
  String get editDevice;

  /// Remove device button
  ///
  /// In ru, this message translates to:
  /// **'Удалить устройство'**
  String get removeDevice;

  /// Device name label
  ///
  /// In ru, this message translates to:
  /// **'Название устройства'**
  String get deviceName;

  /// MAC address label
  ///
  /// In ru, this message translates to:
  /// **'MAC-адрес'**
  String get macAddress;

  /// Location label
  ///
  /// In ru, this message translates to:
  /// **'Расположение'**
  String get location;

  /// Device not found message
  ///
  /// In ru, this message translates to:
  /// **'Не нашли\nустройство?'**
  String get notFoundDevice;

  /// Select device manually button
  ///
  /// In ru, this message translates to:
  /// **'Выбрать вручную'**
  String get selectManually;

  /// Device updated message
  ///
  /// In ru, this message translates to:
  /// **'Устройство обновлено'**
  String get deviceUpdated;

  /// Device added success message
  ///
  /// In ru, this message translates to:
  /// **'Устройство успешно добавлено'**
  String get deviceAdded;

  /// Device removed success message
  ///
  /// In ru, this message translates to:
  /// **'Устройство успешно удалено'**
  String get deviceRemoved;

  /// Scan QR code button
  ///
  /// In ru, this message translates to:
  /// **'Сканировать QR-код'**
  String get scanQrCode;

  /// Processing QR code message
  ///
  /// In ru, this message translates to:
  /// **'Обработка QR-кода...'**
  String get processingQrCode;

  /// Invalid QR code error
  ///
  /// In ru, this message translates to:
  /// **'Неверный QR-код'**
  String get invalidQrCode;

  /// Device detected from QR message
  ///
  /// In ru, this message translates to:
  /// **'Устройство обнаружено из QR-кода'**
  String get deviceDetectedFromQr;

  /// Manual MAC entry option
  ///
  /// In ru, this message translates to:
  /// **'Или введите MAC-адрес вручную'**
  String get enterMacManually;

  /// Invalid MAC format error
  ///
  /// In ru, this message translates to:
  /// **'Неверный формат MAC-адреса (например, AA:BB:CC:DD:EE:FF)'**
  String get invalidMacFormat;

  /// Device name validation error
  ///
  /// In ru, this message translates to:
  /// **'Название устройства должно содержать минимум 3 символа'**
  String get deviceNameMinLength;

  /// Adding in progress
  ///
  /// In ru, this message translates to:
  /// **'Добавление...'**
  String get adding;

  /// Pull to refresh hint
  ///
  /// In ru, this message translates to:
  /// **'Потяните для обновления'**
  String get pullToRefresh;

  /// Online status
  ///
  /// In ru, this message translates to:
  /// **'В сети'**
  String get online;

  /// Offline status
  ///
  /// In ru, this message translates to:
  /// **'Не в сети'**
  String get offline;

  /// Edit action
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get edit;

  /// Delete action
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// Confirm device removal
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите удалить {name}?'**
  String confirmRemoveDevice(String name);

  /// WiFi network display
  ///
  /// In ru, this message translates to:
  /// **'WiFi: {network}'**
  String wifiNetwork(String network);

  /// Main screen title
  ///
  /// In ru, this message translates to:
  /// **'BREEZ Home'**
  String get hvacControl;

  /// Temperature label
  ///
  /// In ru, this message translates to:
  /// **'Температура'**
  String get temperature;

  /// Humidity label
  ///
  /// In ru, this message translates to:
  /// **'Влажность'**
  String get humidity;

  /// Air quality label
  ///
  /// In ru, this message translates to:
  /// **'Качество воздуха'**
  String get airQuality;

  /// Fan speed label
  ///
  /// In ru, this message translates to:
  /// **'Скорость вентилятора'**
  String get fanSpeed;

  /// Fan label short
  ///
  /// In ru, this message translates to:
  /// **'Вентилятор'**
  String get fan;

  /// Mode label
  ///
  /// In ru, this message translates to:
  /// **'Режим'**
  String get mode;

  /// Operating mode title
  ///
  /// In ru, this message translates to:
  /// **'Режим работы'**
  String get operatingMode;

  /// Power label
  ///
  /// In ru, this message translates to:
  /// **'Питание'**
  String get power;

  /// On state
  ///
  /// In ru, this message translates to:
  /// **'Вкл'**
  String get on;

  /// Off state
  ///
  /// In ru, this message translates to:
  /// **'Выкл'**
  String get off;

  /// Current label
  ///
  /// In ru, this message translates to:
  /// **'Текущая'**
  String get current;

  /// Target label
  ///
  /// In ru, this message translates to:
  /// **'Целевая'**
  String get target;

  /// Cooling mode
  ///
  /// In ru, this message translates to:
  /// **'Охлаждение'**
  String get cooling;

  /// Heating mode
  ///
  /// In ru, this message translates to:
  /// **'Обогрев'**
  String get heating;

  /// Auto mode
  ///
  /// In ru, this message translates to:
  /// **'Авто'**
  String get auto;

  /// Low speed
  ///
  /// In ru, this message translates to:
  /// **'Низкая'**
  String get low;

  /// Password strength
  ///
  /// In ru, this message translates to:
  /// **'Средний'**
  String get medium;

  /// High speed
  ///
  /// In ru, this message translates to:
  /// **'Высокая'**
  String get high;

  /// Mode 2 label
  ///
  /// In ru, this message translates to:
  /// **'Режим 2'**
  String get mode2;

  /// Ventilation mode label
  ///
  /// In ru, this message translates to:
  /// **'Режим вентиляции'**
  String get ventilationMode;

  /// Not selected state
  ///
  /// In ru, this message translates to:
  /// **'Не выбран'**
  String get notSelected;

  /// Basic ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Базовый'**
  String get modeBasic;

  /// Intensive ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Интенсивный'**
  String get modeIntensive;

  /// Economic ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Экономичный'**
  String get modeEconomic;

  /// Maximum ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Максимальный'**
  String get modeMaximum;

  /// Kitchen ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Кухня'**
  String get modeKitchen;

  /// Fireplace ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Камин'**
  String get modeFireplace;

  /// Vacation ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Отпуск'**
  String get modeVacation;

  /// Custom ventilation mode
  ///
  /// In ru, this message translates to:
  /// **'Пользовательский'**
  String get modeCustom;

  /// Supply air label
  ///
  /// In ru, this message translates to:
  /// **'Приток'**
  String get supplyAir;

  /// Exhaust air label
  ///
  /// In ru, this message translates to:
  /// **'Вытяжка'**
  String get exhaustAir;

  /// Temperatures label
  ///
  /// In ru, this message translates to:
  /// **'Температуры'**
  String get temperatures;

  /// Monitoring and settings label
  ///
  /// In ru, this message translates to:
  /// **'Мониторинг и уставки'**
  String get monitoringAndSettings;

  /// Outdoor label
  ///
  /// In ru, this message translates to:
  /// **'Наружный'**
  String get outdoor;

  /// Indoor label
  ///
  /// In ru, this message translates to:
  /// **'Внутренний'**
  String get indoor;

  /// Humidifier air label
  ///
  /// In ru, this message translates to:
  /// **'Увлажнитель\nвоздуха'**
  String get humidifierAir;

  /// Purifier air label
  ///
  /// In ru, this message translates to:
  /// **'Очиститель\nвоздуха'**
  String get purifierAir;

  /// Lighting section
  ///
  /// In ru, this message translates to:
  /// **'Освещение'**
  String get lighting;

  /// Main light label
  ///
  /// In ru, this message translates to:
  /// **'Основной свет'**
  String get mainLight;

  /// Floor lamp label
  ///
  /// In ru, this message translates to:
  /// **'Торшер'**
  String get floorLamp;

  /// Unit label
  ///
  /// In ru, this message translates to:
  /// **'Блок'**
  String get unit;

  /// Notifications coming soon message
  ///
  /// In ru, this message translates to:
  /// **'Функция уведомлений скоро будет доступна'**
  String get notificationsComingSoon;

  /// Favorite action
  ///
  /// In ru, this message translates to:
  /// **'Избранное'**
  String get favorite;

  /// Activity label
  ///
  /// In ru, this message translates to:
  /// **'Активность'**
  String get activity;

  /// See all button
  ///
  /// In ru, this message translates to:
  /// **'Смотреть все'**
  String get seeAll;

  /// Excellent air quality
  ///
  /// In ru, this message translates to:
  /// **'Отлично'**
  String get excellent;

  /// Good air quality
  ///
  /// In ru, this message translates to:
  /// **'Хорошо'**
  String get good;

  /// Moderate air quality
  ///
  /// In ru, this message translates to:
  /// **'Умеренно'**
  String get moderate;

  /// Poor air quality
  ///
  /// In ru, this message translates to:
  /// **'Плохо'**
  String get poor;

  /// Very poor air quality
  ///
  /// In ru, this message translates to:
  /// **'Очень плохо'**
  String get veryPoor;

  /// Quick actions title
  ///
  /// In ru, this message translates to:
  /// **'Быстрые действия'**
  String get quickActions;

  /// Turn all devices on
  ///
  /// In ru, this message translates to:
  /// **'Все вкл'**
  String get allOn;

  /// Turn all devices off
  ///
  /// In ru, this message translates to:
  /// **'Все выкл'**
  String get allOff;

  /// Sync devices
  ///
  /// In ru, this message translates to:
  /// **'Синхр.'**
  String get sync;

  /// Presets title
  ///
  /// In ru, this message translates to:
  /// **'Пресеты'**
  String get presets;

  /// Error title
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get error;

  /// Connection error title
  ///
  /// In ru, this message translates to:
  /// **'Ошибка подключения'**
  String get connectionError;

  /// Server error title
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сервера'**
  String get serverError;

  /// Permission required title
  ///
  /// In ru, this message translates to:
  /// **'Требуется разрешение'**
  String get permissionRequired;

  /// Generic error title
  ///
  /// In ru, this message translates to:
  /// **'Упс! Что-то пошло не так'**
  String get somethingWentWrong;

  /// Network error message
  ///
  /// In ru, this message translates to:
  /// **'Не удается подключиться к серверу. Проверьте интернет-соединение.'**
  String get unableToConnect;

  /// Server error message
  ///
  /// In ru, this message translates to:
  /// **'На нашей стороне произошла ошибка. Попробуйте позже.'**
  String get serverErrorMessage;

  /// Permission required message
  ///
  /// In ru, this message translates to:
  /// **'Эта функция требует дополнительных разрешений для работы.'**
  String get permissionRequiredMessage;

  /// Network connection failed
  ///
  /// In ru, this message translates to:
  /// **'Сбой сетевого подключения. Проверьте интернет-соединение.'**
  String get networkConnectionFailed;

  /// Request timeout error
  ///
  /// In ru, this message translates to:
  /// **'Время ожидания запроса истекло. Попробуйте еще раз.'**
  String get requestTimedOut;

  /// Device server connection error
  ///
  /// In ru, this message translates to:
  /// **'Не удалось подключиться к серверу устройств'**
  String get failedToConnect;

  /// Connection failed with error
  ///
  /// In ru, this message translates to:
  /// **'Подключение не удалось: {error}'**
  String connectionFailed(String error);

  /// Failed to add device
  ///
  /// In ru, this message translates to:
  /// **'Не удалось добавить устройство: {error}'**
  String failedToAddDevice(String error);

  /// Failed to remove device
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить устройство: {error}'**
  String failedToRemoveDevice(String error);

  /// Failed to load more items
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить больше элементов: {error}'**
  String failedToLoadMore(String error);

  /// Try again button
  ///
  /// In ru, this message translates to:
  /// **'Попробовать снова'**
  String get tryAgain;

  /// Retry button
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// Retry connection button
  ///
  /// In ru, this message translates to:
  /// **'Повторить подключение'**
  String get retryConnection;

  /// Refreshing message
  ///
  /// In ru, this message translates to:
  /// **'Обновление...'**
  String get refreshing;

  /// Refresh devices tooltip
  ///
  /// In ru, this message translates to:
  /// **'Обновить устройства'**
  String get refreshDevices;

  /// Retrying connection announcement
  ///
  /// In ru, this message translates to:
  /// **'Повторная попытка подключения'**
  String get retryingConnection;

  /// Error code display
  ///
  /// In ru, this message translates to:
  /// **'Код ошибки: {code}'**
  String errorCode(String code);

  /// Error code copied message
  ///
  /// In ru, this message translates to:
  /// **'Код ошибки скопирован в буфер обмена'**
  String get errorCodeCopied;

  /// Technical details label
  ///
  /// In ru, this message translates to:
  /// **'Технические детали'**
  String get technicalDetails;

  /// Double tap to retry hint
  ///
  /// In ru, this message translates to:
  /// **'Дважды нажмите для повтора'**
  String get doubleTapToRetry;

  /// Loading message
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// Loading devices message
  ///
  /// In ru, this message translates to:
  /// **'Загрузка устройств...'**
  String get loadingDevices;

  /// All units loaded message
  ///
  /// In ru, this message translates to:
  /// **'Все блоки загружены'**
  String get allUnitsLoaded;

  /// Connecting message
  ///
  /// In ru, this message translates to:
  /// **'Подключение...'**
  String get connecting;

  /// Reconnecting message
  ///
  /// In ru, this message translates to:
  /// **'Переподключение...'**
  String get reconnecting;

  /// No devices title
  ///
  /// In ru, this message translates to:
  /// **'Нет устройств'**
  String get noDevices;

  /// No devices found message
  ///
  /// In ru, this message translates to:
  /// **'Устройства не найдены'**
  String get noDevicesFound;

  /// Add first device prompt
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первое устройство, чтобы начать'**
  String get addFirstDevice;

  /// MQTT settings help text
  ///
  /// In ru, this message translates to:
  /// **'Проверьте настройки MQTT-подключения\nи убедитесь, что устройства в сети'**
  String get checkMqttSettings;

  /// No device selected message
  ///
  /// In ru, this message translates to:
  /// **'Устройство не выбрано'**
  String get deviceNotSelected;

  /// Opening device addition announcement
  ///
  /// In ru, this message translates to:
  /// **'Открытие экрана добавления устройства'**
  String get openDeviceAddition;

  /// Camera initialization message
  ///
  /// In ru, this message translates to:
  /// **'Инициализация камеры...'**
  String get initializingCamera;

  /// Camera permission message
  ///
  /// In ru, this message translates to:
  /// **'Для сканирования QR-кодов требуется доступ к камере.\nРазрешите доступ к камере в настройках браузера.'**
  String get cameraAccessRequired;

  /// Camera error title
  ///
  /// In ru, this message translates to:
  /// **'Ошибка камеры'**
  String get cameraError;

  /// Camera error message
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка при доступе к камере.'**
  String get cameraErrorMessage;

  /// Web camera setup message
  ///
  /// In ru, this message translates to:
  /// **'Сканирование веб-камерой требует дополнительной настройки. Используйте ручной ввод или сканируйте с мобильного устройства.'**
  String get webCameraSetupRequired;

  /// Camera view label
  ///
  /// In ru, this message translates to:
  /// **'Вид с камеры'**
  String get cameraView;

  /// Email required validation
  ///
  /// In ru, this message translates to:
  /// **'Email обязателен'**
  String get emailRequired;

  /// Invalid email validation
  ///
  /// In ru, this message translates to:
  /// **'Введите корректный email'**
  String get invalidEmail;

  /// Password required validation
  ///
  /// In ru, this message translates to:
  /// **'Пароль обязателен'**
  String get passwordRequired;

  /// Password too short validation
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен содержать минимум {length} символов'**
  String passwordTooShort(int length);

  /// Name required validation
  ///
  /// In ru, this message translates to:
  /// **'{fieldName} обязательно'**
  String nameRequired(String fieldName);

  /// Name too short validation
  ///
  /// In ru, this message translates to:
  /// **'{fieldName} должно содержать минимум 2 символа'**
  String nameTooShort(String fieldName);

  /// Fill required fields message
  ///
  /// In ru, this message translates to:
  /// **'Заполните все обязательные поля'**
  String get fillRequiredFields;

  /// Accept terms validation
  ///
  /// In ru, this message translates to:
  /// **'Примите условия и положения'**
  String get pleaseAcceptTerms;

  /// Minimum characters hint
  ///
  /// In ru, this message translates to:
  /// **'Мин. {count} символов'**
  String minCharacters(int count);

  /// Password requirement
  ///
  /// In ru, this message translates to:
  /// **'Минимум 8 символов'**
  String get atLeast8Characters;

  /// Password requirement
  ///
  /// In ru, this message translates to:
  /// **'Заглавная буква'**
  String get uppercaseLetter;

  /// Password requirement
  ///
  /// In ru, this message translates to:
  /// **'Строчная буква'**
  String get lowercaseLetter;

  /// Password requirement
  ///
  /// In ru, this message translates to:
  /// **'Цифра'**
  String get number;

  /// Password requirement
  ///
  /// In ru, this message translates to:
  /// **'Специальный символ'**
  String get specialCharacter;

  /// Password strength
  ///
  /// In ru, this message translates to:
  /// **'Слабый'**
  String get weak;

  /// Password strength
  ///
  /// In ru, this message translates to:
  /// **'Сильный'**
  String get strong;

  /// Password strength
  ///
  /// In ru, this message translates to:
  /// **'Очень сильный'**
  String get veryStrong;

  /// Schedule label
  ///
  /// In ru, this message translates to:
  /// **'Расписание'**
  String get schedule;

  /// Automatic control label
  ///
  /// In ru, this message translates to:
  /// **'Автоматическое управление'**
  String get automaticControl;

  /// Configure schedule button
  ///
  /// In ru, this message translates to:
  /// **'Настроить расписание'**
  String get configureSchedule;

  /// Operating time label
  ///
  /// In ru, this message translates to:
  /// **'Время работы'**
  String get operatingTime;

  /// Running status
  ///
  /// In ru, this message translates to:
  /// **'Работает'**
  String get running;

  /// Stopped status
  ///
  /// In ru, this message translates to:
  /// **'Выключено'**
  String get stopped;

  /// Turn on action
  ///
  /// In ru, this message translates to:
  /// **'Включение'**
  String get turnOn;

  /// Turn off action
  ///
  /// In ru, this message translates to:
  /// **'Отключение'**
  String get turnOff;

  /// Monday
  ///
  /// In ru, this message translates to:
  /// **'Понедельник'**
  String get monday;

  /// Tuesday
  ///
  /// In ru, this message translates to:
  /// **'Вторник'**
  String get tuesday;

  /// Wednesday
  ///
  /// In ru, this message translates to:
  /// **'Среда'**
  String get wednesday;

  /// Thursday
  ///
  /// In ru, this message translates to:
  /// **'Четверг'**
  String get thursday;

  /// Friday
  ///
  /// In ru, this message translates to:
  /// **'Пятница'**
  String get friday;

  /// Saturday
  ///
  /// In ru, this message translates to:
  /// **'Суббота'**
  String get saturday;

  /// Sunday
  ///
  /// In ru, this message translates to:
  /// **'Воскресенье'**
  String get sunday;

  /// Edit schedule semantic label
  ///
  /// In ru, this message translates to:
  /// **'Редактировать {name}'**
  String editSchedule(String name);

  /// Delete schedule semantic label
  ///
  /// In ru, this message translates to:
  /// **'Удалить {name}'**
  String deleteSchedule(String name);

  /// Edit schedule tooltip
  ///
  /// In ru, this message translates to:
  /// **'Редактировать расписание'**
  String get editScheduleTooltip;

  /// Delete schedule tooltip
  ///
  /// In ru, this message translates to:
  /// **'Удалить расписание'**
  String get deleteScheduleTooltip;

  /// Success title
  ///
  /// In ru, this message translates to:
  /// **'Успешно'**
  String get success;

  /// Settings saved message
  ///
  /// In ru, this message translates to:
  /// **'Настройки сохранены. Перезапустите приложение для применения изменений.'**
  String get settingsSaved;

  /// Preset applied message
  ///
  /// In ru, this message translates to:
  /// **'Пресет применен'**
  String get presetApplied;

  /// All units on message
  ///
  /// In ru, this message translates to:
  /// **'Все блоки включены'**
  String get allUnitsOn;

  /// All units off message
  ///
  /// In ru, this message translates to:
  /// **'Все блоки выключены'**
  String get allUnitsOff;

  /// Settings synced message
  ///
  /// In ru, this message translates to:
  /// **'Настройки синхронизированы со всеми блоками'**
  String get settingsSynced;

  /// Schedule applied message
  ///
  /// In ru, this message translates to:
  /// **'Расписание применено ко всем блокам'**
  String get scheduleAppliedToAll;

  /// Power change error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка изменения питания'**
  String get errorChangingPower;

  /// Mode update error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка обновления режима'**
  String get errorUpdatingMode;

  /// Fan speed update error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка обновления скорости вентилятора'**
  String get errorUpdatingFanSpeed;

  /// Preset apply error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка применения пресета'**
  String get errorApplyingPreset;

  /// Turn on units error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка включения блоков'**
  String get errorTurningOnUnits;

  /// Turn off units error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка выключения блоков'**
  String get errorTurningOffUnits;

  /// Settings sync error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка синхронизации настроек'**
  String get errorSyncingSettings;

  /// Schedule apply error
  ///
  /// In ru, this message translates to:
  /// **'Ошибка применения расписания'**
  String get errorApplyingSchedule;

  /// Connected status
  ///
  /// In ru, this message translates to:
  /// **'Подключено'**
  String get connected;

  /// Disconnected status
  ///
  /// In ru, this message translates to:
  /// **'Отключено'**
  String get disconnected;

  /// Idle status
  ///
  /// In ru, this message translates to:
  /// **'Ожидание'**
  String get idle;

  /// Active status
  ///
  /// In ru, this message translates to:
  /// **'Активно'**
  String get active;

  /// Inactive status
  ///
  /// In ru, this message translates to:
  /// **'Неактивно'**
  String get inactive;

  /// Enabled status
  ///
  /// In ru, this message translates to:
  /// **'Включено'**
  String get enabled;

  /// Disabled status
  ///
  /// In ru, this message translates to:
  /// **'Выключено'**
  String get disabled;

  /// Available status
  ///
  /// In ru, this message translates to:
  /// **'Доступно'**
  String get available;

  /// Unavailable status
  ///
  /// In ru, this message translates to:
  /// **'Недоступно'**
  String get unavailable;

  /// Maintenance status
  ///
  /// In ru, this message translates to:
  /// **'Обслуживание'**
  String get maintenance;

  /// Activated state
  ///
  /// In ru, this message translates to:
  /// **'активировано'**
  String get activated;

  /// Deactivated state
  ///
  /// In ru, this message translates to:
  /// **'деактивировано'**
  String get deactivated;

  /// Save button
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// Cancel button
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// Close button
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// Confirm button
  ///
  /// In ru, this message translates to:
  /// **'Подтвердить'**
  String get confirm;

  /// Yes button
  ///
  /// In ru, this message translates to:
  /// **'Да'**
  String get yes;

  /// No button
  ///
  /// In ru, this message translates to:
  /// **'Нет'**
  String get no;

  /// OK button
  ///
  /// In ru, this message translates to:
  /// **'ОК'**
  String get ok;

  /// Apply button
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get apply;

  /// Reset button
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get reset;

  /// Clear button
  ///
  /// In ru, this message translates to:
  /// **'Очистить'**
  String get clear;

  /// Done button
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get done;

  /// Add button
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get add;

  /// Remove button
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get remove;

  /// Filter button
  ///
  /// In ru, this message translates to:
  /// **'Фильтр'**
  String get filter;

  /// Sort button
  ///
  /// In ru, this message translates to:
  /// **'Сортировать'**
  String get sort;

  /// Refresh button
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get refresh;

  /// Logout button
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get logout;

  /// Status label
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get status;

  /// Details label
  ///
  /// In ru, this message translates to:
  /// **'Детали'**
  String get details;

  /// More label
  ///
  /// In ru, this message translates to:
  /// **'Больше'**
  String get more;

  /// Less label
  ///
  /// In ru, this message translates to:
  /// **'Меньше'**
  String get less;

  /// All label
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get all;

  /// None label
  ///
  /// In ru, this message translates to:
  /// **'Ничего'**
  String get none;

  /// Optional field hint
  ///
  /// In ru, this message translates to:
  /// **'Опционально'**
  String get optional;

  /// Required field hint
  ///
  /// In ru, this message translates to:
  /// **'Обязательно'**
  String get required;

  /// Information label
  ///
  /// In ru, this message translates to:
  /// **'Информация'**
  String get info;

  /// Warning label
  ///
  /// In ru, this message translates to:
  /// **'Предупреждение'**
  String get warning;

  /// Notification label
  ///
  /// In ru, this message translates to:
  /// **'Уведомление'**
  String get notification;

  /// Today label
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// Yesterday label
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get yesterday;

  /// Week label
  ///
  /// In ru, this message translates to:
  /// **'Неделя'**
  String get week;

  /// Month label
  ///
  /// In ru, this message translates to:
  /// **'Месяц'**
  String get month;

  /// Year label
  ///
  /// In ru, this message translates to:
  /// **'Год'**
  String get year;

  /// Date format
  ///
  /// In ru, this message translates to:
  /// **'{date}'**
  String date(String date);

  /// Automation panel title
  ///
  /// In ru, this message translates to:
  /// **'Автоматизация'**
  String get automation;

  /// Manage rules button
  ///
  /// In ru, this message translates to:
  /// **'Управление правилами'**
  String get manageRules;

  /// Active rules count format
  ///
  /// In ru, this message translates to:
  /// **'Активно: {active} из {total}'**
  String activeRulesFormat(int active, int total);

  /// Critical notification label
  ///
  /// In ru, this message translates to:
  /// **'Критические'**
  String get critical;

  /// Errors notification label
  ///
  /// In ru, this message translates to:
  /// **'Ошибки'**
  String get errors;

  /// Warnings notification label
  ///
  /// In ru, this message translates to:
  /// **'Предупреждения'**
  String get warnings;

  /// Info notification label
  ///
  /// In ru, this message translates to:
  /// **'Инфо'**
  String get infoLabel;

  /// Show all notifications button
  ///
  /// In ru, this message translates to:
  /// **'Показать все ({count})'**
  String showAll(int count);

  /// Collapse button
  ///
  /// In ru, this message translates to:
  /// **'Свернуть'**
  String get collapse;

  /// Manage rules coming soon
  ///
  /// In ru, this message translates to:
  /// **'Управление правилами (Скоро)'**
  String get manageRulesComingSoon;

  /// Add unit coming soon
  ///
  /// In ru, this message translates to:
  /// **'Функция добавления блока скоро будет доступна'**
  String get addUnitComingSoon;

  /// Living room name
  ///
  /// In ru, this message translates to:
  /// **'Гостиная'**
  String get livingRoom;

  /// Bedroom name
  ///
  /// In ru, this message translates to:
  /// **'Спальня'**
  String get bedroom;

  /// Kitchen name
  ///
  /// In ru, this message translates to:
  /// **'Кухня'**
  String get kitchen;

  /// Vacuum cleaner device type
  ///
  /// In ru, this message translates to:
  /// **'Пылесос'**
  String get vacuumCleaner;

  /// Smart bulb device type
  ///
  /// In ru, this message translates to:
  /// **'Умная лампа'**
  String get smartBulb;

  /// Humidifier device type
  ///
  /// In ru, this message translates to:
  /// **'Увлажнитель'**
  String get humidifier;

  /// Average label
  ///
  /// In ru, this message translates to:
  /// **'Среднее'**
  String get average;

  /// Minimum label
  ///
  /// In ru, this message translates to:
  /// **'Мин'**
  String get min;

  /// Maximum label
  ///
  /// In ru, this message translates to:
  /// **'Макс'**
  String get max;

  /// Temperature history title
  ///
  /// In ru, this message translates to:
  /// **'История температуры'**
  String get temperatureHistory;

  /// Last 24 hours label
  ///
  /// In ru, this message translates to:
  /// **'Последние 24 часа'**
  String get last24Hours;

  /// Active devices count
  ///
  /// In ru, this message translates to:
  /// **'{count} из {total} активно'**
  String activeDevices(int count, int total);

  /// Run diagnostics button
  ///
  /// In ru, this message translates to:
  /// **'Запустить диагностику'**
  String get runDiagnostics;

  /// System health title
  ///
  /// In ru, this message translates to:
  /// **'Состояние системы'**
  String get systemHealth;

  /// Supply fan component
  ///
  /// In ru, this message translates to:
  /// **'Приточный вентилятор'**
  String get supplyFan;

  /// Exhaust fan component
  ///
  /// In ru, this message translates to:
  /// **'Вытяжной вентилятор'**
  String get exhaustFan;

  /// Heater component
  ///
  /// In ru, this message translates to:
  /// **'Нагреватель'**
  String get heater;

  /// Heat recuperator
  ///
  /// In ru, this message translates to:
  /// **'Рекуператор'**
  String get recuperator;

  /// Sensors component
  ///
  /// In ru, this message translates to:
  /// **'Датчики'**
  String get sensors;

  /// Normal status
  ///
  /// In ru, this message translates to:
  /// **'Норма'**
  String get normal;

  /// Sensor readings title
  ///
  /// In ru, this message translates to:
  /// **'Показания датчиков'**
  String get sensorReadings;

  /// Supply air temperature
  ///
  /// In ru, this message translates to:
  /// **'Температура притока'**
  String get supplyAirTemp;

  /// Outdoor temperature
  ///
  /// In ru, this message translates to:
  /// **'Температура улицы'**
  String get outdoorTemp;

  /// Pressure reading
  ///
  /// In ru, this message translates to:
  /// **'Давление'**
  String get pressure;

  /// Network connection title
  ///
  /// In ru, this message translates to:
  /// **'Сетевое подключение'**
  String get networkConnection;

  /// Network label
  ///
  /// In ru, this message translates to:
  /// **'Сеть'**
  String get network;

  /// Signal strength
  ///
  /// In ru, this message translates to:
  /// **'Сигнал'**
  String get signal;

  /// IP address label
  ///
  /// In ru, this message translates to:
  /// **'IP адрес'**
  String get ipAddress;

  /// Not connected status
  ///
  /// In ru, this message translates to:
  /// **'Не подключено'**
  String get notConnected;

  /// Not assigned status
  ///
  /// In ru, this message translates to:
  /// **'Не назначен'**
  String get notAssigned;

  /// Diagnostics title
  ///
  /// In ru, this message translates to:
  /// **'Диагностика'**
  String get diagnosticsTitle;

  /// Diagnostics running message
  ///
  /// In ru, this message translates to:
  /// **'Выполняется диагностика системы...'**
  String get diagnosticsRunning;

  /// Diagnostics complete message
  ///
  /// In ru, this message translates to:
  /// **'Диагностика завершена. Система в норме.'**
  String get diagnosticsComplete;

  /// Schedule saved message
  ///
  /// In ru, this message translates to:
  /// **'Расписание успешно сохранено'**
  String get scheduleSaved;

  /// Save error message
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сохранения: {error}'**
  String saveError(String error);

  /// Unsaved changes title
  ///
  /// In ru, this message translates to:
  /// **'Несохранённые изменения'**
  String get unsavedChanges;

  /// Unsaved changes confirmation
  ///
  /// In ru, this message translates to:
  /// **'У вас есть несохранённые изменения. Выйти без сохранения?'**
  String get unsavedChangesMessage;

  /// Exit button
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get exit;

  /// New devices found
  ///
  /// In ru, this message translates to:
  /// **'{count} новых устройств'**
  String devicesFound(int count);

  /// Single device found
  ///
  /// In ru, this message translates to:
  /// **'{count} новое устройство'**
  String deviceFound(int count);

  /// Device not found message
  ///
  /// In ru, this message translates to:
  /// **'Не нашли\nустройство?'**
  String get notFoundDeviceTitle;

  /// Select manually button
  ///
  /// In ru, this message translates to:
  /// **'Выбрать вручную'**
  String get selectManuallyButton;

  /// Devices added confirmation
  ///
  /// In ru, this message translates to:
  /// **'{count} {plural} добавлено'**
  String devicesAdded(int count, String plural);

  /// Device singular
  ///
  /// In ru, this message translates to:
  /// **'устройство'**
  String get device;

  /// Devices plural
  ///
  /// In ru, this message translates to:
  /// **'устройства'**
  String get devices;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
