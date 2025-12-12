/// Локализация приложения Smart Home
/// Русский язык по умолчанию

abstract class AppStrings {
  // ============================================
  // НАВИГАЦИЯ
  // ============================================
  String get dashboard;
  String get rooms;
  String get recent;
  String get bookmarks;
  String get notifications;
  String get downloads;
  String get support;
  String get settings;

  // ============================================
  // ПРИВЕТСТВИЕ
  // ============================================
  String get welcomeBack;
  String get user;

  // ============================================
  // УСТРОЙСТВА
  // ============================================
  String get myDevices;
  String get smartTv;
  String get speaker;
  String get router;
  String get wifi;
  String get heater;
  String get socket;
  String get airCondition;
  String get smartLamp;
  String get activeFor;
  String hours(int count);
  String get active;
  String get standby;
  String get turnedOn;
  String get turnedOff;

  // ============================================
  // КЛИМАТ
  // ============================================
  String get temperature;
  String get targetTemperature;
  String get currentTemperature;
  String get humidity;
  String get heating;
  String get cooling;
  String get dry;
  String get auto;
  String get ventilation;
  String get deviceStatus;
  String get airflowControl;
  String get supplyAirflow;
  String get exhaustAirflow;
  String get sensors;
  String get presets;
  String get night;
  String get turbo;
  String get eco;

  // ============================================
  // КАЧЕСТВО ВОЗДУХА
  // ============================================
  String get airQuality;
  String get excellent;
  String get good;
  String get moderate;
  String get poor;
  String get hazardous;
  String get co2;
  String get pollutants;

  // ============================================
  // СТАТИСТИКА / ЭНЕРГИЯ
  // ============================================
  String get statistics;
  String get usageStatus;
  String get energyUsage;
  String get consumed;
  String get workTime;
  String get efficiencyGood;
  String get today;
  String get thisWeek;
  String get thisMonth;
  String get totalSpent;
  String get totalHours;
  String get devicePowerConsumption;
  String units(int count);

  // ============================================
  // БЫСТРЫЕ ДЕЙСТВИЯ
  // ============================================
  String get quickActions;
  String get allOff;
  String get sync;

  // ============================================
  // ПРИБОРЫ
  // ============================================
  String get appliances;
  String get all;
  String get hall;
  String get lounge;
  String get bedroom;
  String get kitchen;
  String get tvSet;
  String get stereoSystem;
  String get playStation;
  String get computer;
  String get lightFixture;
  String get backlight;
  String get lamp;

  // ============================================
  // ПОЛЬЗОВАТЕЛИ
  // ============================================
  String get occupants;
  String get seeAll;
  String get add;

  // ============================================
  // РАСПИСАНИЕ
  // ============================================
  String get schedule;
  String get wakeUp;
  String get away;
  String get home;
  String get sleep;

  // ============================================
  // ОБЩИЕ
  // ============================================
  String get save;
  String get cancel;
  String get confirm;
  String get delete;
  String get edit;
  String get loading;
  String get error;
  String get retry;
  String get noData;
}
