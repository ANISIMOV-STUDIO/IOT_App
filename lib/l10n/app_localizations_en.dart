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
}
