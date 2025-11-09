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
    Locale('en')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'BREEZ Home'**
  String get appTitle;

  /// Application tagline
  ///
  /// In en, this message translates to:
  /// **'Smart Climate Management'**
  String get smartClimateManagement;

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

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Create account title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// Sign up subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up for a new account'**
  String get signUpForAccount;

  /// Skip authentication button
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// Skip authentication button alternative
  ///
  /// In en, this message translates to:
  /// **'Continue without registration'**
  String get skipAuth;

  /// Remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Terms and conditions link
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Guest user name
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// Registration coming soon message
  ///
  /// In en, this message translates to:
  /// **'Registration feature coming soon'**
  String get registrationComingSoon;

  /// Show password tooltip
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Hide password tooltip
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Onboarding welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nBREEZ Home'**
  String get welcomeToBreezHome;

  /// Onboarding welcome subtitle
  ///
  /// In en, this message translates to:
  /// **'Your smart home climate control\nat your fingertips'**
  String get smartHomeClimateControl;

  /// Swipe instruction
  ///
  /// In en, this message translates to:
  /// **'Swipe to continue'**
  String get swipeToContinue;

  /// Onboarding control title
  ///
  /// In en, this message translates to:
  /// **'Control Your\nDevices'**
  String get controlYourDevices;

  /// Onboarding control subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage all your HVAC systems\nfrom anywhere, anytime'**
  String get manageHvacSystems;

  /// Remote control feature
  ///
  /// In en, this message translates to:
  /// **'Turn on/off remotely'**
  String get turnOnOffRemotely;

  /// Onboarding final title
  ///
  /// In en, this message translates to:
  /// **'Ready to\nGet Started?'**
  String get readyToGetStarted;

  /// Onboarding final subtitle
  ///
  /// In en, this message translates to:
  /// **'Start controlling your home climate\nwith ease and efficiency'**
  String get startControllingClimate;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Terms and privacy agreement text
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our\nTerms of Service and Privacy Policy'**
  String get termsPrivacyAgreement;

  /// Loading screen text
  ///
  /// In en, this message translates to:
  /// **'Loading BREEZ Home'**
  String get loadingBreezHome;

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

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Navigate back label
  ///
  /// In en, this message translates to:
  /// **'Navigate back'**
  String get navigateBack;

  /// Settings screen title (Russian: Настройки)
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Appearance section title (Russian: Внешний вид)
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Dark theme option (Russian: Темная тема)
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Dark theme description (Russian: Использовать темную цветовую схему)
  ///
  /// In en, this message translates to:
  /// **'Use dark color scheme'**
  String get useDarkColorScheme;

  /// Theme change message (Russian: Смена темы будет доступна в следующей версии)
  ///
  /// In en, this message translates to:
  /// **'Theme change will be available in the next version'**
  String get themeChangeNextVersion;

  /// Units section title (Russian: Единицы измерения)
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// Temperature units label (Russian: Температура)
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureUnits;

  /// Celsius option (Russian: Цельсий (°C))
  ///
  /// In en, this message translates to:
  /// **'Celsius (°C)'**
  String get celsius;

  /// Fahrenheit option (Russian: Фаренгейт (°F))
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit (°F)'**
  String get fahrenheit;

  /// Units changed message
  ///
  /// In en, this message translates to:
  /// **'Units changed to {unit}'**
  String unitsChangedTo(String unit);

  /// Notifications section (Russian: Уведомления)
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Push notifications option (Russian: Push-уведомления)
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Push notifications description (Russian: Получать мгновенные уведомления)
  ///
  /// In en, this message translates to:
  /// **'Receive instant notifications'**
  String get receiveInstantNotifications;

  /// Email notifications option (Russian: Email-уведомления)
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Email notifications description (Russian: Получать отчеты на email)
  ///
  /// In en, this message translates to:
  /// **'Receive reports via email'**
  String get receiveEmailReports;

  /// Notifications state message
  ///
  /// In en, this message translates to:
  /// **'{type} notifications {state}'**
  String notificationsState(String type, String state);

  /// Language section (Russian: Язык)
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Russian language option
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Language changed message
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(String language);

  /// About section (Russian: О приложении)
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label (Russian: Версия)
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Developer label (Russian: Разработчик)
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// License label (Russian: Лицензия)
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// Check updates button (Russian: Проверить обновления)
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkUpdates;

  /// Checking updates message (Russian: Проверка обновлений...)
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingUpdates;

  /// Device management screen title
  ///
  /// In en, this message translates to:
  /// **'Device Management'**
  String get deviceManagement;

  /// Search title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Scan for devices button
  ///
  /// In en, this message translates to:
  /// **'Scan for Devices'**
  String get scanForDevices;

  /// Add device button
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// Edit device dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get editDevice;

  /// Remove device button
  ///
  /// In en, this message translates to:
  /// **'Remove Device'**
  String get removeDevice;

  /// Device name label
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// MAC address label
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Device not found message
  ///
  /// In en, this message translates to:
  /// **'Not found\ndevice?'**
  String get notFoundDevice;

  /// Select device manually button
  ///
  /// In en, this message translates to:
  /// **'Select manually'**
  String get selectManually;

  /// Device updated message
  ///
  /// In en, this message translates to:
  /// **'Device updated'**
  String get deviceUpdated;

  /// Device added success message
  ///
  /// In en, this message translates to:
  /// **'Device added successfully'**
  String get deviceAdded;

  /// Device removed success message
  ///
  /// In en, this message translates to:
  /// **'Device removed successfully'**
  String get deviceRemoved;

  /// Scan QR code button
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// Processing QR code message
  ///
  /// In en, this message translates to:
  /// **'Processing QR Code...'**
  String get processingQrCode;

  /// Invalid QR code error
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code'**
  String get invalidQrCode;

  /// Device detected from QR message
  ///
  /// In en, this message translates to:
  /// **'Device detected from QR code'**
  String get deviceDetectedFromQr;

  /// Manual MAC entry option
  ///
  /// In en, this message translates to:
  /// **'Or enter MAC address manually'**
  String get enterMacManually;

  /// Invalid MAC format error
  ///
  /// In en, this message translates to:
  /// **'Invalid MAC address format (e.g., AA:BB:CC:DD:EE:FF)'**
  String get invalidMacFormat;

  /// Device name validation error
  ///
  /// In en, this message translates to:
  /// **'Device name must be at least 3 characters'**
  String get deviceNameMinLength;

  /// Adding in progress
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// Pull to refresh hint
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// Online status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm device removal
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name}?'**
  String confirmRemoveDevice(String name);

  /// WiFi network display
  ///
  /// In en, this message translates to:
  /// **'WiFi: {network}'**
  String wifiNetwork(String network);

  /// Main screen title
  ///
  /// In en, this message translates to:
  /// **'BREEZ Home'**
  String get hvacControl;

  /// Temperature label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Humidity label
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// Air quality label
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQuality;

  /// Fan speed label
  ///
  /// In en, this message translates to:
  /// **'Fan Speed'**
  String get fanSpeed;

  /// Fan label short
  ///
  /// In en, this message translates to:
  /// **'Fan'**
  String get fan;

  /// Mode label
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// Operating mode title
  ///
  /// In en, this message translates to:
  /// **'Operating Mode'**
  String get operatingMode;

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

  /// Current label
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String current(Object temp);

  /// Target label
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

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

  /// Low speed
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Password strength
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// High speed
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Mode 2 label
  ///
  /// In en, this message translates to:
  /// **'Mode 2'**
  String get mode2;

  /// Humidifier air label
  ///
  /// In en, this message translates to:
  /// **'Humidifier\nAir'**
  String get humidifierAir;

  /// Purifier air label
  ///
  /// In en, this message translates to:
  /// **'Purifier\nAir'**
  String get purifierAir;

  /// Lighting section
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get lighting;

  /// Main light label
  ///
  /// In en, this message translates to:
  /// **'Main light'**
  String get mainLight;

  /// Floor lamp label
  ///
  /// In en, this message translates to:
  /// **'Floor lamp'**
  String get floorLamp;

  /// Unit label
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// Notifications coming soon message
  ///
  /// In en, this message translates to:
  /// **'Notifications feature coming soon'**
  String get notificationsComingSoon;

  /// Favorite action
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// Activity label
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// See all button
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Excellent air quality
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// Good air quality
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Moderate air quality
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// Poor air quality
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// Very poor air quality
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get veryPoor;

  /// Quick actions title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Turn all devices on
  ///
  /// In en, this message translates to:
  /// **'All On'**
  String get allOn;

  /// Turn all devices off
  ///
  /// In en, this message translates to:
  /// **'All Off'**
  String get allOff;

  /// Sync devices
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// Schedule button
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Presets title
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get presets;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String error(Object message);

  /// Connection error title
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Server error title
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// Permission required title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get somethingWentWrong;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection.'**
  String get unableToConnect;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get serverErrorMessage;

  /// Permission required message
  ///
  /// In en, this message translates to:
  /// **'This feature requires additional permissions to work properly.'**
  String get permissionRequiredMessage;

  /// Network connection failed
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please check your internet connection.'**
  String get networkConnectionFailed;

  /// Request timeout error
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get requestTimedOut;

  /// Device server connection error
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to device server'**
  String get failedToConnect;

  /// Connection failed with error
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailed(String error);

  /// Failed to add device
  ///
  /// In en, this message translates to:
  /// **'Failed to add device: {error}'**
  String failedToAddDevice(String error);

  /// Failed to remove device
  ///
  /// In en, this message translates to:
  /// **'Failed to remove device: {error}'**
  String failedToRemoveDevice(String error);

  /// Failed to load more items
  ///
  /// In en, this message translates to:
  /// **'Failed to load more items: {error}'**
  String failedToLoadMore(String error);

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Retry connection button
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// Refreshing message
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// Refresh devices tooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh Devices'**
  String get refreshDevices;

  /// Retrying connection announcement
  ///
  /// In en, this message translates to:
  /// **'Retrying connection'**
  String get retryingConnection;

  /// Error code display
  ///
  /// In en, this message translates to:
  /// **'Error Code: {code}'**
  String errorCode(String code);

  /// Error code copied message
  ///
  /// In en, this message translates to:
  /// **'Error code copied to clipboard'**
  String get errorCodeCopied;

  /// Technical details label
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get technicalDetails;

  /// Double tap to retry hint
  ///
  /// In en, this message translates to:
  /// **'Double tap to retry'**
  String get doubleTapToRetry;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Loading devices message
  ///
  /// In en, this message translates to:
  /// **'Loading devices...'**
  String get loadingDevices;

  /// All units loaded message
  ///
  /// In en, this message translates to:
  /// **'All units loaded'**
  String get allUnitsLoaded;

  /// Connecting message
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Reconnecting message
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get reconnecting;

  /// No devices title
  ///
  /// In en, this message translates to:
  /// **'No Devices'**
  String get noDevices;

  /// No devices found message
  ///
  /// In en, this message translates to:
  /// **'No Devices Found'**
  String get noDevicesFound;

  /// Add first device prompt
  ///
  /// In en, this message translates to:
  /// **'Add your first device to get started'**
  String get addFirstDevice;

  /// MQTT settings help text
  ///
  /// In en, this message translates to:
  /// **'Check your MQTT connection settings\nand make sure devices are online'**
  String get checkMqttSettings;

  /// No device selected message
  ///
  /// In en, this message translates to:
  /// **'No device selected'**
  String get deviceNotSelected;

  /// Opening device addition announcement
  ///
  /// In en, this message translates to:
  /// **'Opening device addition screen'**
  String get openDeviceAddition;

  /// Camera initialization message
  ///
  /// In en, this message translates to:
  /// **'Initializing camera...'**
  String get initializingCamera;

  /// Camera permission message
  ///
  /// In en, this message translates to:
  /// **'Camera access is required to scan QR codes.\nPlease enable camera permissions in your browser settings.'**
  String get cameraAccessRequired;

  /// Camera error title
  ///
  /// In en, this message translates to:
  /// **'Camera Error'**
  String get cameraError;

  /// Camera error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while accessing the camera.'**
  String get cameraErrorMessage;

  /// Web camera setup message
  ///
  /// In en, this message translates to:
  /// **'Web camera scanning requires additional setup. Please use manual entry or scan from mobile device.'**
  String get webCameraSetupRequired;

  /// Camera view label
  ///
  /// In en, this message translates to:
  /// **'Camera View'**
  String get cameraView;

  /// Email required validation
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Invalid email validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password required validation
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password too short validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {length} characters'**
  String passwordTooShort(int length);

  /// Name required validation
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String nameRequired(String fieldName);

  /// Name too short validation
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must be at least 2 characters'**
  String nameTooShort(String fieldName);

  /// Fill required fields message
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillRequiredFields;

  /// Accept terms validation
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and conditions'**
  String get pleaseAcceptTerms;

  /// Minimum characters hint
  ///
  /// In en, this message translates to:
  /// **'Min {count} characters'**
  String minCharacters(int count);

  /// Password requirement
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Characters;

  /// Password requirement
  ///
  /// In en, this message translates to:
  /// **'Uppercase letter'**
  String get uppercaseLetter;

  /// Password requirement
  ///
  /// In en, this message translates to:
  /// **'Lowercase letter'**
  String get lowercaseLetter;

  /// Password requirement
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// Password requirement
  ///
  /// In en, this message translates to:
  /// **'Special character'**
  String get specialCharacter;

  /// Password strength
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// Password strength
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// Password strength
  ///
  /// In en, this message translates to:
  /// **'Very Strong'**
  String get veryStrong;

  /// Edit schedule semantic label
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String editSchedule(String name);

  /// Delete schedule semantic label
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String deleteSchedule(String name);

  /// Edit schedule tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editScheduleTooltip;

  /// Delete schedule tooltip
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get deleteScheduleTooltip;

  /// Success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Settings saved message
  ///
  /// In en, this message translates to:
  /// **'Settings saved. Restart app to apply changes.'**
  String get settingsSaved;

  /// Preset applied message
  ///
  /// In en, this message translates to:
  /// **'Preset applied'**
  String get presetApplied;

  /// All units on message
  ///
  /// In en, this message translates to:
  /// **'All units turned on'**
  String get allUnitsOn;

  /// All units off message
  ///
  /// In en, this message translates to:
  /// **'All units turned off'**
  String get allUnitsOff;

  /// Settings synced message
  ///
  /// In en, this message translates to:
  /// **'Settings synced to all units'**
  String get settingsSynced;

  /// Schedule applied message
  ///
  /// In en, this message translates to:
  /// **'Schedule applied to all units'**
  String get scheduleAppliedToAll;

  /// Power change error
  ///
  /// In en, this message translates to:
  /// **'Error changing power'**
  String get errorChangingPower;

  /// Mode update error
  ///
  /// In en, this message translates to:
  /// **'Error updating mode'**
  String get errorUpdatingMode;

  /// Fan speed update error
  ///
  /// In en, this message translates to:
  /// **'Error updating fan speed'**
  String get errorUpdatingFanSpeed;

  /// Preset apply error
  ///
  /// In en, this message translates to:
  /// **'Error applying preset'**
  String get errorApplyingPreset;

  /// Turn on units error
  ///
  /// In en, this message translates to:
  /// **'Error turning on units'**
  String get errorTurningOnUnits;

  /// Turn off units error
  ///
  /// In en, this message translates to:
  /// **'Error turning off units'**
  String get errorTurningOffUnits;

  /// Settings sync error
  ///
  /// In en, this message translates to:
  /// **'Error syncing settings'**
  String get errorSyncingSettings;

  /// Schedule apply error
  ///
  /// In en, this message translates to:
  /// **'Error applying schedule'**
  String get errorApplyingSchedule;

  /// Connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Idle status
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// Active status
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Enabled status
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Available status
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Unavailable status
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Maintenance status
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// Activated state
  ///
  /// In en, this message translates to:
  /// **'activated'**
  String get activated;

  /// Deactivated state
  ///
  /// In en, this message translates to:
  /// **'deactivated'**
  String get deactivated;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort button
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Details label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// More label
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Less label
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// All label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// None label
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Optional field hint
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Required field hint
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Information label
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// Warning label
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Notification label
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Week label
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Month label
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Year label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Date format
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String date(String date);

  /// Manage rules button/message
  ///
  /// In en, this message translates to:
  /// **'Manage Rules (Coming Soon)'**
  String get manageRules;

  /// Manage rules coming soon
  ///
  /// In en, this message translates to:
  /// **'Manage Rules (Coming Soon)'**
  String get manageRulesComingSoon;

  /// Add unit coming soon
  ///
  /// In en, this message translates to:
  /// **'Add unit feature coming soon'**
  String get addUnitComingSoon;

  /// Living room name
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get livingRoom;

  /// Bedroom name
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get bedroom;

  /// Kitchen name
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// Vacuum cleaner device type
  ///
  /// In en, this message translates to:
  /// **'Vacuum cleaner'**
  String get vacuumCleaner;

  /// Smart bulb device type
  ///
  /// In en, this message translates to:
  /// **'Smart bulb'**
  String get smartBulb;

  /// Humidifier device type
  ///
  /// In en, this message translates to:
  /// **'Humidifier'**
  String get humidifier;

  /// Average label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

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

  /// Active devices count
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} active'**
  String activeDevices(int count, int total);

  /// Run diagnostics button
  ///
  /// In en, this message translates to:
  /// **'Run Diagnostics'**
  String get runDiagnostics;

  /// System health title
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get systemHealth;

  /// Supply fan component
  ///
  /// In en, this message translates to:
  /// **'Supply Fan'**
  String get supplyFan;

  /// Exhaust fan component
  ///
  /// In en, this message translates to:
  /// **'Exhaust Fan'**
  String get exhaustFan;

  /// Heater component
  ///
  /// In en, this message translates to:
  /// **'Heater'**
  String get heater;

  /// Heat recuperator
  ///
  /// In en, this message translates to:
  /// **'Recuperator'**
  String get recuperator;

  /// Sensors component
  ///
  /// In en, this message translates to:
  /// **'Sensors'**
  String get sensors;

  /// Normal status
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Sensor readings title
  ///
  /// In en, this message translates to:
  /// **'Sensor Readings'**
  String get sensorReadings;

  /// Supply air temperature
  ///
  /// In en, this message translates to:
  /// **'Supply Air Temperature'**
  String get supplyAirTemp;

  /// Outdoor temperature
  ///
  /// In en, this message translates to:
  /// **'Outdoor Temperature'**
  String get outdoorTemp;

  /// Pressure reading
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// Network connection title
  ///
  /// In en, this message translates to:
  /// **'Network Connection'**
  String get networkConnection;

  /// Network label
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Signal strength
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get signal;

  /// IP address label
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// Not connected status
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get notConnected;

  /// Not assigned status
  ///
  /// In en, this message translates to:
  /// **'Not Assigned'**
  String get notAssigned;

  /// Diagnostics title
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnosticsTitle;

  /// Diagnostics running message
  ///
  /// In en, this message translates to:
  /// **'Running system diagnostics...'**
  String get diagnosticsRunning;

  /// Diagnostics complete message
  ///
  /// In en, this message translates to:
  /// **'Diagnostics complete. System is normal.'**
  String get diagnosticsComplete;

  /// Schedule saved message
  ///
  /// In en, this message translates to:
  /// **'Schedule saved successfully'**
  String get scheduleSaved;

  /// Save error message
  ///
  /// In en, this message translates to:
  /// **'Save error: {error}'**
  String saveError(String error);

  /// Unsaved changes title
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// Unsaved changes confirmation
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Exit without saving?'**
  String get unsavedChangesMessage;

  /// Exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// New devices found
  ///
  /// In en, this message translates to:
  /// **'{count} new devices'**
  String devicesFound(int count);

  /// Single device found
  ///
  /// In en, this message translates to:
  /// **'{count} new device'**
  String deviceFound(int count);

  /// Device not found message
  ///
  /// In en, this message translates to:
  /// **'Not found\ndevice?'**
  String get notFoundDeviceTitle;

  /// Select manually button
  ///
  /// In en, this message translates to:
  /// **'Select manually'**
  String get selectManuallyButton;

  /// Devices added confirmation
  ///
  /// In en, this message translates to:
  /// **'{count} {plural} added'**
  String devicesAdded(int count, String plural);

  /// Device singular
  ///
  /// In en, this message translates to:
  /// **'device'**
  String get device;

  /// Devices plural
  ///
  /// In en, this message translates to:
  /// **'devices'**
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
      <String>['ru', 'en'].contains(locale.languageCode);

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
      'that was used.');
}
