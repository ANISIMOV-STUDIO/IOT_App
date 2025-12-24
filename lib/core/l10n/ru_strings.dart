import 'app_strings.dart';

/// Русская локализация (по умолчанию)
class RuStrings implements AppStrings {
  const RuStrings();

  // ============================================
  // НАВИГАЦИЯ
  // ============================================
  @override String get dashboard => 'Главная';
  @override String get rooms => 'Комнаты';
  @override String get recent => 'Недавние';
  @override String get bookmarks => 'Закладки';
  @override String get notifications => 'Уведомления';
  @override String get downloads => 'Загрузки';
  @override String get support => 'Поддержка';
  @override String get settings => 'Настройки';

  // ============================================
  // ПРИВЕТСТВИЕ
  // ============================================
  @override String get welcomeBack => 'С возвращением';
  @override String get user => 'Пользователь';

  // ============================================
  // УСТРОЙСТВА (HVAC)
  // ============================================
  @override String get myDevices => 'Мои устройства';
  @override String get ventilationUnit => 'Приточно-вытяжная установка';
  @override String get airCondition => 'Кондиционер';
  @override String get recuperator => 'Рекуператор';
  @override String get humidifier => 'Увлажнитель';
  @override String get dehumidifier => 'Осушитель';
  @override String get heater => 'Нагреватель';
  @override String get cooler => 'Охладитель';
  @override String get activeFor => 'Активно';
  @override String hours(int count) {
    if (count == 1) return '$count час';
    if (count >= 2 && count <= 4) return '$count часа';
    return '$count часов';
  }
  @override String get active => 'Активно';
  @override String get standby => 'Ожидание';
  @override String get turnedOn => 'Включено';
  @override String get turnedOff => 'Выключено';

  // ============================================
  // КЛИМАТ
  // ============================================
  @override String get temperature => 'Температура';
  @override String get targetTemperature => 'Целевая температура';
  @override String get currentTemperature => 'Текущая температура';
  @override String get humidity => 'Влажность';
  @override String get heating => 'Обогрев';
  @override String get cooling => 'Охлаждение';
  @override String get dry => 'Осушение';
  @override String get auto => 'Авто';
  @override String get ventilation => 'Вентиляция';
  @override String get deviceStatus => 'Статус устройства';
  @override String get airflowControl => 'Управление воздухопотоком';
  @override String get supplyAirflow => 'Приток';
  @override String get exhaustAirflow => 'Вытяжка';
  @override String get sensors => 'Датчики';
  @override String get presets => 'Пресеты';
  @override String get night => 'Ночной';
  @override String get turbo => 'Турбо';
  @override String get eco => 'Эко';

  // ============================================
  // КАЧЕСТВО ВОЗДУХА
  // ============================================
  @override String get airQuality => 'Качество воздуха';
  @override String get excellent => 'Отлично';
  @override String get good => 'Хорошо';
  @override String get moderate => 'Умеренно';
  @override String get poor => 'Плохо';
  @override String get hazardous => 'Опасно';
  @override String get co2 => 'CO₂';
  @override String get pollutants => 'Загрязнители';

  // ============================================
  // СТАТИСТИКА / ЭНЕРГИЯ
  // ============================================
  @override String get statistics => 'Статистика';
  @override String get usageStatus => 'Энергия';
  @override String get energyUsage => 'Потребление энергии';
  @override String get consumed => 'Потрачено';
  @override String get workTime => 'Время работы';
  @override String get efficiencyGood => 'Отличная эффективность!';
  @override String get today => 'Сегодня';
  @override String get thisWeek => 'Эта неделя';
  @override String get thisMonth => 'Этот месяц';
  @override String get totalSpent => 'Всего потрачено';
  @override String get totalHours => 'Всего часов';
  @override String get devicePowerConsumption => 'Потребление устройств';
  @override String units(int count) {
    if (count == 1) return '$count шт.';
    return '$count шт.';
  }

  // ============================================
  // БЫСТРЫЕ ДЕЙСТВИЯ
  // ============================================
  @override String get quickActions => 'Быстрые действия';
  @override String get allOff => 'Выкл. всё';
  @override String get sync => 'Синхр.';

  // ============================================
  // ПРИБОРЫ
  // ============================================
  @override String get appliances => 'Приборы';
  @override String get all => 'Все';
  @override String get hall => 'Холл';
  @override String get lounge => 'Гостиная';
  @override String get bedroom => 'Спальня';
  @override String get kitchen => 'Кухня';
  @override String get tvSet => 'Телевизор';
  @override String get stereoSystem => 'Стереосистема';
  @override String get playStation => 'PlayStation';
  @override String get computer => 'Компьютер';
  @override String get lightFixture => 'Светильник';
  @override String get backlight => 'Подсветка';
  @override String get lamp => 'Лампа';

  // ============================================
  // ПОЛЬЗОВАТЕЛИ
  // ============================================
  @override String get occupants => 'Жильцы';
  @override String get seeAll => 'Все';
  @override String get add => 'Добавить';

  // ============================================
  // РАСПИСАНИЕ
  // ============================================
  @override String get schedule => 'Расписание';
  @override String get wakeUp => 'Подъём';
  @override String get away => 'Вне дома';
  @override String get home => 'Дома';
  @override String get sleep => 'Сон';

  // ============================================
  // СИСТЕМА
  // ============================================
  @override String get systemStatus => 'Состояние системы';
  @override String get device => 'Устройство';
  @override String get firmware => 'Прошивка';
  @override String get connection => 'Связь';
  @override String get efficiency => 'КПД';
  @override String get filterStatus => 'Фильтр';
  @override String get uptime => 'Аптайм';

  // ============================================
  // ОБЩИЕ
  // ============================================
  @override String get save => 'Сохранить';
  @override String get cancel => 'Отмена';
  @override String get confirm => 'Подтвердить';
  @override String get delete => 'Удалить';
  @override String get edit => 'Изменить';
  @override String get loading => 'Загрузка...';
  @override String get error => 'Ошибка';
  @override String get retry => 'Повторить';
  @override String get noData => 'Нет данных';
}
