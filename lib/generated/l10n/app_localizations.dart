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

  /// Forgot password link
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPassword;

  /// No account prompt
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта?'**
  String get noAccount;

  /// Have account prompt
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт?'**
  String get haveAccount;

  /// Consent required error
  ///
  /// In ru, this message translates to:
  /// **'Необходимо согласие на обработку персональных данных'**
  String get consentRequired;

  /// Consent checkbox label
  ///
  /// In ru, this message translates to:
  /// **'Я согласен на обработку персональных данных'**
  String get consentLabel;

  /// Password field hint
  ///
  /// In ru, this message translates to:
  /// **'Минимум 8 символов, буквы и цифры'**
  String get passwordHint;

  /// Password recovery title
  ///
  /// In ru, this message translates to:
  /// **'ВОССТАНОВЛЕНИЕ ПАРОЛЯ'**
  String get passwordRecovery;

  /// Password recovery description
  ///
  /// In ru, this message translates to:
  /// **'Введите email, указанный при регистрации.\nМы отправим код для сброса пароля.'**
  String get enterEmailForReset;

  /// Send code button
  ///
  /// In ru, this message translates to:
  /// **'Отправить код'**
  String get sendCode;

  /// Code sent confirmation
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на {email}'**
  String codeSentTo(String email);

  /// Enter code prompt
  ///
  /// In ru, this message translates to:
  /// **'Введите 6-значный код'**
  String get enterSixDigitCode;

  /// Enter code description
  ///
  /// In ru, this message translates to:
  /// **'Введите код, отправленный на'**
  String get enterCodeSentTo;

  /// Resend code button
  ///
  /// In ru, this message translates to:
  /// **'Отправить код повторно'**
  String get resendCode;

  /// Password changed success message
  ///
  /// In ru, this message translates to:
  /// **'Пароль успешно изменён'**
  String get passwordChangedSuccess;

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

  /// Email notifications option (Russian: Email-уведомления)
  ///
  /// In ru, this message translates to:
  /// **'Email-уведомления'**
  String get emailNotifications;

  /// Alarm notifications option
  ///
  /// In ru, this message translates to:
  /// **'Уведомления об авариях'**
  String get alarmNotifications;

  /// Language section (Russian: Язык)
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// Add device button
  ///
  /// In ru, this message translates to:
  /// **'Добавить устройство'**
  String get addDevice;

  /// Device name field label
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get deviceName;

  /// Delete action
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

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

  /// Operating mode title
  ///
  /// In ru, this message translates to:
  /// **'Режим работы'**
  String get operatingMode;

  /// Target temperature label
  ///
  /// In ru, this message translates to:
  /// **'Целевая температура'**
  String get targetTemperature;

  /// Intake airflow label
  ///
  /// In ru, this message translates to:
  /// **'Приток'**
  String get intake;

  /// Exhaust airflow label
  ///
  /// In ru, this message translates to:
  /// **'Вытяжка'**
  String get exhaust;

  /// Airflow rate label
  ///
  /// In ru, this message translates to:
  /// **'Поток'**
  String get airflowRate;

  /// Filter button
  ///
  /// In ru, this message translates to:
  /// **'Фильтр'**
  String get filter;

  /// Today with date
  ///
  /// In ru, this message translates to:
  /// **'Сегодня, {date}'**
  String todayDate(String date);

  /// Presets title
  ///
  /// In ru, this message translates to:
  /// **'Пресеты'**
  String get presets;

  /// Retry button
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// Loading message
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No devices title
  ///
  /// In ru, this message translates to:
  /// **'Нет устройств'**
  String get noDevices;

  /// Password too short validation
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен содержать минимум {length} символов'**
  String passwordTooShort(int length);

  /// Name too short validation
  ///
  /// In ru, this message translates to:
  /// **'{fieldName} должно содержать минимум 2 символа'**
  String nameTooShort(String fieldName);

  /// Enter email prompt
  ///
  /// In ru, this message translates to:
  /// **'Введите email'**
  String get enterEmail;

  /// Enter password prompt
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль'**
  String get enterPassword;

  /// Confirm password required
  ///
  /// In ru, this message translates to:
  /// **'Подтвердите пароль'**
  String get confirmPasswordRequired;

  /// Password Latin only validation
  ///
  /// In ru, this message translates to:
  /// **'Пароль должен содержать только латинские буквы'**
  String get passwordOnlyLatin;

  /// Password digit requirement
  ///
  /// In ru, this message translates to:
  /// **'Должен содержать хотя бы одну цифру'**
  String get passwordMustContainDigit;

  /// Password letter requirement
  ///
  /// In ru, this message translates to:
  /// **'Должен содержать хотя бы одну латинскую букву'**
  String get passwordMustContainLetter;

  /// Enter name prompt
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get enterName;

  /// Enter field prompt
  ///
  /// In ru, this message translates to:
  /// **'Введите {fieldName}'**
  String enterField(String fieldName);

  /// Name letters only validation
  ///
  /// In ru, this message translates to:
  /// **'Только буквы (допускаются пробелы и дефис)'**
  String get nameOnlyLetters;

  /// Invalid email format validation
  ///
  /// In ru, this message translates to:
  /// **'Неверный формат email'**
  String get invalidEmailFormat;

  /// Schedule label
  ///
  /// In ru, this message translates to:
  /// **'Расписание'**
  String get schedule;

  /// All with count
  ///
  /// In ru, this message translates to:
  /// **'Все (+{count})'**
  String allCount(int count);

  /// No schedule message
  ///
  /// In ru, this message translates to:
  /// **'Нет расписания'**
  String get noSchedule;

  /// Add schedule hint
  ///
  /// In ru, this message translates to:
  /// **'Добавьте расписание для устройства'**
  String get addScheduleForDevice;

  /// Now label
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get nowLabel;

  /// Alarms section title
  ///
  /// In ru, this message translates to:
  /// **'Аварии'**
  String get alarms;

  /// No alarms message
  ///
  /// In ru, this message translates to:
  /// **'Нет аварий'**
  String get noAlarms;

  /// System normal status
  ///
  /// In ru, this message translates to:
  /// **'Система работает штатно'**
  String get systemWorkingNormally;

  /// Alarm history button
  ///
  /// In ru, this message translates to:
  /// **'История аварий'**
  String get alarmHistory;

  /// No notifications message
  ///
  /// In ru, this message translates to:
  /// **'Нет уведомлений'**
  String get noNotifications;

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

  /// Monday short
  ///
  /// In ru, this message translates to:
  /// **'Пн'**
  String get mondayShort;

  /// Tuesday short
  ///
  /// In ru, this message translates to:
  /// **'Вт'**
  String get tuesdayShort;

  /// Wednesday short
  ///
  /// In ru, this message translates to:
  /// **'Ср'**
  String get wednesdayShort;

  /// Thursday short
  ///
  /// In ru, this message translates to:
  /// **'Чт'**
  String get thursdayShort;

  /// Friday short
  ///
  /// In ru, this message translates to:
  /// **'Пт'**
  String get fridayShort;

  /// Saturday short
  ///
  /// In ru, this message translates to:
  /// **'Сб'**
  String get saturdayShort;

  /// Sunday short
  ///
  /// In ru, this message translates to:
  /// **'Вс'**
  String get sundayShort;

  /// Save button
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// Enable/activate button
  ///
  /// In ru, this message translates to:
  /// **'Включить'**
  String get enable;

  /// Cancel button
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// Logout button
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get logout;

  /// Today label
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// Devices tab label
  ///
  /// In ru, this message translates to:
  /// **'Устройства'**
  String get devices;

  /// Profile screen title
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profile;

  /// Profile updated success message
  ///
  /// In ru, this message translates to:
  /// **'Профиль обновлён'**
  String get profileUpdated;

  /// Password changed success message
  ///
  /// In ru, this message translates to:
  /// **'Пароль изменён. Войдите снова.'**
  String get passwordChanged;

  /// Edit profile button
  ///
  /// In ru, this message translates to:
  /// **'Редактировать профиль'**
  String get editProfile;

  /// Account section title
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт'**
  String get account;

  /// Change password button
  ///
  /// In ru, this message translates to:
  /// **'Сменить пароль'**
  String get changePassword;

  /// Theme setting
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get theme;

  /// Dark theme label
  ///
  /// In ru, this message translates to:
  /// **'Темная'**
  String get darkThemeLabel;

  /// Light theme label
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get lightThemeLabel;

  /// First name label
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get firstName;

  /// Last name label
  ///
  /// In ru, this message translates to:
  /// **'Фамилия'**
  String get lastName;

  /// Current password label
  ///
  /// In ru, this message translates to:
  /// **'Текущий пароль'**
  String get currentPassword;

  /// New password label
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPassword;

  /// Password confirmation label
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение пароля'**
  String get passwordConfirmation;

  /// Passwords do not match error
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get passwordsDoNotMatch;

  /// Change button
  ///
  /// In ru, this message translates to:
  /// **'Сменить'**
  String get change;

  /// All notifications button
  ///
  /// In ru, this message translates to:
  /// **'Все уведомления'**
  String get allNotifications;

  /// All alarms button
  ///
  /// In ru, this message translates to:
  /// **'Все аварии'**
  String get allAlarms;

  /// Time ago - just now
  ///
  /// In ru, this message translates to:
  /// **'Только что'**
  String get justNow;

  /// Time ago - minutes
  ///
  /// In ru, this message translates to:
  /// **'{count} мин назад'**
  String minutesAgo(int count);

  /// Time ago - hours
  ///
  /// In ru, this message translates to:
  /// **'{count} ч назад'**
  String hoursAgo(int count);

  /// Time ago - days
  ///
  /// In ru, this message translates to:
  /// **'{count} дн назад'**
  String daysAgo(int count);

  /// Add first schedule entry prompt
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первую запись'**
  String get addFirstEntry;

  /// Alarm code label
  ///
  /// In ru, this message translates to:
  /// **'Код {code}'**
  String alarmCode(String code);

  /// Active alarm badge
  ///
  /// In ru, this message translates to:
  /// **'АКТИВНА'**
  String get activeAlarm;

  /// Auto mode label
  ///
  /// In ru, this message translates to:
  /// **'Авто'**
  String get modeAuto;

  /// Eco mode label
  ///
  /// In ru, this message translates to:
  /// **'Эко'**
  String get modeEco;

  /// Night mode label
  ///
  /// In ru, this message translates to:
  /// **'Ночь'**
  String get modeNight;

  /// Boost/Turbo mode label
  ///
  /// In ru, this message translates to:
  /// **'ТУРБО'**
  String get modeBoost;

  /// Mode selector label
  ///
  /// In ru, this message translates to:
  /// **'Режим {name}'**
  String modeFor(String name);

  /// Device deleted toast
  ///
  /// In ru, this message translates to:
  /// **'Установка удалена'**
  String get deviceDeleted;

  /// Name changed toast
  ///
  /// In ru, this message translates to:
  /// **'Название изменено'**
  String get nameChanged;

  /// Time set toast
  ///
  /// In ru, this message translates to:
  /// **'Время установлено'**
  String get timeSet;

  /// Notifications feature in development
  ///
  /// In ru, this message translates to:
  /// **'Уведомления: функция в разработке'**
  String get notificationsInDevelopment;

  /// All devices turned off toast
  ///
  /// In ru, this message translates to:
  /// **'Все устройства выключены'**
  String get allDevicesTurnedOff;

  /// Add first device prompt
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первую установку по MAC-адресу'**
  String get addFirstDeviceByMac;

  /// Add unit button
  ///
  /// In ru, this message translates to:
  /// **'Добавить установку'**
  String get addUnit;

  /// Enter MAC address validation
  ///
  /// In ru, this message translates to:
  /// **'Введите MAC-адрес'**
  String get enterMacAddress;

  /// MAC address length validation
  ///
  /// In ru, this message translates to:
  /// **'MAC-адрес должен содержать 12 символов'**
  String get macAddressMustContain12Chars;

  /// MAC address hex validation
  ///
  /// In ru, this message translates to:
  /// **'MAC-адрес может содержать только 0-9 и A-F'**
  String get macAddressOnlyHex;

  /// MAC address field label
  ///
  /// In ru, this message translates to:
  /// **'MAC-адрес устройства'**
  String get deviceMacAddress;

  /// Cancel button
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancelButton;

  /// Add button
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get addButton;

  /// Device name example hint
  ///
  /// In ru, this message translates to:
  /// **'Например: Гостиная'**
  String get deviceNameExample;

  /// Device name validation
  ///
  /// In ru, this message translates to:
  /// **'Введите название установки'**
  String get enterDeviceName;

  /// MAC address help text
  ///
  /// In ru, this message translates to:
  /// **'MAC-адрес отображается на экране пульта устройства'**
  String get macAddressDisplayedOnRemote;

  /// Analytics tab label
  ///
  /// In ru, this message translates to:
  /// **'Аналитика'**
  String get analytics;

  /// Empty devices message
  ///
  /// In ru, this message translates to:
  /// **'Устройства появятся здесь\nпосле подключения'**
  String get devicesWillAppear;

  /// Comfort preset name
  ///
  /// In ru, this message translates to:
  /// **'Комфорт'**
  String get presetComfort;

  /// Comfort preset description
  ///
  /// In ru, this message translates to:
  /// **'Оптимальный режим'**
  String get presetComfortDesc;

  /// Eco preset name
  ///
  /// In ru, this message translates to:
  /// **'Эко'**
  String get presetEco;

  /// Eco preset description
  ///
  /// In ru, this message translates to:
  /// **'Энергосбережение'**
  String get presetEcoDesc;

  /// Night preset name
  ///
  /// In ru, this message translates to:
  /// **'Ночь'**
  String get presetNight;

  /// Night preset description
  ///
  /// In ru, this message translates to:
  /// **'Тихий режим'**
  String get presetNightDesc;

  /// Turbo preset name
  ///
  /// In ru, this message translates to:
  /// **'Турбо'**
  String get presetTurbo;

  /// Turbo preset description
  ///
  /// In ru, this message translates to:
  /// **'Максимальная мощность'**
  String get presetTurboDesc;

  /// Away preset name
  ///
  /// In ru, this message translates to:
  /// **'Нет дома'**
  String get presetAway;

  /// Away preset description
  ///
  /// In ru, this message translates to:
  /// **'Минимальный режим'**
  String get presetAwayDesc;

  /// Sleep preset name
  ///
  /// In ru, this message translates to:
  /// **'Сон'**
  String get presetSleep;

  /// Sleep preset description
  ///
  /// In ru, this message translates to:
  /// **'Комфортный сон'**
  String get presetSleepDesc;

  /// Devices count
  ///
  /// In ru, this message translates to:
  /// **'{count} устройств'**
  String devicesCount(int count);

  /// This month label
  ///
  /// In ru, this message translates to:
  /// **'Этот месяц'**
  String get thisMonth;

  /// Total time label
  ///
  /// In ru, this message translates to:
  /// **'Общее время'**
  String get totalTime;

  /// Energy in kilowatt-hours
  ///
  /// In ru, this message translates to:
  /// **'{value} кВт⋅ч'**
  String energyKwh(String value);

  /// Hours count
  ///
  /// In ru, this message translates to:
  /// **'{count} часов'**
  String hoursCount(int count);

  /// Airflow metric label
  ///
  /// In ru, this message translates to:
  /// **'Поток воздуха'**
  String get airflow;

  /// Graph temperature label
  ///
  /// In ru, this message translates to:
  /// **'Температура'**
  String get graphTemperatureLabel;

  /// Graph humidity label
  ///
  /// In ru, this message translates to:
  /// **'Влажность'**
  String get graphHumidityLabel;

  /// Graph airflow label
  ///
  /// In ru, this message translates to:
  /// **'Поток воздуха'**
  String get graphAirflowLabel;

  /// Temperature short label
  ///
  /// In ru, this message translates to:
  /// **'Темп'**
  String get tempShort;

  /// Humidity short label
  ///
  /// In ru, this message translates to:
  /// **'Влаж'**
  String get humidShort;

  /// Airflow short label
  ///
  /// In ru, this message translates to:
  /// **'Поток'**
  String get airflowShort;

  /// Minimum short label
  ///
  /// In ru, this message translates to:
  /// **'Мин'**
  String get minShort;

  /// Maximum short label
  ///
  /// In ru, this message translates to:
  /// **'Макс'**
  String get maxShort;

  /// Average short label
  ///
  /// In ru, this message translates to:
  /// **'Сред'**
  String get avgShort;

  /// Cubic meters per hour unit
  ///
  /// In ru, this message translates to:
  /// **'м³/ч'**
  String get cubicMetersPerHour;

  /// No description provided for @readAll.
  ///
  /// In ru, this message translates to:
  /// **'Прочитать все'**
  String get readAll;

  /// No description provided for @later.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get later;

  /// No description provided for @updateNow.
  ///
  /// In ru, this message translates to:
  /// **'Обновить сейчас'**
  String get updateNow;

  /// No description provided for @whatsNew.
  ///
  /// In ru, this message translates to:
  /// **'Что нового?'**
  String get whatsNew;

  /// No description provided for @hide.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть'**
  String get hide;

  /// No description provided for @errorNoConnection.
  ///
  /// In ru, this message translates to:
  /// **'Нет соединения'**
  String get errorNoConnection;

  /// No description provided for @errorServer.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сервера'**
  String get errorServer;

  /// No description provided for @errorServerWithCode.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка сервера ({code})'**
  String errorServerWithCode(int code);

  /// No description provided for @errorNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Не найдено'**
  String get errorNotFound;

  /// No description provided for @errorAuthRequired.
  ///
  /// In ru, this message translates to:
  /// **'Требуется авторизация'**
  String get errorAuthRequired;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так'**
  String get errorSomethingWrong;

  /// No description provided for @errorCheckInternet.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте подключение к интернету\nи попробуйте снова'**
  String get errorCheckInternet;

  /// No description provided for @errorServerProblems.
  ///
  /// In ru, this message translates to:
  /// **'Проблемы на стороне сервера.\nМы уже работаем над исправлением.'**
  String get errorServerProblems;

  /// No description provided for @errorResourceNotFound.
  ///
  /// In ru, this message translates to:
  /// **'Запрошенные {resource} не найдены.\nВозможно, они были удалены.'**
  String errorResourceNotFound(String resource);

  /// No description provided for @errorSessionExpired.
  ///
  /// In ru, this message translates to:
  /// **'Ваша сессия истекла.\nПожалуйста, войдите заново.'**
  String get errorSessionExpired;

  /// No description provided for @errorUnexpected.
  ///
  /// In ru, this message translates to:
  /// **'Произошла непредвиденная ошибка.\nПопробуйте повторить попытку.'**
  String get errorUnexpected;

  /// No description provided for @errorNoInternet.
  ///
  /// In ru, this message translates to:
  /// **'Нет соединения с интернетом'**
  String get errorNoInternet;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In ru, this message translates to:
  /// **'Сервер недоступен'**
  String get errorServerUnavailable;

  /// No description provided for @errorLoadingFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить устройства'**
  String get errorLoadingFailed;

  /// No description provided for @emptyNoDevicesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Нет устройств'**
  String get emptyNoDevicesTitle;

  /// No description provided for @emptyNoDevicesMessage.
  ///
  /// In ru, this message translates to:
  /// **'Устройства появятся здесь\nпосле подключения'**
  String get emptyNoDevicesMessage;

  /// No description provided for @emptyNothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get emptyNothingFound;

  /// No description provided for @emptyNoSearchResults.
  ///
  /// In ru, this message translates to:
  /// **'По запросу «{query}»\nничего не найдено.\nПопробуйте изменить параметры поиска.'**
  String emptyNoSearchResults(String query);

  /// No description provided for @emptyNoNotificationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Нет уведомлений'**
  String get emptyNoNotificationsTitle;

  /// No description provided for @emptyNoNotificationsMessage.
  ///
  /// In ru, this message translates to:
  /// **'У вас пока нет уведомлений.\nНовые уведомления появятся здесь.'**
  String get emptyNoNotificationsMessage;

  /// No description provided for @emptyHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История пуста'**
  String get emptyHistoryTitle;

  /// No description provided for @emptyHistoryMessage.
  ///
  /// In ru, this message translates to:
  /// **'История операций появится\nпосле первых действий.'**
  String get emptyHistoryMessage;

  /// No description provided for @emptyNoScheduleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Нет расписания'**
  String get emptyNoScheduleTitle;

  /// No description provided for @emptyNoScheduleMessage.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте записи расписания\nдля автоматического управления'**
  String get emptyNoScheduleMessage;

  /// No description provided for @errorOccurred.
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка'**
  String get errorOccurred;

  /// No description provided for @scheduleAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get scheduleAdd;

  /// No description provided for @scheduleNewEntry.
  ///
  /// In ru, this message translates to:
  /// **'Новая запись'**
  String get scheduleNewEntry;

  /// No description provided for @scheduleEditEntry.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать запись'**
  String get scheduleEditEntry;

  /// No description provided for @scheduleDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить запись?'**
  String get scheduleDeleteConfirm;

  /// No description provided for @scheduleDeleteMessage.
  ///
  /// In ru, this message translates to:
  /// **'Запись «{entry}» будет удалена.'**
  String scheduleDeleteMessage(String entry);

  /// No description provided for @scheduleDayLabel.
  ///
  /// In ru, this message translates to:
  /// **'День недели'**
  String get scheduleDayLabel;

  /// No description provided for @scheduleStartLabel.
  ///
  /// In ru, this message translates to:
  /// **'Начало'**
  String get scheduleStartLabel;

  /// No description provided for @scheduleEndLabel.
  ///
  /// In ru, this message translates to:
  /// **'Конец'**
  String get scheduleEndLabel;

  /// No description provided for @scheduleModeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Режим'**
  String get scheduleModeLabel;

  /// No description provided for @scheduleDayTemp.
  ///
  /// In ru, this message translates to:
  /// **'Дневная температура'**
  String get scheduleDayTemp;

  /// No description provided for @scheduleNightTemp.
  ///
  /// In ru, this message translates to:
  /// **'Ночная температура'**
  String get scheduleNightTemp;

  /// No description provided for @scheduleActive.
  ///
  /// In ru, this message translates to:
  /// **'Активно'**
  String get scheduleActive;

  /// No description provided for @scheduleDayNightTemp.
  ///
  /// In ru, this message translates to:
  /// **'День: {day}° / Ночь: {night}°'**
  String scheduleDayNightTemp(int day, int night);

  /// No description provided for @modeCooling.
  ///
  /// In ru, this message translates to:
  /// **'Охлаждение'**
  String get modeCooling;

  /// No description provided for @modeHeating.
  ///
  /// In ru, this message translates to:
  /// **'Нагрев'**
  String get modeHeating;

  /// No description provided for @modeVentilation.
  ///
  /// In ru, this message translates to:
  /// **'Вентиляция'**
  String get modeVentilation;

  /// No description provided for @statusOnline.
  ///
  /// In ru, this message translates to:
  /// **'Онлайн'**
  String get statusOnline;

  /// No description provided for @statusOffline.
  ///
  /// In ru, this message translates to:
  /// **'Оффлайн'**
  String get statusOffline;

  /// No description provided for @statusRunning.
  ///
  /// In ru, this message translates to:
  /// **'В работе'**
  String get statusRunning;

  /// No description provided for @statusStopped.
  ///
  /// In ru, this message translates to:
  /// **'Выключен'**
  String get statusStopped;

  /// No description provided for @statusEnabled.
  ///
  /// In ru, this message translates to:
  /// **'Включено'**
  String get statusEnabled;

  /// No description provided for @statusDisabled.
  ///
  /// In ru, this message translates to:
  /// **'Выключено'**
  String get statusDisabled;

  /// No description provided for @holdToToggle.
  ///
  /// In ru, this message translates to:
  /// **'Удерживайте для активации дня'**
  String get holdToToggle;

  /// No description provided for @selectTime.
  ///
  /// In ru, this message translates to:
  /// **'Выбор времени'**
  String get selectTime;

  /// No description provided for @setDateTime.
  ///
  /// In ru, this message translates to:
  /// **'Установить дату и время'**
  String get setDateTime;

  /// No description provided for @confirm.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get confirm;

  /// No description provided for @statusResolved.
  ///
  /// In ru, this message translates to:
  /// **'РЕШЕНА'**
  String get statusResolved;

  /// No description provided for @statusActive.
  ///
  /// In ru, this message translates to:
  /// **'АКТИВНА'**
  String get statusActive;

  /// No description provided for @alarmHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История аварий'**
  String get alarmHistoryTitle;

  /// No description provided for @alarmHistoryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'История аварий пуста'**
  String get alarmHistoryEmpty;

  /// No description provided for @alarmNoAlarms.
  ///
  /// In ru, this message translates to:
  /// **'Аварий не зафиксировано'**
  String get alarmNoAlarms;

  /// No description provided for @alarmCodeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Код {code}'**
  String alarmCodeLabel(int code);

  /// No description provided for @alarmOccurredAt.
  ///
  /// In ru, this message translates to:
  /// **'Возникла'**
  String get alarmOccurredAt;

  /// No description provided for @alarmClearedAt.
  ///
  /// In ru, this message translates to:
  /// **'Устранена'**
  String get alarmClearedAt;

  /// Reset alarms button label
  ///
  /// In ru, this message translates to:
  /// **'Сброс'**
  String get alarmReset;

  /// No description provided for @janShort.
  ///
  /// In ru, this message translates to:
  /// **'янв'**
  String get janShort;

  /// No description provided for @febShort.
  ///
  /// In ru, this message translates to:
  /// **'фев'**
  String get febShort;

  /// No description provided for @marShort.
  ///
  /// In ru, this message translates to:
  /// **'мар'**
  String get marShort;

  /// No description provided for @aprShort.
  ///
  /// In ru, this message translates to:
  /// **'апр'**
  String get aprShort;

  /// No description provided for @mayShort.
  ///
  /// In ru, this message translates to:
  /// **'май'**
  String get mayShort;

  /// No description provided for @junShort.
  ///
  /// In ru, this message translates to:
  /// **'июн'**
  String get junShort;

  /// No description provided for @julShort.
  ///
  /// In ru, this message translates to:
  /// **'июл'**
  String get julShort;

  /// No description provided for @augShort.
  ///
  /// In ru, this message translates to:
  /// **'авг'**
  String get augShort;

  /// No description provided for @sepShort.
  ///
  /// In ru, this message translates to:
  /// **'сен'**
  String get sepShort;

  /// No description provided for @octShort.
  ///
  /// In ru, this message translates to:
  /// **'окт'**
  String get octShort;

  /// No description provided for @novShort.
  ///
  /// In ru, this message translates to:
  /// **'ноя'**
  String get novShort;

  /// No description provided for @decShort.
  ///
  /// In ru, this message translates to:
  /// **'дек'**
  String get decShort;

  /// No description provided for @notificationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notificationsTitle;

  /// No description provided for @notificationsReadAll.
  ///
  /// In ru, this message translates to:
  /// **'Все уведомления прочитаны'**
  String get notificationsReadAll;

  /// No description provided for @notificationDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Уведомление удалено'**
  String get notificationDeleted;

  /// No description provided for @unitSettingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Настройки установки'**
  String get unitSettingsTitle;

  /// No description provided for @unitSettingsName.
  ///
  /// In ru, this message translates to:
  /// **'Название:'**
  String get unitSettingsName;

  /// No description provided for @unitSettingsStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус:'**
  String get unitSettingsStatus;

  /// No description provided for @unitSettingsNewName.
  ///
  /// In ru, this message translates to:
  /// **'Новое название'**
  String get unitSettingsNewName;

  /// No description provided for @unitSettingsEnterName.
  ///
  /// In ru, this message translates to:
  /// **'Введите название'**
  String get unitSettingsEnterName;

  /// No description provided for @unitSettingsRename.
  ///
  /// In ru, this message translates to:
  /// **'Переименовать'**
  String get unitSettingsRename;

  /// No description provided for @unitSettingsRenameSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Изменить название установки'**
  String get unitSettingsRenameSubtitle;

  /// No description provided for @unitSettingsDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить установку'**
  String get unitSettingsDelete;

  /// No description provided for @unitSettingsDeleteSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Отвязать устройство от аккаунта'**
  String get unitSettingsDeleteSubtitle;

  /// No description provided for @unitSettingsDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Удалить установку?'**
  String get unitSettingsDeleteConfirm;

  /// No description provided for @unitSettingsDeleteMessage.
  ///
  /// In ru, this message translates to:
  /// **'Установка «{name}» будет отвязана от вашего аккаунта. Вы сможете снова добавить её по MAC-адресу.'**
  String unitSettingsDeleteMessage(String name);

  /// No description provided for @unitSettingsSetTime.
  ///
  /// In ru, this message translates to:
  /// **'Установить время'**
  String get unitSettingsSetTime;

  /// No description provided for @updateAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступна новая версия'**
  String get updateAvailable;

  /// No description provided for @updateVersionAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Доступна версия {version}'**
  String updateVersionAvailable(String version);

  /// No description provided for @updateMessage.
  ///
  /// In ru, this message translates to:
  /// **'Вышло обновление приложения. Перезагрузите страницу, чтобы получить новые функции и исправления.'**
  String get updateMessage;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In ru, this message translates to:
  /// **'ПОДТВЕРЖДЕНИЕ EMAIL'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSent.
  ///
  /// In ru, this message translates to:
  /// **'Мы отправили 6-значный код подтверждения на'**
  String get verifyEmailSent;

  /// No description provided for @verifyEmailResend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить код повторно'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailCodeSent.
  ///
  /// In ru, this message translates to:
  /// **'Код отправлен на email'**
  String get verifyEmailCodeSent;

  /// No description provided for @tooltipEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get tooltipEdit;

  /// No description provided for @tooltipDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get tooltipDelete;

  /// No description provided for @tooltipAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get tooltipAdd;

  /// No description provided for @dataResource.
  ///
  /// In ru, this message translates to:
  /// **'данные'**
  String get dataResource;

  /// No description provided for @defaultUserName.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get defaultUserName;

  /// Heating label for temperature control
  ///
  /// In ru, this message translates to:
  /// **'Нагрев'**
  String get heating;

  /// Cooling label for temperature control
  ///
  /// In ru, this message translates to:
  /// **'Охлаждение'**
  String get cooling;

  /// No description provided for @outdoorTemp.
  ///
  /// In ru, this message translates to:
  /// **'Температура уличного воздуха'**
  String get outdoorTemp;

  /// No description provided for @indoorTemp.
  ///
  /// In ru, this message translates to:
  /// **'Температура воздуха в помещении'**
  String get indoorTemp;

  /// No description provided for @supplyTempAfterRecup.
  ///
  /// In ru, this message translates to:
  /// **'Температура приточного воздуха после рекуператора'**
  String get supplyTempAfterRecup;

  /// No description provided for @supplyTemp.
  ///
  /// In ru, this message translates to:
  /// **'Температура приточного воздуха'**
  String get supplyTemp;

  /// No description provided for @co2Level.
  ///
  /// In ru, this message translates to:
  /// **'Концентрация CO2'**
  String get co2Level;

  /// No description provided for @recuperatorEfficiency.
  ///
  /// In ru, this message translates to:
  /// **'Температурная эффективность рекуператора'**
  String get recuperatorEfficiency;

  /// No description provided for @freeCooling.
  ///
  /// In ru, this message translates to:
  /// **'Свободное охлаждение рекуператора'**
  String get freeCooling;

  /// No description provided for @heaterPerformance.
  ///
  /// In ru, this message translates to:
  /// **'Текущая производительность электрического нагревателя'**
  String get heaterPerformance;

  /// No description provided for @coolerStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус охладителя'**
  String get coolerStatus;

  /// No description provided for @ductPressure.
  ///
  /// In ru, this message translates to:
  /// **'Текущее значение давления в воздуховоде'**
  String get ductPressure;

  /// No description provided for @relativeHumidity.
  ///
  /// In ru, this message translates to:
  /// **'Относительная влажность'**
  String get relativeHumidity;

  /// No description provided for @outdoor.
  ///
  /// In ru, this message translates to:
  /// **'Улица'**
  String get outdoor;

  /// No description provided for @indoor.
  ///
  /// In ru, this message translates to:
  /// **'Помещение'**
  String get indoor;

  /// No description provided for @afterRecup.
  ///
  /// In ru, this message translates to:
  /// **'После рекуп.'**
  String get afterRecup;

  /// No description provided for @supply.
  ///
  /// In ru, this message translates to:
  /// **'Приток'**
  String get supply;

  /// No description provided for @efficiency.
  ///
  /// In ru, this message translates to:
  /// **'КПД'**
  String get efficiency;

  /// No description provided for @freeCool.
  ///
  /// In ru, this message translates to:
  /// **'Охл. рекуп.'**
  String get freeCool;

  /// No description provided for @on.
  ///
  /// In ru, this message translates to:
  /// **'ВКЛ'**
  String get on;

  /// No description provided for @off.
  ///
  /// In ru, this message translates to:
  /// **'ВЫКЛ'**
  String get off;

  /// No description provided for @heater.
  ///
  /// In ru, this message translates to:
  /// **'Нагреватель'**
  String get heater;

  /// No description provided for @cooler.
  ///
  /// In ru, this message translates to:
  /// **'Охладитель'**
  String get cooler;

  /// No description provided for @pressure.
  ///
  /// In ru, this message translates to:
  /// **'Давление'**
  String get pressure;

  /// No description provided for @noDeviceSelected.
  ///
  /// In ru, this message translates to:
  /// **'Устройство не выбрано'**
  String get noDeviceSelected;

  /// No description provided for @modes.
  ///
  /// In ru, this message translates to:
  /// **'Режимы'**
  String get modes;

  /// No description provided for @modeBasic.
  ///
  /// In ru, this message translates to:
  /// **'Базовый'**
  String get modeBasic;

  /// No description provided for @modeIntensive.
  ///
  /// In ru, this message translates to:
  /// **'Интенсив'**
  String get modeIntensive;

  /// No description provided for @modeEconomy.
  ///
  /// In ru, this message translates to:
  /// **'Эконом'**
  String get modeEconomy;

  /// No description provided for @modeMaxPerformance.
  ///
  /// In ru, this message translates to:
  /// **'Макс.'**
  String get modeMaxPerformance;

  /// No description provided for @modeKitchen.
  ///
  /// In ru, this message translates to:
  /// **'Кухня'**
  String get modeKitchen;

  /// No description provided for @modeFireplace.
  ///
  /// In ru, this message translates to:
  /// **'Камин'**
  String get modeFireplace;

  /// No description provided for @modeVacation.
  ///
  /// In ru, this message translates to:
  /// **'Отпуск'**
  String get modeVacation;

  /// No description provided for @modeCustom.
  ///
  /// In ru, this message translates to:
  /// **'Свой'**
  String get modeCustom;

  /// No description provided for @controls.
  ///
  /// In ru, this message translates to:
  /// **'Управление'**
  String get controls;

  /// No description provided for @sensors.
  ///
  /// In ru, this message translates to:
  /// **'Датчики'**
  String get sensors;

  /// No description provided for @temperatureSetpoints.
  ///
  /// In ru, this message translates to:
  /// **'Уставки температуры'**
  String get temperatureSetpoints;

  /// No description provided for @fanSpeed.
  ///
  /// In ru, this message translates to:
  /// **'Скорость вентиляторов'**
  String get fanSpeed;

  /// No description provided for @status.
  ///
  /// In ru, this message translates to:
  /// **'Статус'**
  String get status;

  /// No description provided for @seeAll.
  ///
  /// In ru, this message translates to:
  /// **'Показать всё'**
  String get seeAll;

  /// No description provided for @outdoorTempDesc.
  ///
  /// In ru, this message translates to:
  /// **'Температура воздуха снаружи здания'**
  String get outdoorTempDesc;

  /// No description provided for @indoorTempDesc.
  ///
  /// In ru, this message translates to:
  /// **'Температура воздуха внутри помещения'**
  String get indoorTempDesc;

  /// No description provided for @supplyTempAfterRecupDesc.
  ///
  /// In ru, this message translates to:
  /// **'Температура приточного воздуха после теплообмена в рекуператоре'**
  String get supplyTempAfterRecupDesc;

  /// No description provided for @supplyTempDesc.
  ///
  /// In ru, this message translates to:
  /// **'Температура воздуха на выходе из вентиляционной установки'**
  String get supplyTempDesc;

  /// No description provided for @co2LevelDesc.
  ///
  /// In ru, this message translates to:
  /// **'Уровень углекислого газа в помещении. Норма: до 1000 ppm'**
  String get co2LevelDesc;

  /// No description provided for @recuperatorEfficiencyDesc.
  ///
  /// In ru, this message translates to:
  /// **'Эффективность теплообмена в рекуператоре'**
  String get recuperatorEfficiencyDesc;

  /// No description provided for @freeCoolingDesc.
  ///
  /// In ru, this message translates to:
  /// **'Режим бесплатного охлаждения наружным воздухом через рекуператор'**
  String get freeCoolingDesc;

  /// No description provided for @heaterPerformanceDesc.
  ///
  /// In ru, this message translates to:
  /// **'Текущая мощность электрического нагревателя'**
  String get heaterPerformanceDesc;

  /// No description provided for @coolerStatusDesc.
  ///
  /// In ru, this message translates to:
  /// **'Статус работы охладителя воздуха'**
  String get coolerStatusDesc;

  /// No description provided for @ductPressureDesc.
  ///
  /// In ru, this message translates to:
  /// **'Давление воздуха в воздуховоде (Па)'**
  String get ductPressureDesc;

  /// No description provided for @humidityDesc.
  ///
  /// In ru, this message translates to:
  /// **'Относительная влажность воздуха в помещении'**
  String get humidityDesc;

  /// No description provided for @unitPoweredOn.
  ///
  /// In ru, this message translates to:
  /// **'включен'**
  String get unitPoweredOn;

  /// No description provided for @unitPoweredOff.
  ///
  /// In ru, this message translates to:
  /// **'выключен'**
  String get unitPoweredOff;

  /// No description provided for @unitSelected.
  ///
  /// In ru, this message translates to:
  /// **'выбран'**
  String get unitSelected;

  /// No description provided for @devicesList.
  ///
  /// In ru, this message translates to:
  /// **'Список устройств'**
  String get devicesList;

  /// No description provided for @segmentSelection.
  ///
  /// In ru, this message translates to:
  /// **'Выбор сегмента'**
  String get segmentSelection;

  /// No description provided for @noEntriesForDay.
  ///
  /// In ru, this message translates to:
  /// **'Нет записей на {day}'**
  String noEntriesForDay(String day);

  /// No description provided for @tapToAdd.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите, чтобы добавить'**
  String get tapToAdd;

  /// No description provided for @quickSensorsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Показатели на главной'**
  String get quickSensorsTitle;

  /// No description provided for @quickSensorsHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите на показатель, чтобы заменить'**
  String get quickSensorsHint;

  /// No description provided for @sensorInteractionHint.
  ///
  /// In ru, this message translates to:
  /// **'Нажмите для описания • Зажмите для выбора'**
  String get sensorInteractionHint;

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @eventLogs.
  ///
  /// In ru, this message translates to:
  /// **'Журнал событий'**
  String get eventLogs;

  /// No description provided for @eventLogsDescription.
  ///
  /// In ru, this message translates to:
  /// **'История изменений настроек устройства'**
  String get eventLogsDescription;

  /// No description provided for @logColumnTime.
  ///
  /// In ru, this message translates to:
  /// **'Время'**
  String get logColumnTime;

  /// No description provided for @logColumnType.
  ///
  /// In ru, this message translates to:
  /// **'Тип'**
  String get logColumnType;

  /// No description provided for @logColumnCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get logColumnCategory;

  /// No description provided for @logColumnProperty.
  ///
  /// In ru, this message translates to:
  /// **'Параметр'**
  String get logColumnProperty;

  /// No description provided for @logColumnOldValue.
  ///
  /// In ru, this message translates to:
  /// **'Было'**
  String get logColumnOldValue;

  /// No description provided for @logColumnNewValue.
  ///
  /// In ru, this message translates to:
  /// **'Стало'**
  String get logColumnNewValue;

  /// No description provided for @logColumnDescription.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get logColumnDescription;

  /// No description provided for @logTypeSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройка'**
  String get logTypeSettings;

  /// No description provided for @logTypeAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Авария'**
  String get logTypeAlarm;

  /// No description provided for @filterAll.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get filterAll;

  /// No description provided for @logCategoryMode.
  ///
  /// In ru, this message translates to:
  /// **'Режим'**
  String get logCategoryMode;

  /// No description provided for @logCategoryTimer.
  ///
  /// In ru, this message translates to:
  /// **'Таймер'**
  String get logCategoryTimer;

  /// No description provided for @logCategoryAlarm.
  ///
  /// In ru, this message translates to:
  /// **'Авария'**
  String get logCategoryAlarm;

  /// No description provided for @logNoData.
  ///
  /// In ru, this message translates to:
  /// **'Нет записей'**
  String get logNoData;

  /// No description provided for @logNoDataHint.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте изменить фильтр'**
  String get logNoDataHint;

  /// No description provided for @logLoadMore.
  ///
  /// In ru, this message translates to:
  /// **'Загрузить ещё'**
  String get logLoadMore;

  /// No description provided for @logShowing.
  ///
  /// In ru, this message translates to:
  /// **'Показано: {count} из {total}'**
  String logShowing(int count, int total);

  /// No description provided for @logPage.
  ///
  /// In ru, this message translates to:
  /// **'Страница {current} из {total}'**
  String logPage(int current, int total);

  /// No description provided for @serviceEngineer.
  ///
  /// In ru, this message translates to:
  /// **'Сервис'**
  String get serviceEngineer;

  /// Session expired toast message
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла. Выполняется выход...'**
  String get sessionExpired;
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
