// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Log in';

  @override
  String get register => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get consentRequired => 'Data processing consent is required';

  @override
  String get consentLabel => 'I agree to the processing of personal data';

  @override
  String get passwordHint => 'At least 8 chars, letters and digits';

  @override
  String get passwordRecovery => 'PASSWORD RECOVERY';

  @override
  String get enterEmailForReset =>
      'Enter the email used during registration.\nWe\'ll send you a code to reset your password.';

  @override
  String get sendCode => 'Send Code';

  @override
  String codeSentTo(String email) {
    return 'Code sent to $email';
  }

  @override
  String get enterSixDigitCode => 'Enter 6-digit code';

  @override
  String get enterCodeSentTo => 'Enter the code sent to';

  @override
  String get resendCode => 'Resend code';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get notifications => 'Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get alarmNotifications => 'Alarm Notifications';

  @override
  String get language => 'Language';

  @override
  String get addDevice => 'Add device';

  @override
  String get deviceName => 'Name';

  @override
  String get delete => 'Delete';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get operatingMode => 'Operating Mode';

  @override
  String get targetTemperature => 'Target temperature';

  @override
  String get supply => 'Supply';

  @override
  String get exhaust => 'Exhaust';

  @override
  String get airflowRate => 'Airflow';

  @override
  String get filter => 'Filter';

  @override
  String get filterDesc => 'Remaining filter capacity';

  @override
  String todayDate(String date) {
    return 'Today, $date';
  }

  @override
  String get presets => 'Presets';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get noDevices => 'No Devices';

  @override
  String passwordTooShort(int length) {
    return 'Password must be at least $length characters';
  }

  @override
  String nameTooShort(String fieldName) {
    return '$fieldName must be at least 2 characters';
  }

  @override
  String get enterEmail => 'Enter email';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get confirmPasswordRequired => 'Confirm password';

  @override
  String get passwordOnlyLatin => 'Password must contain only Latin letters';

  @override
  String get passwordMustContainDigit => 'Must contain at least one digit';

  @override
  String get passwordMustContainLetter =>
      'Must contain at least one Latin letter';

  @override
  String get enterName => 'Enter name';

  @override
  String enterField(String fieldName) {
    return 'Enter $fieldName';
  }

  @override
  String get nameOnlyLetters => 'Only letters (spaces and hyphens allowed)';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get schedule => 'Schedule';

  @override
  String allCount(int count) {
    return 'All (+$count)';
  }

  @override
  String get noSchedule => 'No schedule';

  @override
  String get addScheduleForDevice => 'Add schedule for the device';

  @override
  String get nowLabel => 'Now';

  @override
  String get alarms => 'Alarms';

  @override
  String get noAlarms => 'No alarms';

  @override
  String get systemWorkingNormally => 'System working normally';

  @override
  String get alarmHistory => 'Alarm History';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get save => 'Save';

  @override
  String get enable => 'Enable';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Logout';

  @override
  String get today => 'Today';

  @override
  String get devices => 'Devices';

  @override
  String get profile => 'Profile';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get passwordChanged => 'Password changed. Please sign in again.';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get theme => 'Theme';

  @override
  String get darkThemeLabel => 'Dark';

  @override
  String get lightThemeLabel => 'Light';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordConfirmation => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get change => 'Change';

  @override
  String get allNotifications => 'All notifications';

  @override
  String get allAlarms => 'All alarms';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String daysAgo(int count) {
    return '$count d ago';
  }

  @override
  String get addFirstEntry => 'Add first entry';

  @override
  String alarmCode(String code) {
    return 'Code $code';
  }

  @override
  String get activeAlarm => 'ACTIVE';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modeEco => 'Eco';

  @override
  String get modeNight => 'Night';

  @override
  String get modeBoost => 'TURBO';

  @override
  String modeFor(String name) {
    return 'Mode $name';
  }

  @override
  String get deviceDeleted => 'Device deleted';

  @override
  String get nameChanged => 'Name changed';

  @override
  String get timeSet => 'Time set';

  @override
  String get notificationsInDevelopment =>
      'Notifications: feature in development';

  @override
  String get allDevicesTurnedOff => 'All devices turned off';

  @override
  String get addFirstDeviceByMac => 'Add your first unit by MAC address';

  @override
  String get addUnit => 'Add Unit';

  @override
  String get enterMacAddress => 'Enter MAC address';

  @override
  String get macAddressMustContain12Chars =>
      'MAC address must contain 12 characters';

  @override
  String get macAddressOnlyHex => 'MAC address can only contain 0-9 and A-F';

  @override
  String get deviceMacAddress => 'Device MAC address';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get addButton => 'Add';

  @override
  String get deviceNameExample => 'e.g. Living Room';

  @override
  String get enterDeviceName => 'Enter device name';

  @override
  String get macAddressDisplayedOnRemote =>
      'MAC address is displayed on the remote screen';

  @override
  String get analytics => 'Analytics';

  @override
  String get analyticsHint => 'Tap on a sensor to select';

  @override
  String get devicesWillAppear => 'Devices will appear here\nafter connecting';

  @override
  String get presetComfort => 'Comfort';

  @override
  String get presetComfortDesc => 'Optimal mode';

  @override
  String get presetEco => 'Eco';

  @override
  String get presetEcoDesc => 'Energy saving';

  @override
  String get presetNight => 'Night';

  @override
  String get presetNightDesc => 'Quiet mode';

  @override
  String get presetTurbo => 'Turbo';

  @override
  String get presetTurboDesc => 'Maximum power';

  @override
  String get presetAway => 'Away';

  @override
  String get presetAwayDesc => 'Minimal mode';

  @override
  String get presetSleep => 'Sleep';

  @override
  String get presetSleepDesc => 'Comfortable sleep';

  @override
  String devicesCount(int count) {
    return '$count devices';
  }

  @override
  String get thisMonth => 'This month';

  @override
  String get totalTime => 'Total time';

  @override
  String energyKwh(String value) {
    return '$value kWh';
  }

  @override
  String hoursCount(int count) {
    return '$count hours';
  }

  @override
  String get airflow => 'Airflow';

  @override
  String get graphTemperatureLabel => 'Temperature';

  @override
  String get graphHumidityLabel => 'Humidity';

  @override
  String get graphAirflowLabel => 'Airflow';

  @override
  String get tempShort => 'Temp';

  @override
  String get humidShort => 'Humid';

  @override
  String get airflowShort => 'Flow';

  @override
  String get minShort => 'Min';

  @override
  String get maxShort => 'Max';

  @override
  String get avgShort => 'Avg';

  @override
  String get cubicMetersPerHour => 'm³/h';

  @override
  String get readAll => 'Read all';

  @override
  String get later => 'Later';

  @override
  String get updateNow => 'Update now';

  @override
  String get whatsNew => 'What\'s new?';

  @override
  String get hide => 'Hide';

  @override
  String get errorNoConnection => 'No connection';

  @override
  String get errorServer => 'Server error';

  @override
  String errorServerWithCode(int code) {
    return 'Server error ($code)';
  }

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorAuthRequired => 'Authorization required';

  @override
  String get errorSomethingWrong => 'Something went wrong';

  @override
  String get errorCheckInternet =>
      'Check your internet connection\nand try again';

  @override
  String get errorServerProblems =>
      'Server-side problems.\nWe are already working on a fix.';

  @override
  String errorResourceNotFound(String resource) {
    return 'Requested $resource not found.\nIt may have been deleted.';
  }

  @override
  String get errorSessionExpired =>
      'Your session has expired.\nPlease log in again.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred.\nPlease try again.';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorServerUnavailable => 'Server unavailable';

  @override
  String get errorLoadingFailed => 'Failed to load devices';

  @override
  String get emptyNoDevicesTitle => 'No devices';

  @override
  String get emptyNoDevicesMessage =>
      'Devices will appear here\nafter connecting';

  @override
  String get emptyNothingFound => 'Nothing found';

  @override
  String emptyNoSearchResults(String query) {
    return 'No results for \"$query\".\nTry changing search parameters.';
  }

  @override
  String get emptyNoNotificationsTitle => 'No notifications';

  @override
  String get emptyNoNotificationsMessage =>
      'You have no notifications yet.\nNew notifications will appear here.';

  @override
  String get emptyHistoryTitle => 'History is empty';

  @override
  String get emptyHistoryMessage =>
      'Operation history will appear\nafter first actions.';

  @override
  String get emptyNoScheduleTitle => 'No schedule';

  @override
  String get emptyNoScheduleMessage =>
      'Add schedule entries\nfor automatic control';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get scheduleAdd => 'Add';

  @override
  String get scheduleNewEntry => 'New entry';

  @override
  String get scheduleEditEntry => 'Edit entry';

  @override
  String get scheduleDeleteConfirm => 'Delete entry?';

  @override
  String scheduleDeleteMessage(String entry) {
    return 'Entry \"$entry\" will be deleted.';
  }

  @override
  String get scheduleDayLabel => 'Day of week';

  @override
  String get scheduleStartLabel => 'Start';

  @override
  String get scheduleEndLabel => 'End';

  @override
  String get scheduleModeLabel => 'Mode';

  @override
  String get scheduleDayTemp => 'Day temperature';

  @override
  String get scheduleNightTemp => 'Night temperature';

  @override
  String get scheduleActive => 'Active';

  @override
  String scheduleDayNightTemp(int day, int night) {
    return 'Day: $day° / Night: $night°';
  }

  @override
  String get modeCooling => 'Cooling';

  @override
  String get modeHeating => 'Heating';

  @override
  String get modeVentilation => 'Ventilation';

  @override
  String get statusOnline => 'Online';

  @override
  String get statusOffline => 'Offline';

  @override
  String get deviceOffline => 'Device offline';

  @override
  String get statusRunning => 'Running';

  @override
  String get statusStopped => 'Stopped';

  @override
  String get syncedAt => 'Synced:';

  @override
  String get statusEnabled => 'Enabled';

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get holdToToggle => 'Hold to activate day';

  @override
  String get selectTime => 'Select time';

  @override
  String get setDateTime => 'Set date and time';

  @override
  String get confirm => 'Done';

  @override
  String get statusResolved => 'RESOLVED';

  @override
  String get statusActive => 'ACTIVE';

  @override
  String get alarmHistoryTitle => 'Alarm history';

  @override
  String get alarmHistoryEmpty => 'Alarm history is empty';

  @override
  String get alarmNoAlarms => 'No alarms recorded';

  @override
  String alarmCodeLabel(int code) {
    return 'Code $code';
  }

  @override
  String get alarmOccurredAt => 'Occurred';

  @override
  String get alarmClearedAt => 'Cleared';

  @override
  String get alarmReset => 'Reset';

  @override
  String get janShort => 'Jan';

  @override
  String get febShort => 'Feb';

  @override
  String get marShort => 'Mar';

  @override
  String get aprShort => 'Apr';

  @override
  String get mayShort => 'May';

  @override
  String get junShort => 'Jun';

  @override
  String get julShort => 'Jul';

  @override
  String get augShort => 'Aug';

  @override
  String get sepShort => 'Sep';

  @override
  String get octShort => 'Oct';

  @override
  String get novShort => 'Nov';

  @override
  String get decShort => 'Dec';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsReadAll => 'Read all notifications';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get unitSettingsTitle => 'Unit settings';

  @override
  String get unitSettingsName => 'Name:';

  @override
  String get unitSettingsStatus => 'Status:';

  @override
  String get unitSettingsNewName => 'New name';

  @override
  String get unitSettingsEnterName => 'Enter name';

  @override
  String get unitSettingsRename => 'Rename';

  @override
  String get unitSettingsRenameSubtitle => 'Change unit name';

  @override
  String get unitSettingsDelete => 'Delete';

  @override
  String get unitSettingsDeleteSubtitle => 'Unlink device from account';

  @override
  String get unitSettingsDeleteConfirm => 'Delete unit?';

  @override
  String unitSettingsDeleteMessage(String name) {
    return 'Unit \"$name\" will be unlinked from your account. You can add it again using MAC address.';
  }

  @override
  String get unitSettingsSetTime => 'Set Time';

  @override
  String get updateAvailable => 'Update available';

  @override
  String updateVersionAvailable(String version) {
    return 'Version $version available';
  }

  @override
  String get updateMessage =>
      'An app update is available. Reload the page to get new features and fixes.';

  @override
  String get verifyEmailTitle => 'EMAIL VERIFICATION';

  @override
  String get verifyEmailSent => 'We sent a 6-digit verification code to';

  @override
  String get verifyEmailResend => 'Resend code';

  @override
  String get verifyEmailCodeSent => 'Code sent to email';

  @override
  String get tooltipEdit => 'Edit';

  @override
  String get tooltipDelete => 'Delete';

  @override
  String get tooltipAdd => 'Add';

  @override
  String get dataResource => 'data';

  @override
  String get defaultUserName => 'User';

  @override
  String get heating => 'Heating';

  @override
  String get cooling => 'Cooling';

  @override
  String get outdoorTemp => 'Outdoor air temperature';

  @override
  String get indoorTemp => 'Indoor air temperature';

  @override
  String get supplyTempAfterRecup => 'Supply air temp after recuperator';

  @override
  String get supplyTemp => 'Supply air temperature';

  @override
  String get co2Level => 'CO2 concentration';

  @override
  String get recuperatorEfficiency => 'Recuperator temp efficiency';

  @override
  String get freeCooling => 'Recuperator free cooling';

  @override
  String get heaterPerformance => 'Electric heater performance';

  @override
  String get coolerStatus => 'Cooler status';

  @override
  String get ductPressure => 'Duct pressure';

  @override
  String get relativeHumidity => 'Relative humidity';

  @override
  String get outdoor => 'Outdoor';

  @override
  String get indoor => 'Indoor';

  @override
  String get afterRecup => 'After recup.';

  @override
  String get efficiency => 'Efficiency';

  @override
  String get freeCool => 'Free cool recup.';

  @override
  String get on => 'ON';

  @override
  String get off => 'OFF';

  @override
  String get heater => 'Heater';

  @override
  String get cooler => 'Cooler';

  @override
  String get pressure => 'Pressure';

  @override
  String get noDeviceSelected => 'No device selected';

  @override
  String get modes => 'Modes';

  @override
  String get modeBasic => 'Basic';

  @override
  String get modeIntensive => 'Intensive';

  @override
  String get modeEconomy => 'Economy';

  @override
  String get modeMaxPerformance => 'Max';

  @override
  String get modeKitchen => 'Kitchen';

  @override
  String get modeFireplace => 'Fireplace';

  @override
  String get modeVacation => 'Vacation';

  @override
  String get modeCustom => 'Custom';

  @override
  String get controls => 'Control';

  @override
  String get sensors => 'Sensors';

  @override
  String get temperatureSetpoints => 'Temperature setpoints';

  @override
  String get fanSpeed => 'Fan speed';

  @override
  String get status => 'Status';

  @override
  String get seeAll => 'See all';

  @override
  String get outdoorTempDesc => 'Outdoor air temperature';

  @override
  String get indoorTempDesc => 'Indoor air temperature';

  @override
  String get supplyTempAfterRecupDesc =>
      'Supply air temperature after heat exchange in recuperator';

  @override
  String get supplyTempDesc => 'Air temperature at ventilation unit outlet';

  @override
  String get co2LevelDesc => 'CO2 level in the room. Normal: up to 1000 ppm';

  @override
  String get recuperatorEfficiencyDesc =>
      'Heat exchange efficiency in recuperator';

  @override
  String get freeCoolingDesc =>
      'Free cooling mode using outdoor air via recuperator';

  @override
  String get heaterPerformanceDesc => 'Current electric heater power';

  @override
  String get coolerStatusDesc => 'Air cooler status';

  @override
  String get ductPressureDesc => 'Air pressure in duct (Pa)';

  @override
  String get humidityDesc => 'Relative indoor air humidity';

  @override
  String get unitPoweredOn => 'powered on';

  @override
  String get unitPoweredOff => 'powered off';

  @override
  String get unitSelected => 'selected';

  @override
  String get devicesList => 'Devices list';

  @override
  String get segmentSelection => 'Segment selection';

  @override
  String noEntriesForDay(String day) {
    return 'No entries for $day';
  }

  @override
  String get tapToAdd => 'Tap to add';

  @override
  String get quickSensorsTitle => 'Quick sensors';

  @override
  String get quickSensorsHint => 'Tap sensor to replace';

  @override
  String get sensorInteractionHint => 'Tap for details • Long press to select';

  @override
  String get close => 'Close';

  @override
  String get eventLogs => 'Event Logs';

  @override
  String get eventLogsDescription => 'Device settings change history';

  @override
  String get logColumnTime => 'Time';

  @override
  String get logColumnType => 'Type';

  @override
  String get logColumnCategory => 'Category';

  @override
  String get logColumnProperty => 'Property';

  @override
  String get logColumnOldValue => 'Old';

  @override
  String get logColumnNewValue => 'New';

  @override
  String get logColumnDescription => 'Description';

  @override
  String get logTypeSettings => 'Settings';

  @override
  String get logTypeAlarm => 'Alarm';

  @override
  String get filterAll => 'All';

  @override
  String get logCategoryMode => 'Mode';

  @override
  String get logCategoryTimer => 'Timer';

  @override
  String get logCategoryAlarm => 'Alarm';

  @override
  String get logNoData => 'No records';

  @override
  String get logNoDataHint => 'Try changing the filter';

  @override
  String get logLoadMore => 'Load more';

  @override
  String logShowing(int count, int total) {
    return 'Showing: $count of $total';
  }

  @override
  String logPage(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get serviceEngineer => 'Service';

  @override
  String get sessionExpired => 'Session expired. Logging out...';

  @override
  String get temperatureSetpoint => 'Setpoint';

  @override
  String get sensorRemove => 'Remove';

  @override
  String get sensorToMain => 'To main';

  @override
  String get sensorMaxSelected => 'Max 3';
}
