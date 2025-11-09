// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'BREEZ Home';

  @override
  String get smartClimateManagement => 'Умное управление климатом';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get loginSubtitle => 'С возвращением! Войдите, чтобы продолжить';

  @override
  String get registerSubtitle => 'Создайте аккаунт, чтобы начать';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get fullName => 'Полное имя';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get signInToAccount => 'Войдите в свой аккаунт';

  @override
  String get signUpForAccount => 'Зарегистрируйтесь для нового аккаунта';

  @override
  String get skipForNow => 'Пропустить';

  @override
  String get skipAuth => 'Продолжить без регистрации';

  @override
  String get rememberMe => 'Запомнить меня';

  @override
  String get termsAndConditions => 'Условия и положения';

  @override
  String get guestUser => 'Гость';

  @override
  String get registrationComingSoon =>
      'Функция регистрации скоро будет доступна';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get skip => 'Пропустить';

  @override
  String get welcomeToBreezHome => 'Добро пожаловать в\nBREEZ Home';

  @override
  String get smartHomeClimateControl =>
      'Умное управление климатом\nвашего дома под рукой';

  @override
  String get swipeToContinue => 'Свайпните для продолжения';

  @override
  String get controlYourDevices => 'Управляйте\nустройствами';

  @override
  String get manageHvacSystems =>
      'Управляйте всеми системами HVAC\nиз любого места в любое время';

  @override
  String get turnOnOffRemotely => 'Включение/выключение удаленно';

  @override
  String get readyToGetStarted => 'Готовы\nначать?';

  @override
  String get startControllingClimate =>
      'Начните управлять климатом вашего дома\nлегко и эффективно';

  @override
  String get getStarted => 'Начать';

  @override
  String get termsPrivacyAgreement =>
      'Продолжая, вы соглашаетесь с нашими\nУсловиями обслуживания и Политикой конфиденциальности';

  @override
  String get loadingBreezHome => 'Загрузка BREEZ Home';

  @override
  String get home => 'Главная';

  @override
  String get settings => 'Настройки';

  @override
  String get back => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get previous => 'Предыдущий';

  @override
  String get navigateBack => 'Вернуться назад';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get useDarkColorScheme => 'Использовать темную цветовую схему';

  @override
  String get themeChangeNextVersion =>
      'Смена темы будет доступна в следующей версии';

  @override
  String get units => 'Единицы измерения';

  @override
  String get temperatureUnits => 'Температура';

  @override
  String get celsius => 'Цельсий (°C)';

  @override
  String get fahrenheit => 'Фаренгейт (°F)';

  @override
  String unitsChangedTo(String unit) {
    return 'Единицы изменены на $unit';
  }

  @override
  String get notifications => 'Уведомления';

  @override
  String get pushNotifications => 'Push-уведомления';

  @override
  String get receiveInstantNotifications => 'Получать мгновенные уведомления';

  @override
  String get emailNotifications => 'Email-уведомления';

  @override
  String get receiveEmailReports => 'Получать отчеты на email';

  @override
  String notificationsState(String type, String state) {
    return '$type-уведомления $state';
  }

  @override
  String get language => 'Язык';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String languageChangedTo(String language) {
    return 'Язык изменен на $language';
  }

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get developer => 'Разработчик';

  @override
  String get license => 'Лицензия';

  @override
  String get checkUpdates => 'Проверить обновления';

  @override
  String get checkingUpdates => 'Проверка обновлений...';

  @override
  String get deviceManagement => 'Управление устройствами';

  @override
  String get search => 'Поиск';

  @override
  String get scanForDevices => 'Сканировать устройства';

  @override
  String get addDevice => 'Добавить устройство';

  @override
  String get editDevice => 'Редактировать устройство';

  @override
  String get removeDevice => 'Удалить устройство';

  @override
  String get deviceName => 'Название устройства';

  @override
  String get macAddress => 'MAC-адрес';

  @override
  String get location => 'Расположение';

  @override
  String get notFoundDevice => 'Не нашли\nустройство?';

  @override
  String get selectManually => 'Выбрать вручную';

  @override
  String get deviceUpdated => 'Устройство обновлено';

  @override
  String get deviceAdded => 'Устройство успешно добавлено';

  @override
  String get deviceRemoved => 'Устройство успешно удалено';

  @override
  String get scanQrCode => 'Сканировать QR-код';

  @override
  String get processingQrCode => 'Обработка QR-кода...';

  @override
  String get invalidQrCode => 'Неверный QR-код';

  @override
  String get deviceDetectedFromQr => 'Устройство обнаружено из QR-кода';

  @override
  String get enterMacManually => 'Или введите MAC-адрес вручную';

  @override
  String get invalidMacFormat =>
      'Неверный формат MAC-адреса (например, AA:BB:CC:DD:EE:FF)';

  @override
  String get deviceNameMinLength =>
      'Название устройства должно содержать минимум 3 символа';

  @override
  String get adding => 'Добавление...';

  @override
  String get pullToRefresh => 'Потяните для обновления';

  @override
  String get online => 'В сети';

  @override
  String get offline => 'Не в сети';

  @override
  String get edit => 'Редактировать';

  @override
  String get delete => 'Удалить';

  @override
  String confirmRemoveDevice(String name) {
    return 'Вы уверены, что хотите удалить $name?';
  }

  @override
  String wifiNetwork(String network) {
    return 'WiFi: $network';
  }

  @override
  String get hvacControl => 'BREEZ Home';

  @override
  String get temperature => 'Температура';

  @override
  String get humidity => 'Влажность';

  @override
  String get airQuality => 'Качество воздуха';

  @override
  String get fanSpeed => 'Скорость вентилятора';

  @override
  String get fan => 'Вентилятор';

  @override
  String get mode => 'Режим';

  @override
  String get operatingMode => 'Режим работы';

  @override
  String get power => 'Питание';

  @override
  String get on => 'Вкл';

  @override
  String get off => 'Выкл';

  @override
  String current(Object temp) {
    return 'Текущая';
  }

  @override
  String get target => 'Целевая';

  @override
  String get cooling => 'Охлаждение';

  @override
  String get heating => 'Обогрев';

  @override
  String get auto => 'Авто';

  @override
  String get low => 'Низкая';

  @override
  String get medium => 'Средний';

  @override
  String get high => 'Высокая';

  @override
  String get mode2 => 'Режим 2';

  @override
  String get humidifierAir => 'Увлажнитель\nвоздуха';

  @override
  String get purifierAir => 'Очиститель\nвоздуха';

  @override
  String get lighting => 'Освещение';

  @override
  String get mainLight => 'Основной свет';

  @override
  String get floorLamp => 'Торшер';

  @override
  String get unit => 'Блок';

  @override
  String get notificationsComingSoon =>
      'Функция уведомлений скоро будет доступна';

  @override
  String get favorite => 'Избранное';

  @override
  String get activity => 'Активность';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String get excellent => 'Отлично';

  @override
  String get good => 'Хорошо';

  @override
  String get moderate => 'Умеренно';

  @override
  String get poor => 'Плохо';

  @override
  String get veryPoor => 'Очень плохо';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get allOn => 'Все вкл';

  @override
  String get allOff => 'Все выкл';

  @override
  String get sync => 'Синхр.';

  @override
  String get schedule => 'Расписание';

  @override
  String get presets => 'Пресеты';

  @override
  String error(Object message) {
    return 'Ошибка';
  }

  @override
  String get connectionError => 'Ошибка подключения';

  @override
  String get serverError => 'Ошибка сервера';

  @override
  String get permissionRequired => 'Требуется разрешение';

  @override
  String get somethingWentWrong => 'Упс! Что-то пошло не так';

  @override
  String get unableToConnect =>
      'Не удается подключиться к серверу. Проверьте интернет-соединение.';

  @override
  String get serverErrorMessage =>
      'На нашей стороне произошла ошибка. Попробуйте позже.';

  @override
  String get permissionRequiredMessage =>
      'Эта функция требует дополнительных разрешений для работы.';

  @override
  String get networkConnectionFailed =>
      'Сбой сетевого подключения. Проверьте интернет-соединение.';

  @override
  String get requestTimedOut =>
      'Время ожидания запроса истекло. Попробуйте еще раз.';

  @override
  String get failedToConnect => 'Не удалось подключиться к серверу устройств';

  @override
  String connectionFailed(String error) {
    return 'Подключение не удалось: $error';
  }

  @override
  String failedToAddDevice(String error) {
    return 'Не удалось добавить устройство: $error';
  }

  @override
  String failedToRemoveDevice(String error) {
    return 'Не удалось удалить устройство: $error';
  }

  @override
  String failedToLoadMore(String error) {
    return 'Не удалось загрузить больше элементов: $error';
  }

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get retry => 'Повторить';

  @override
  String get retryConnection => 'Повторить подключение';

  @override
  String get refreshing => 'Обновление...';

  @override
  String get refreshDevices => 'Обновить устройства';

  @override
  String get retryingConnection => 'Повторная попытка подключения';

  @override
  String errorCode(String code) {
    return 'Код ошибки: $code';
  }

  @override
  String get errorCodeCopied => 'Код ошибки скопирован в буфер обмена';

  @override
  String get technicalDetails => 'Технические детали';

  @override
  String get doubleTapToRetry => 'Дважды нажмите для повтора';

  @override
  String get loading => 'Загрузка...';

  @override
  String get loadingDevices => 'Загрузка устройств...';

  @override
  String get allUnitsLoaded => 'Все блоки загружены';

  @override
  String get connecting => 'Подключение...';

  @override
  String get reconnecting => 'Переподключение...';

  @override
  String get noDevices => 'Нет устройств';

  @override
  String get noDevicesFound => 'Устройства не найдены';

  @override
  String get addFirstDevice => 'Добавьте первое устройство, чтобы начать';

  @override
  String get checkMqttSettings =>
      'Проверьте настройки MQTT-подключения\nи убедитесь, что устройства в сети';

  @override
  String get deviceNotSelected => 'Устройство не выбрано';

  @override
  String get openDeviceAddition => 'Открытие экрана добавления устройства';

  @override
  String get initializingCamera => 'Инициализация камеры...';

  @override
  String get cameraAccessRequired =>
      'Для сканирования QR-кодов требуется доступ к камере.\nРазрешите доступ к камере в настройках браузера.';

  @override
  String get cameraError => 'Ошибка камеры';

  @override
  String get cameraErrorMessage => 'Произошла ошибка при доступе к камере.';

  @override
  String get webCameraSetupRequired =>
      'Сканирование веб-камерой требует дополнительной настройки. Используйте ручной ввод или сканируйте с мобильного устройства.';

  @override
  String get cameraView => 'Вид с камеры';

  @override
  String get emailRequired => 'Email обязателен';

  @override
  String get invalidEmail => 'Введите корректный email';

  @override
  String get passwordRequired => 'Пароль обязателен';

  @override
  String passwordTooShort(int length) {
    return 'Пароль должен содержать минимум $length символов';
  }

  @override
  String nameRequired(String fieldName) {
    return '$fieldName обязательно';
  }

  @override
  String nameTooShort(String fieldName) {
    return '$fieldName должно содержать минимум 2 символа';
  }

  @override
  String get fillRequiredFields => 'Заполните все обязательные поля';

  @override
  String get pleaseAcceptTerms => 'Примите условия и положения';

  @override
  String minCharacters(int count) {
    return 'Мин. $count символов';
  }

  @override
  String get atLeast8Characters => 'Минимум 8 символов';

  @override
  String get uppercaseLetter => 'Заглавная буква';

  @override
  String get lowercaseLetter => 'Строчная буква';

  @override
  String get number => 'Цифра';

  @override
  String get specialCharacter => 'Специальный символ';

  @override
  String get weak => 'Слабый';

  @override
  String get strong => 'Сильный';

  @override
  String get veryStrong => 'Очень сильный';

  @override
  String editSchedule(String name) {
    return 'Редактировать $name';
  }

  @override
  String deleteSchedule(String name) {
    return 'Удалить $name';
  }

  @override
  String get editScheduleTooltip => 'Редактировать расписание';

  @override
  String get deleteScheduleTooltip => 'Удалить расписание';

  @override
  String get success => 'Успешно';

  @override
  String get settingsSaved =>
      'Настройки сохранены. Перезапустите приложение для применения изменений.';

  @override
  String get presetApplied => 'Пресет применен';

  @override
  String get allUnitsOn => 'Все блоки включены';

  @override
  String get allUnitsOff => 'Все блоки выключены';

  @override
  String get settingsSynced => 'Настройки синхронизированы со всеми блоками';

  @override
  String get scheduleAppliedToAll => 'Расписание применено ко всем блокам';

  @override
  String get errorChangingPower => 'Ошибка изменения питания';

  @override
  String get errorUpdatingMode => 'Ошибка обновления режима';

  @override
  String get errorUpdatingFanSpeed => 'Ошибка обновления скорости вентилятора';

  @override
  String get errorApplyingPreset => 'Ошибка применения пресета';

  @override
  String get errorTurningOnUnits => 'Ошибка включения блоков';

  @override
  String get errorTurningOffUnits => 'Ошибка выключения блоков';

  @override
  String get errorSyncingSettings => 'Ошибка синхронизации настроек';

  @override
  String get errorApplyingSchedule => 'Ошибка применения расписания';

  @override
  String get connected => 'Подключено';

  @override
  String get disconnected => 'Отключено';

  @override
  String get idle => 'Ожидание';

  @override
  String get active => 'Активно';

  @override
  String get inactive => 'Неактивно';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Выключено';

  @override
  String get available => 'Доступно';

  @override
  String get unavailable => 'Недоступно';

  @override
  String get maintenance => 'Обслуживание';

  @override
  String get activated => 'активировано';

  @override
  String get deactivated => 'деактивировано';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get close => 'Закрыть';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'ОК';

  @override
  String get apply => 'Применить';

  @override
  String get reset => 'Сбросить';

  @override
  String get clear => 'Очистить';

  @override
  String get done => 'Готово';

  @override
  String get add => 'Добавить';

  @override
  String get remove => 'Удалить';

  @override
  String get filter => 'Фильтр';

  @override
  String get sort => 'Сортировать';

  @override
  String get refresh => 'Обновить';

  @override
  String get logout => 'Выйти';

  @override
  String get status => 'Статус';

  @override
  String get details => 'Детали';

  @override
  String get more => 'Больше';

  @override
  String get less => 'Меньше';

  @override
  String get all => 'Все';

  @override
  String get none => 'Ничего';

  @override
  String get optional => 'Опционально';

  @override
  String get required => 'Обязательно';

  @override
  String get info => 'Информация';

  @override
  String get warning => 'Предупреждение';

  @override
  String get notification => 'Уведомление';

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
  String date(String date) {
    return '$date';
  }

  @override
  String get manageRules => 'Управление правилами (Скоро)';

  @override
  String get manageRulesComingSoon => 'Управление правилами (Скоро)';

  @override
  String get addUnitComingSoon =>
      'Функция добавления блока скоро будет доступна';

  @override
  String get livingRoom => 'Гостиная';

  @override
  String get bedroom => 'Спальня';

  @override
  String get kitchen => 'Кухня';

  @override
  String get vacuumCleaner => 'Пылесос';

  @override
  String get smartBulb => 'Умная лампа';

  @override
  String get humidifier => 'Увлажнитель';

  @override
  String get average => 'Среднее';

  @override
  String get min => 'Мин';

  @override
  String get max => 'Макс';

  @override
  String get temperatureHistory => 'История температуры';

  @override
  String get last24Hours => 'Последние 24 часа';

  @override
  String activeDevices(int count, int total) {
    return '$count из $total активно';
  }

  @override
  String get runDiagnostics => 'Запустить диагностику';

  @override
  String get systemHealth => 'Состояние системы';

  @override
  String get supplyFan => 'Приточный вентилятор';

  @override
  String get exhaustFan => 'Вытяжной вентилятор';

  @override
  String get heater => 'Нагреватель';

  @override
  String get recuperator => 'Рекуператор';

  @override
  String get sensors => 'Датчики';

  @override
  String get normal => 'Норма';

  @override
  String get sensorReadings => 'Показания датчиков';

  @override
  String get supplyAirTemp => 'Температура притока';

  @override
  String get outdoorTemp => 'Температура улицы';

  @override
  String get pressure => 'Давление';

  @override
  String get networkConnection => 'Сетевое подключение';

  @override
  String get network => 'Сеть';

  @override
  String get signal => 'Сигнал';

  @override
  String get ipAddress => 'IP адрес';

  @override
  String get notConnected => 'Не подключено';

  @override
  String get notAssigned => 'Не назначен';

  @override
  String get diagnosticsTitle => 'Диагностика';

  @override
  String get diagnosticsRunning => 'Выполняется диагностика системы...';

  @override
  String get diagnosticsComplete => 'Диагностика завершена. Система в норме.';

  @override
  String get scheduleSaved => 'Расписание успешно сохранено';

  @override
  String saveError(String error) {
    return 'Ошибка сохранения: $error';
  }

  @override
  String get unsavedChanges => 'Несохранённые изменения';

  @override
  String get unsavedChangesMessage =>
      'У вас есть несохранённые изменения. Выйти без сохранения?';

  @override
  String get exit => 'Выйти';

  @override
  String devicesFound(int count) {
    return '$count новых устройств';
  }

  @override
  String deviceFound(int count) {
    return '$count новое устройство';
  }

  @override
  String get notFoundDeviceTitle => 'Не нашли\nустройство?';

  @override
  String get selectManuallyButton => 'Выбрать вручную';

  @override
  String devicesAdded(int count, String plural) {
    return '$count $plural добавлено';
  }

  @override
  String get device => 'устройство';

  @override
  String get devices => 'устройства';
}
