// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BREEZ Home';

  @override
  String get smartClimateManagement => 'Smart Climate Management';

  @override
  String get login => 'Sign In';

  @override
  String get register => 'Sign Up';

  @override
  String get loginSubtitle => 'Welcome back! Sign in to continue';

  @override
  String get registerSubtitle => 'Create an account to get started';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signInToAccount => 'Sign in to your account';

  @override
  String get signUpForAccount => 'Sign up for a new account';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get skipAuth => 'Continue without registration';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get guestUser => 'Guest User';

  @override
  String get registrationComingSoon => 'Registration feature coming soon';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get skip => 'Skip';

  @override
  String get welcomeToBreezHome => 'Welcome to\nBREEZ Home';

  @override
  String get smartHomeClimateControl =>
      'Your smart home climate control\nat your fingertips';

  @override
  String get swipeToContinue => 'Swipe to continue';

  @override
  String get controlYourDevices => 'Control Your\nDevices';

  @override
  String get manageHvacSystems =>
      'Manage all your HVAC systems\nfrom anywhere, anytime';

  @override
  String get turnOnOffRemotely => 'Turn on/off remotely';

  @override
  String get readyToGetStarted => 'Ready to\nGet Started?';

  @override
  String get startControllingClimate =>
      'Start controlling your home climate\nwith ease and efficiency';

  @override
  String get getStarted => 'Get Started';

  @override
  String get termsPrivacyAgreement =>
      'By continuing, you agree to our\nTerms of Service and Privacy Policy';

  @override
  String get loadingBreezHome => 'Loading BREEZ Home';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get navigateBack => 'Navigate back';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get useDarkColorScheme => 'Use dark color scheme';

  @override
  String get themeChangeNextVersion =>
      'Theme change will be available in the next version';

  @override
  String get units => 'Units';

  @override
  String get temperatureUnits => 'Temperature';

  @override
  String get celsius => 'Celsius (°C)';

  @override
  String get fahrenheit => 'Fahrenheit (°F)';

  @override
  String unitsChangedTo(String unit) {
    return 'Units changed to $unit';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get receiveInstantNotifications => 'Receive instant notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get receiveEmailReports => 'Receive reports via email';

  @override
  String notificationsState(String type, String state) {
    return '$type notifications $state';
  }

  @override
  String get language => 'Language';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get license => 'License';

  @override
  String get checkUpdates => 'Check for Updates';

  @override
  String get checkingUpdates => 'Checking for updates...';

  @override
  String get deviceManagement => 'Device Management';

  @override
  String get search => 'Search';

  @override
  String get scanForDevices => 'Scan for Devices';

  @override
  String get addDevice => 'Add Device';

  @override
  String get editDevice => 'Edit Device';

  @override
  String get removeDevice => 'Remove Device';

  @override
  String get deviceName => 'Device Name';

  @override
  String get macAddress => 'MAC Address';

  @override
  String get location => 'Location';

  @override
  String get notFoundDevice => 'Not found\ndevice?';

  @override
  String get selectManually => 'Select manually';

  @override
  String get deviceUpdated => 'Device updated';

  @override
  String get deviceAdded => 'Device added successfully';

  @override
  String get deviceRemoved => 'Device removed successfully';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get processingQrCode => 'Processing QR Code...';

  @override
  String get invalidQrCode => 'Invalid QR code';

  @override
  String get deviceDetectedFromQr => 'Device detected from QR code';

  @override
  String get enterMacManually => 'Or enter MAC address manually';

  @override
  String get invalidMacFormat =>
      'Invalid MAC address format (e.g., AA:BB:CC:DD:EE:FF)';

  @override
  String get deviceNameMinLength => 'Device name must be at least 3 characters';

  @override
  String get adding => 'Adding...';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String confirmRemoveDevice(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String wifiNetwork(String network) {
    return 'WiFi: $network';
  }

  @override
  String get hvacControl => 'BREEZ Home';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get fanSpeed => 'Fan Speed';

  @override
  String get fan => 'Fan';

  @override
  String get mode => 'Mode';

  @override
  String get operatingMode => 'Operating Mode';

  @override
  String get power => 'Power';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get current => 'Current';

  @override
  String get target => 'Target';

  @override
  String get cooling => 'Cooling';

  @override
  String get heating => 'Heating';

  @override
  String get auto => 'Auto';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get mode2 => 'Mode 2';

  @override
  String get humidifierAir => 'Humidifier\nAir';

  @override
  String get purifierAir => 'Purifier\nAir';

  @override
  String get lighting => 'Lighting';

  @override
  String get mainLight => 'Main light';

  @override
  String get floorLamp => 'Floor lamp';

  @override
  String get unit => 'Unit';

  @override
  String get notificationsComingSoon => 'Notifications feature coming soon';

  @override
  String get favorite => 'Favorite';

  @override
  String get activity => 'Activity';

  @override
  String get seeAll => 'See All';

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get moderate => 'Moderate';

  @override
  String get poor => 'Poor';

  @override
  String get veryPoor => 'Very Poor';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get allOn => 'All On';

  @override
  String get allOff => 'All Off';

  @override
  String get sync => 'Sync';

  @override
  String get schedule => 'Schedule';

  @override
  String get presets => 'Presets';

  @override
  String get error => 'Error';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get serverError => 'Server Error';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get somethingWentWrong => 'Oops! Something went wrong';

  @override
  String get unableToConnect =>
      'Unable to connect to the server. Please check your internet connection.';

  @override
  String get serverErrorMessage =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get permissionRequiredMessage =>
      'This feature requires additional permissions to work properly.';

  @override
  String get networkConnectionFailed =>
      'Network connection failed. Please check your internet connection.';

  @override
  String get requestTimedOut => 'Request timed out. Please try again.';

  @override
  String get failedToConnect => 'Failed to connect to device server';

  @override
  String connectionFailed(String error) {
    return 'Connection failed: $error';
  }

  @override
  String failedToAddDevice(String error) {
    return 'Failed to add device: $error';
  }

  @override
  String failedToRemoveDevice(String error) {
    return 'Failed to remove device: $error';
  }

  @override
  String failedToLoadMore(String error) {
    return 'Failed to load more items: $error';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get retry => 'Retry';

  @override
  String get retryConnection => 'Retry Connection';

  @override
  String get refreshing => 'Refreshing...';

  @override
  String get refreshDevices => 'Refresh Devices';

  @override
  String get retryingConnection => 'Retrying connection';

  @override
  String errorCode(String code) {
    return 'Error Code: $code';
  }

  @override
  String get errorCodeCopied => 'Error code copied to clipboard';

  @override
  String get technicalDetails => 'Technical Details';

  @override
  String get doubleTapToRetry => 'Double tap to retry';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingDevices => 'Loading devices...';

  @override
  String get allUnitsLoaded => 'All units loaded';

  @override
  String get connecting => 'Connecting...';

  @override
  String get reconnecting => 'Reconnecting...';

  @override
  String get noDevices => 'No Devices';

  @override
  String get noDevicesFound => 'No Devices Found';

  @override
  String get addFirstDevice => 'Add your first device to get started';

  @override
  String get checkMqttSettings =>
      'Check your MQTT connection settings\nand make sure devices are online';

  @override
  String get deviceNotSelected => 'No device selected';

  @override
  String get openDeviceAddition => 'Opening device addition screen';

  @override
  String get initializingCamera => 'Initializing camera...';

  @override
  String get cameraAccessRequired =>
      'Camera access is required to scan QR codes.\nPlease enable camera permissions in your browser settings.';

  @override
  String get cameraError => 'Camera Error';

  @override
  String get cameraErrorMessage =>
      'An error occurred while accessing the camera.';

  @override
  String get webCameraSetupRequired =>
      'Web camera scanning requires additional setup. Please use manual entry or scan from mobile device.';

  @override
  String get cameraView => 'Camera View';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordTooShort(int length) {
    return 'Password must be at least $length characters';
  }

  @override
  String nameRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String nameTooShort(String fieldName) {
    return '$fieldName must be at least 2 characters';
  }

  @override
  String get fillRequiredFields => 'Please fill in all required fields';

  @override
  String get pleaseAcceptTerms => 'Please accept the terms and conditions';

  @override
  String minCharacters(int count) {
    return 'Min $count characters';
  }

  @override
  String get atLeast8Characters => 'At least 8 characters';

  @override
  String get uppercaseLetter => 'Uppercase letter';

  @override
  String get lowercaseLetter => 'Lowercase letter';

  @override
  String get number => 'Number';

  @override
  String get specialCharacter => 'Special character';

  @override
  String get weak => 'Weak';

  @override
  String get strong => 'Strong';

  @override
  String get veryStrong => 'Very Strong';

  @override
  String editSchedule(String name) {
    return 'Edit $name';
  }

  @override
  String deleteSchedule(String name) {
    return 'Delete $name';
  }

  @override
  String get editScheduleTooltip => 'Edit schedule';

  @override
  String get deleteScheduleTooltip => 'Delete schedule';

  @override
  String get success => 'Success';

  @override
  String get settingsSaved => 'Settings saved. Restart app to apply changes.';

  @override
  String get presetApplied => 'Preset applied';

  @override
  String get allUnitsOn => 'All units turned on';

  @override
  String get allUnitsOff => 'All units turned off';

  @override
  String get settingsSynced => 'Settings synced to all units';

  @override
  String get scheduleAppliedToAll => 'Schedule applied to all units';

  @override
  String get errorChangingPower => 'Error changing power';

  @override
  String get errorUpdatingMode => 'Error updating mode';

  @override
  String get errorUpdatingFanSpeed => 'Error updating fan speed';

  @override
  String get errorApplyingPreset => 'Error applying preset';

  @override
  String get errorTurningOnUnits => 'Error turning on units';

  @override
  String get errorTurningOffUnits => 'Error turning off units';

  @override
  String get errorSyncingSettings => 'Error syncing settings';

  @override
  String get errorApplyingSchedule => 'Error applying schedule';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get idle => 'Idle';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get activated => 'activated';

  @override
  String get deactivated => 'deactivated';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get done => 'Done';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get logout => 'Logout';

  @override
  String get status => 'Status';

  @override
  String get details => 'Details';

  @override
  String get more => 'More';

  @override
  String get less => 'Less';

  @override
  String get all => 'All';

  @override
  String get none => 'None';

  @override
  String get optional => 'Optional';

  @override
  String get required => 'Required';

  @override
  String get info => 'Information';

  @override
  String get warning => 'Warning';

  @override
  String get notification => 'Notification';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String date(String date) {
    return '$date';
  }

  @override
  String get manageRules => 'Manage Rules (Coming Soon)';

  @override
  String get manageRulesComingSoon => 'Manage Rules (Coming Soon)';

  @override
  String get addUnitComingSoon => 'Add unit feature coming soon';

  @override
  String get livingRoom => 'Living Room';

  @override
  String get bedroom => 'Bedroom';

  @override
  String get kitchen => 'Kitchen';

  @override
  String get vacuumCleaner => 'Vacuum cleaner';

  @override
  String get smartBulb => 'Smart bulb';

  @override
  String get humidifier => 'Humidifier';

  @override
  String get average => 'Average';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get temperatureHistory => 'Temperature History';

  @override
  String get last24Hours => 'Last 24 hours';

  @override
  String activeDevices(int count, int total) {
    return '$count of $total active';
  }

  @override
  String get runDiagnostics => 'Run Diagnostics';

  @override
  String get systemHealth => 'System Health';

  @override
  String get supplyFan => 'Supply Fan';

  @override
  String get exhaustFan => 'Exhaust Fan';

  @override
  String get heater => 'Heater';

  @override
  String get recuperator => 'Recuperator';

  @override
  String get sensors => 'Sensors';

  @override
  String get normal => 'Normal';

  @override
  String get sensorReadings => 'Sensor Readings';

  @override
  String get supplyAirTemp => 'Supply Air Temperature';

  @override
  String get outdoorTemp => 'Outdoor Temperature';

  @override
  String get pressure => 'Pressure';

  @override
  String get networkConnection => 'Network Connection';

  @override
  String get network => 'Network';

  @override
  String get signal => 'Signal';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get notConnected => 'Not Connected';

  @override
  String get notAssigned => 'Not Assigned';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get diagnosticsRunning => 'Running system diagnostics...';

  @override
  String get diagnosticsComplete => 'Diagnostics complete. System is normal.';

  @override
  String get scheduleSaved => 'Schedule saved successfully';

  @override
  String saveError(String error) {
    return 'Save error: $error';
  }

  @override
  String get unsavedChanges => 'Unsaved Changes';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Exit without saving?';

  @override
  String get exit => 'Exit';

  @override
  String devicesFound(int count) {
    return '$count new devices';
  }

  @override
  String deviceFound(int count) {
    return '$count new device';
  }

  @override
  String get notFoundDeviceTitle => 'Not found\ndevice?';

  @override
  String get selectManuallyButton => 'Select manually';

  @override
  String devicesAdded(int count, String plural) {
    return '$count $plural added';
  }

  @override
  String get device => 'device';

  @override
  String get devices => 'devices';
}
