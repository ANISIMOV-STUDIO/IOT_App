import 'app_strings.dart';

/// English localization
class EnStrings implements AppStrings {
  const EnStrings();

  // ============================================
  // NAVIGATION
  // ============================================
  @override String get dashboard => 'Dashboard';
  @override String get rooms => 'Rooms';
  @override String get recent => 'Recent';
  @override String get bookmarks => 'Bookmarks';
  @override String get notifications => 'Notifications';
  @override String get downloads => 'Downloads';
  @override String get support => 'Support';
  @override String get settings => 'Settings';

  // ============================================
  // GREETING
  // ============================================
  @override String get welcomeBack => 'Welcome back';
  @override String get user => 'User';

  // ============================================
  // DEVICES
  // ============================================
  @override String get myDevices => 'My Devices';
  @override String get smartTv => 'Smart TV';
  @override String get speaker => 'Speaker';
  @override String get router => 'Router';
  @override String get wifi => 'Wi-Fi';
  @override String get heater => 'Heater';
  @override String get socket => 'Socket';
  @override String get airCondition => 'Air Condition';
  @override String get smartLamp => 'Smart Lamp';
  @override String get activeFor => 'Active for';
  @override String hours(int count) => '$count ${count == 1 ? 'hour' : 'hours'}';
  @override String get active => 'Active';
  @override String get standby => 'Standby';
  @override String get turnedOn => 'Turned On';
  @override String get turnedOff => 'Turned Off';

  // ============================================
  // CLIMATE
  // ============================================
  @override String get temperature => 'Temperature';
  @override String get targetTemperature => 'Target Temperature';
  @override String get currentTemperature => 'Current Temperature';
  @override String get humidity => 'Humidity';
  @override String get heating => 'Heating';
  @override String get cooling => 'Cooling';
  @override String get dry => 'Dry';
  @override String get auto => 'Auto';
  @override String get ventilation => 'Ventilation';
  @override String get deviceStatus => 'Device Status';
  @override String get airflowControl => 'Airflow Control';
  @override String get supplyAirflow => 'Supply';
  @override String get exhaustAirflow => 'Exhaust';
  @override String get sensors => 'Sensors';
  @override String get presets => 'Presets';
  @override String get night => 'Night';
  @override String get turbo => 'Turbo';
  @override String get eco => 'Eco';

  // ============================================
  // AIR QUALITY
  // ============================================
  @override String get airQuality => 'Air Quality';
  @override String get excellent => 'Excellent';
  @override String get good => 'Good';
  @override String get moderate => 'Moderate';
  @override String get poor => 'Poor';
  @override String get hazardous => 'Hazardous';
  @override String get co2 => 'CO₂';
  @override String get pollutants => 'Pollutants';

  // ============================================
  // STATISTICS / ENERGY
  // ============================================
  @override String get statistics => 'Statistics';
  @override String get usageStatus => 'Usage Status';
  @override String get energyUsage => 'Energy Usage';
  @override String get consumed => 'Consumed';
  @override String get workTime => 'Work Time';
  @override String get efficiencyGood => 'Great efficiency!';
  @override String get today => 'Today';
  @override String get thisWeek => 'This Week';
  @override String get thisMonth => 'This Month';
  @override String get totalSpent => 'Total Spent';
  @override String get totalHours => 'Total Hours';
  @override String get devicePowerConsumption => 'Device Power Consumption';
  @override String units(int count) => '$count ${count == 1 ? 'unit' : 'units'}';

  // ============================================
  // QUICK ACTIONS
  // ============================================
  @override String get quickActions => 'Quick Actions';
  @override String get allOff => 'All Off';
  @override String get sync => 'Sync';

  // ============================================
  // APPLIANCES
  // ============================================
  @override String get appliances => 'Appliances';
  @override String get all => 'All';
  @override String get hall => 'Hall';
  @override String get lounge => 'Lounge';
  @override String get bedroom => 'Bedroom';
  @override String get kitchen => 'Kitchen';
  @override String get tvSet => 'TV Set';
  @override String get stereoSystem => 'Stereo System';
  @override String get playStation => 'PlayStation';
  @override String get computer => 'Computer';
  @override String get lightFixture => 'Light Fixture';
  @override String get backlight => 'Backlight';
  @override String get lamp => 'Lamp';

  // ============================================
  // USERS
  // ============================================
  @override String get occupants => 'Occupants';
  @override String get seeAll => 'See All';
  @override String get add => 'Add';

  // ============================================
  // SCHEDULE
  // ============================================
  @override String get schedule => 'Schedule';
  @override String get wakeUp => 'Wake Up';
  @override String get away => 'Away';
  @override String get home => 'Home';
  @override String get sleep => 'Sleep';

  // ============================================
  // SYSTEM
  // ============================================
  @override String get systemStatus => 'System Status';
  @override String get device => 'Device';
  @override String get firmware => 'Firmware';
  @override String get connection => 'Connection';
  @override String get efficiency => 'Efficiency';
  @override String get filterStatus => 'Filter';
  @override String get uptime => 'Uptime';

  // ============================================
  // COMMON
  // ============================================
  @override String get save => 'Save';
  @override String get cancel => 'Cancel';
  @override String get confirm => 'Confirm';
  @override String get delete => 'Delete';
  @override String get edit => 'Edit';
  @override String get loading => 'Loading...';
  @override String get error => 'Error';
  @override String get retry => 'Retry';
  @override String get noData => 'No Data';
}
