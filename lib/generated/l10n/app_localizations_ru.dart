// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Управление HVAC';

  @override
  String get home => 'Главная';

  @override
  String get settings => 'Настройки';

  @override
  String get hvacControl => 'Управление HVAC';

  @override
  String activeDevices(int count, int total) {
    return '$count из $total активно';
  }

  @override
  String get connectionError => 'Ошибка подключения';

  @override
  String get retryConnection => 'Повторить подключение';

  @override
  String get noDevicesFound => 'Устройства не найдены';

  @override
  String get checkMqttSettings =>
      'Проверьте настройки MQTT\nи убедитесь, что устройства онлайн';

  @override
  String get loadingDevices => 'Загрузка устройств...';

  @override
  String get power => 'Питание';

  @override
  String get on => 'Вкл';

  @override
  String get off => 'Выкл';

  @override
  String get temperature => 'Температура';

  @override
  String get adjustTargetTemperature => 'Установите целевую температуру';

  @override
  String get deviceIsOff => 'Устройство выключено';

  @override
  String get target => 'Цель';

  @override
  String current(String temp) {
    return 'Текущая: $temp°C';
  }

  @override
  String get currentTemp => 'Текущая';

  @override
  String get min => 'Мин';

  @override
  String get max => 'Макс';

  @override
  String get operatingMode => 'Режим работы';

  @override
  String get selectHvacMode => 'Выберите режим работы HVAC';

  @override
  String get cooling => 'Охлаждение';

  @override
  String get heating => 'Обогрев';

  @override
  String get auto => 'Авто';

  @override
  String get fan => 'Вентиляция';

  @override
  String get coolDownToTarget => 'Охлаждение до целевой температуры';

  @override
  String get heatUpToTarget => 'Нагрев до целевой температуры';

  @override
  String get autoAdjustTemperature => 'Автоматическая регулировка температуры';

  @override
  String get circulateAir => 'Циркуляция воздуха без нагрева/охлаждения';

  @override
  String get fanSpeed => 'Скорость вентилятора';

  @override
  String get adjustAirflow => 'Регулировка интенсивности воздушного потока';

  @override
  String get low => 'Низкая';

  @override
  String get medium => 'Средняя';

  @override
  String get high => 'Высокая';

  @override
  String get gentleAirflow => 'Тихий режим работы';

  @override
  String get balancedAirflow => 'Сбалансированный поток и уровень шума';

  @override
  String get maximumAirflow =>
      'Максимальный поток для быстрого охлаждения/нагрева';

  @override
  String get autoAdjustSpeed => 'Автоматическая регулировка по температуре';

  @override
  String get powerLevel => 'Мощность';

  @override
  String get temperatureHistory => 'История температуры';

  @override
  String get last24Hours => 'Последние 24 часа';

  @override
  String get average => 'Средняя';

  @override
  String get appearance => 'Оформление';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get system => 'Системная';

  @override
  String get language => 'Язык';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get chinese => '中文';

  @override
  String get connection => 'Подключение';

  @override
  String get mqttSettings => 'Настройки MQTT';

  @override
  String get configureMqtt => 'Настройка подключения к MQTT брокеру';

  @override
  String get about => 'О программе';

  @override
  String get version => 'Версия';

  @override
  String get hvacUnit => 'HVAC устройство';

  @override
  String error(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get lightMode => 'Светлая тема';

  @override
  String get darkMode => 'Темная тема';

  @override
  String get systemDefault => 'Системная';

  @override
  String get toggleTheme => 'Переключить тему';

  @override
  String get mqttBroker => 'MQTT Брокер';

  @override
  String get username => 'Имя пользователя';

  @override
  String get settingsSaved =>
      'Настройки сохранены. Перезапустите приложение для применения изменений.';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get appDescription =>
      'Кросс-платформенное приложение для управления HVAC с интеграцией MQTT.';

  @override
  String get deviceManagement => 'Управление устройствами';

  @override
  String get addDevice => 'Добавить устройство';

  @override
  String get macAddress => 'MAC-адрес';

  @override
  String get deviceName => 'Имя устройства';

  @override
  String get livingRoom => 'Гостиная';

  @override
  String get location => 'Расположение';

  @override
  String get optional => 'Необязательно';

  @override
  String get fillRequiredFields =>
      'Пожалуйста, заполните все обязательные поля';

  @override
  String get deviceAdded => 'Устройство успешно добавлено';

  @override
  String get removeDevice => 'Удалить устройство';

  @override
  String confirmRemoveDevice(String name) {
    return 'Вы уверены, что хотите удалить $name?';
  }

  @override
  String get remove => 'Удалить';

  @override
  String get deviceRemoved => 'Устройство успешно удалено';

  @override
  String get cancel => 'Отмена';

  @override
  String get add => 'Добавить';

  @override
  String get mqttModeRequired =>
      'Для управления устройствами требуется режим MQTT';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get loginSubtitle => 'С возвращением! Войдите, чтобы продолжить';

  @override
  String get registerSubtitle => 'Создайте аккаунт, чтобы начать';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get fullName => 'Полное имя';

  @override
  String get emailRequired => 'Электронная почта обязательна';

  @override
  String get invalidEmail => 'Пожалуйста, введите корректный email';

  @override
  String get passwordRequired => 'Пароль обязателен';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get nameRequired => 'Имя обязательно';

  @override
  String get nameTooShort => 'Имя должно быть не менее 2 символов';

  @override
  String get dontHaveAccount => 'Нет аккаунта? Зарегистрируйтесь';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? Войдите';

  @override
  String get scanQrCode => 'Сканировать QR-код';

  @override
  String get enterMacManually => 'Или введите MAC-адрес вручную';

  @override
  String get logout => 'Выйти';

  @override
  String get skipAuth => 'Продолжить без регистрации';

  @override
  String get loading => 'Загрузка...';

  @override
  String get retry => 'Повторить';

  @override
  String get close => 'Закрыть';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Редактировать';

  @override
  String get delete => 'Удалить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'OK';

  @override
  String get search => 'Поиск';

  @override
  String get filter => 'Фильтр';

  @override
  String get sort => 'Сортировка';

  @override
  String get refresh => 'Обновить';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get previous => 'Назад';

  @override
  String get done => 'Готово';

  @override
  String get apply => 'Применить';

  @override
  String get reset => 'Сбросить';

  @override
  String get clear => 'Очистить';

  @override
  String get success => 'Успешно';

  @override
  String get failed => 'Ошибка';

  @override
  String get warning => 'Предупреждение';

  @override
  String get info => 'Информация';

  @override
  String get notification => 'Уведомление';

  @override
  String get online => 'Онлайн';

  @override
  String get offline => 'Офлайн';

  @override
  String get connected => 'Подключено';

  @override
  String get disconnected => 'Отключено';

  @override
  String get connecting => 'Подключение...';

  @override
  String get reconnecting => 'Переподключение...';

  @override
  String get idle => 'Ожидание';

  @override
  String get active => 'Активно';

  @override
  String get inactive => 'Неактивно';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Отключено';

  @override
  String get available => 'Доступно';

  @override
  String get unavailable => 'Недоступно';

  @override
  String get maintenance => 'Обслуживание';

  @override
  String get status => 'Статус';

  @override
  String get details => 'Детали';

  @override
  String get more => 'Ещё';

  @override
  String get less => 'Меньше';

  @override
  String get all => 'Все';

  @override
  String get none => 'Нет';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get week => 'Неделя';

  @override
  String get month => 'Месяц';

  @override
  String get year => 'Год';

  @override
  String get noDevices => 'Нет устройств';

  @override
  String get addFirstDevice => 'Добавьте первое устройство для начала работы';

  @override
  String get deviceNotSelected => 'Устройство не выбрано';

  @override
  String get errorChangingPower => 'Ошибка изменения питания';

  @override
  String get errorUpdatingMode => 'Ошибка обновления режима';

  @override
  String get errorUpdatingFanSpeed => 'Ошибка обновления скорости вентилятора';

  @override
  String get errorApplyingPreset => 'Ошибка применения пресета';

  @override
  String get presetApplied => 'Применён режим';

  @override
  String get allUnitsOn => 'Все установки включены';

  @override
  String get errorTurningOnUnits => 'Ошибка включения установок';

  @override
  String get allUnitsOff => 'Все установки выключены';

  @override
  String get errorTurningOffUnits => 'Ошибка выключения установок';

  @override
  String get settingsSynced =>
      'Настройки синхронизированы со всеми установками';

  @override
  String get errorSyncingSettings => 'Ошибка синхронизации';

  @override
  String get scheduleAppliedToAll => 'Расписание применено ко всем установкам';

  @override
  String get errorApplyingSchedule => 'Ошибка применения расписания';

  @override
  String get activated => 'активировано';

  @override
  String get deactivated => 'деактивировано';

  @override
  String get manageRules => 'Управление правилами (в разработке)';

  @override
  String get addUnitComingSoon => 'Add unit feature coming soon';
}
