// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BREEZ Home';

  @override
  String get smartClimateManagement => 'Smart Climate Management';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get loginSubtitle => '欢迎回来！登录以继续';

  @override
  String get registerSubtitle => '创建账户以开始';

  @override
  String get email => '电子邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => '全名';

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
  String get skipAuth => '无需注册继续';

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
  String get home => '主页';

  @override
  String get settings => '设置';

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
  String get appearance => '外观';

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
  String get language => '语言';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get developer => 'Developer';

  @override
  String get license => 'License';

  @override
  String get checkUpdates => 'Check for Updates';

  @override
  String get checkingUpdates => 'Checking for updates...';

  @override
  String get deviceManagement => '设备管理';

  @override
  String get search => 'Search';

  @override
  String get scanForDevices => 'Scan for Devices';

  @override
  String get addDevice => '添加设备';

  @override
  String get editDevice => 'Edit Device';

  @override
  String get removeDevice => '删除设备';

  @override
  String get deviceName => '设备名称';

  @override
  String get macAddress => 'MAC地址';

  @override
  String get location => '位置';

  @override
  String get notFoundDevice => 'Not found\ndevice?';

  @override
  String get selectManually => 'Select manually';

  @override
  String get deviceUpdated => 'Device updated';

  @override
  String get deviceAdded => '设备添加成功';

  @override
  String get deviceRemoved => '设备删除成功';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get processingQrCode => 'Processing QR Code...';

  @override
  String get invalidQrCode => 'Invalid QR code';

  @override
  String get deviceDetectedFromQr => 'Device detected from QR code';

  @override
  String get enterMacManually => '或手动输入MAC地址';

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
    return '您确定要删除 $name 吗？';
  }

  @override
  String wifiNetwork(String network) {
    return 'WiFi: $network';
  }

  @override
  String get hvacControl => 'BREEZ Home';

  @override
  String get temperature => '温度';

  @override
  String get humidity => 'Humidity';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get fanSpeed => '风速';

  @override
  String get fan => '送风';

  @override
  String get mode => 'Mode';

  @override
  String get operatingMode => '运行模式';

  @override
  String get power => '电源';

  @override
  String get on => '开';

  @override
  String get off => '关';

  @override
  String current(Object temp) {
    return '当前：$temp°C';
  }

  @override
  String get target => '目标';

  @override
  String get cooling => '制冷';

  @override
  String get heating => '制热';

  @override
  String get auto => '自动';

  @override
  String get low => '低';

  @override
  String get medium => '中';

  @override
  String get high => '高';

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
  String error(Object message) {
    return '错误：$message';
  }

  @override
  String get connectionError => '连接错误';

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
  String get retryConnection => '重试连接';

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
  String get loadingDevices => '加载设备中...';

  @override
  String get allUnitsLoaded => 'All units loaded';

  @override
  String get connecting => 'Connecting...';

  @override
  String get reconnecting => 'Reconnecting...';

  @override
  String get noDevices => 'No Devices';

  @override
  String get noDevicesFound => '未找到设备';

  @override
  String get addFirstDevice => 'Add your first device to get started';

  @override
  String get checkMqttSettings => '请检查MQTT连接设置\n并确保设备在线';

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
  String get emailRequired => '电子邮箱为必填项';

  @override
  String get invalidEmail => '请输入有效的电子邮箱';

  @override
  String get passwordRequired => '密码为必填项';

  @override
  String passwordTooShort(int length) {
    return '密码至少需要6个字符';
  }

  @override
  String nameRequired(String fieldName) {
    return '姓名为必填项';
  }

  @override
  String nameTooShort(String fieldName) {
    return '姓名至少需要2个字符';
  }

  @override
  String get fillRequiredFields => '请填写所有必填字段';

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
  String get settingsSaved => '设置已保存。请重启应用以应用更改。';

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
  String get cancel => '取消';

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
  String get add => '添加';

  @override
  String get remove => '删除';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get logout => '退出登录';

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
  String get optional => '可选';

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
  String get livingRoom => '客厅';

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
  String get average => '平均';

  @override
  String get min => '最小';

  @override
  String get max => '最大';

  @override
  String get temperatureHistory => '温度历史';

  @override
  String get last24Hours => '最近24小时';

  @override
  String activeDevices(int count, int total) {
    return '$count/$total 活跃';
  }
}
