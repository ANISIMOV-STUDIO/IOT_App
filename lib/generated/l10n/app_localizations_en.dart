// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HVAC Control';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get hvacControl => 'HVAC Control';

  @override
  String activeDevices(int count, int total) {
    return '$count of $total active';
  }

  @override
  String get connectionError => 'Connection Error';

  @override
  String get retryConnection => 'Retry Connection';

  @override
  String get noDevicesFound => 'No Devices Found';

  @override
  String get checkMqttSettings =>
      'Check your MQTT connection settings\nand make sure devices are online';

  @override
  String get loadingDevices => 'Loading devices...';

  @override
  String get power => 'Power';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get temperature => 'Temperature';

  @override
  String get adjustTargetTemperature => 'Adjust target temperature';

  @override
  String get deviceIsOff => 'Device is off';

  @override
  String get target => 'Target';

  @override
  String current(String temp) {
    return 'Current: $temp°C';
  }

  @override
  String get currentTemp => 'Current';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get operatingMode => 'Operating Mode';

  @override
  String get selectHvacMode => 'Select HVAC operating mode';

  @override
  String get cooling => 'Cooling';

  @override
  String get heating => 'Heating';

  @override
  String get auto => 'Auto';

  @override
  String get fan => 'Fan';

  @override
  String get coolDownToTarget => 'Cool down to target temperature';

  @override
  String get heatUpToTarget => 'Heat up to target temperature';

  @override
  String get autoAdjustTemperature => 'Automatically adjust temperature';

  @override
  String get circulateAir => 'Circulate air without heating/cooling';

  @override
  String get fanSpeed => 'Fan Speed';

  @override
  String get adjustAirflow => 'Adjust airflow intensity';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Med';

  @override
  String get high => 'High';

  @override
  String get gentleAirflow => 'Gentle airflow for quiet operation';

  @override
  String get balancedAirflow => 'Balanced airflow and noise level';

  @override
  String get maximumAirflow => 'Maximum airflow for rapid cooling/heating';

  @override
  String get autoAdjustSpeed => 'Automatically adjusts based on temperature';

  @override
  String get powerLevel => 'Power';

  @override
  String get temperatureHistory => 'Temperature History';

  @override
  String get last24Hours => 'Last 24 hours';

  @override
  String get average => 'Average';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get chinese => '中文';

  @override
  String get connection => 'Connection';

  @override
  String get mqttSettings => 'MQTT Settings';

  @override
  String get configureMqtt => 'Configure MQTT broker connection';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get hvacUnit => 'HVAC Unit';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get lightMode => 'Light mode';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get systemDefault => 'System default';

  @override
  String get toggleTheme => 'Toggle Theme';

  @override
  String get mqttBroker => 'MQTT Broker';

  @override
  String get username => 'Username';

  @override
  String get settingsSaved => 'Settings saved. Restart app to apply changes.';

  @override
  String get aboutApp => 'About';

  @override
  String get appDescription =>
      'Cross-platform HVAC management application with MQTT integration.';

  @override
  String get deviceManagement => 'Device Management';

  @override
  String get addDevice => 'Add Device';

  @override
  String get macAddress => 'MAC Address';

  @override
  String get deviceName => 'Device Name';

  @override
  String get livingRoom => 'Living Room';

  @override
  String get location => 'Location';

  @override
  String get optional => 'Optional';

  @override
  String get fillRequiredFields => 'Please fill in all required fields';

  @override
  String get deviceAdded => 'Device added successfully';

  @override
  String get removeDevice => 'Remove Device';

  @override
  String confirmRemoveDevice(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get deviceRemoved => 'Device removed successfully';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get mqttModeRequired => 'MQTT mode is required for device management';

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
  String get fullName => 'Full Name';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get enterMacManually => 'Or enter MAC address manually';

  @override
  String get logout => 'Logout';

  @override
  String get skipAuth => 'Continue without registration';
}
