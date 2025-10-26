import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('ru'),
    Locale('zh')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'HVAC Control'**
  String get appTitle;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Main screen title
  ///
  /// In en, this message translates to:
  /// **'HVAC Control'**
  String get hvacControl;

  /// Active devices count
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} active'**
  String activeDevices(int count, int total);

  /// Connection error title
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Retry connection button
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// No devices found message
  ///
  /// In en, this message translates to:
  /// **'No Devices Found'**
  String get noDevicesFound;

  /// MQTT connection help text
  ///
  /// In en, this message translates to:
  /// **'Check your MQTT connection settings\nand make sure devices are online'**
  String get checkMqttSettings;

  /// Loading devices message
  ///
  /// In en, this message translates to:
  /// **'Loading devices...'**
  String get loadingDevices;

  /// Power label
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// On state
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// Off state
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// Temperature label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Temperature slider description
  ///
  /// In en, this message translates to:
  /// **'Adjust target temperature'**
  String get adjustTargetTemperature;

  /// Device off message
  ///
  /// In en, this message translates to:
  /// **'Device is off'**
  String get deviceIsOff;

  /// Target temperature label
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// Current temperature
  ///
  /// In en, this message translates to:
  /// **'Current: {temp}°C'**
  String current(String temp);

  /// Current temperature label for chart legend
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentTemp;

  /// Minimum label
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// Maximum label
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// Operating mode title
  ///
  /// In en, this message translates to:
  /// **'Operating Mode'**
  String get operatingMode;

  /// Mode selector description
  ///
  /// In en, this message translates to:
  /// **'Select HVAC operating mode'**
  String get selectHvacMode;

  /// Cooling mode
  ///
  /// In en, this message translates to:
  /// **'Cooling'**
  String get cooling;

  /// Heating mode
  ///
  /// In en, this message translates to:
  /// **'Heating'**
  String get heating;

  /// Auto mode
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// Fan mode
  ///
  /// In en, this message translates to:
  /// **'Fan'**
  String get fan;

  /// Cooling mode description
  ///
  /// In en, this message translates to:
  /// **'Cool down to target temperature'**
  String get coolDownToTarget;

  /// Heating mode description
  ///
  /// In en, this message translates to:
  /// **'Heat up to target temperature'**
  String get heatUpToTarget;

  /// Auto mode description
  ///
  /// In en, this message translates to:
  /// **'Automatically adjust temperature'**
  String get autoAdjustTemperature;

  /// Fan mode description
  ///
  /// In en, this message translates to:
  /// **'Circulate air without heating/cooling'**
  String get circulateAir;

  /// Fan speed title
  ///
  /// In en, this message translates to:
  /// **'Fan Speed'**
  String get fanSpeed;

  /// Fan speed description
  ///
  /// In en, this message translates to:
  /// **'Adjust airflow intensity'**
  String get adjustAirflow;

  /// Low speed
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Medium speed
  ///
  /// In en, this message translates to:
  /// **'Med'**
  String get medium;

  /// High speed
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Low speed description
  ///
  /// In en, this message translates to:
  /// **'Gentle airflow for quiet operation'**
  String get gentleAirflow;

  /// Medium speed description
  ///
  /// In en, this message translates to:
  /// **'Balanced airflow and noise level'**
  String get balancedAirflow;

  /// High speed description
  ///
  /// In en, this message translates to:
  /// **'Maximum airflow for rapid cooling/heating'**
  String get maximumAirflow;

  /// Auto speed description
  ///
  /// In en, this message translates to:
  /// **'Automatically adjusts based on temperature'**
  String get autoAdjustSpeed;

  /// Power level label
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get powerLevel;

  /// Temperature history title
  ///
  /// In en, this message translates to:
  /// **'Temperature History'**
  String get temperatureHistory;

  /// Last 24 hours label
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours'**
  String get last24Hours;

  /// Average label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// Appearance section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Theme label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Russian language
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// Chinese language
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// Connection section title
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// MQTT settings label
  ///
  /// In en, this message translates to:
  /// **'MQTT Settings'**
  String get mqttSettings;

  /// MQTT settings description
  ///
  /// In en, this message translates to:
  /// **'Configure MQTT broker connection'**
  String get configureMqtt;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// HVAC unit title
  ///
  /// In en, this message translates to:
  /// **'HVAC Unit'**
  String get hvacUnit;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// Light theme mode text
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// Dark theme mode text
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// System default theme text
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// Toggle theme tooltip
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// MQTT broker label
  ///
  /// In en, this message translates to:
  /// **'MQTT Broker'**
  String get mqttBroker;

  /// Username label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Settings saved message
  ///
  /// In en, this message translates to:
  /// **'Settings saved. Restart app to apply changes.'**
  String get settingsSaved;

  /// About app label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutApp;

  /// Application description
  ///
  /// In en, this message translates to:
  /// **'Cross-platform HVAC management application with MQTT integration.'**
  String get appDescription;

  /// Device management screen title
  ///
  /// In en, this message translates to:
  /// **'Device Management'**
  String get deviceManagement;

  /// Add device button label
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// MAC address label
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// Device name label
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// Example room name
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get livingRoom;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Optional field hint
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Validation error for empty required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillRequiredFields;

  /// Success message when device is added
  ///
  /// In en, this message translates to:
  /// **'Device added successfully'**
  String get deviceAdded;

  /// Remove device dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove Device'**
  String get removeDevice;

  /// Confirmation message for removing device
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String confirmRemoveDevice(String name);

  /// Remove button label
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Success message when device is removed
  ///
  /// In en, this message translates to:
  /// **'Device removed successfully'**
  String get deviceRemoved;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Add button label
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Error message when trying to manage devices without MQTT
  ///
  /// In en, this message translates to:
  /// **'MQTT mode is required for device management'**
  String get mqttModeRequired;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Sign in to continue'**
  String get loginSubtitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Create an account to get started'**
  String get registerSubtitle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Invalid email error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password too short error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Name validation error
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Name too short error
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// Switch to register text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAccount;

  /// Switch to login text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// Scan QR code button
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// Manual MAC entry option
  ///
  /// In en, this message translates to:
  /// **'Or enter MAC address manually'**
  String get enterMacManually;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Skip authentication button
  ///
  /// In en, this message translates to:
  /// **'Continue without registration'**
  String get skipAuth;
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
      <String>['en', 'ru', 'zh'].contains(locale.languageCode);

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
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
