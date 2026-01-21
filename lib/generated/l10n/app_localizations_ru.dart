// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get haveAccount => 'Уже есть аккаунт?';

  @override
  String get consentRequired =>
      'Необходимо согласие на обработку персональных данных';

  @override
  String get consentLabel => 'Я согласен на обработку персональных данных';

  @override
  String get passwordHint => 'Минимум 8 символов, буквы и цифры';

  @override
  String get passwordRecovery => 'ВОССТАНОВЛЕНИЕ ПАРОЛЯ';

  @override
  String get enterEmailForReset =>
      'Введите email, указанный при регистрации.\nМы отправим код для сброса пароля.';

  @override
  String get sendCode => 'Отправить код';

  @override
  String codeSentTo(String email) {
    return 'Код отправлен на $email';
  }

  @override
  String get enterSixDigitCode => 'Введите 6-значный код';

  @override
  String get enterCodeSentTo => 'Введите код, отправленный на';

  @override
  String get resendCode => 'Отправить код повторно';

  @override
  String get passwordChangedSuccess => 'Пароль успешно изменён';

  @override
  String get home => 'Главная';

  @override
  String get settings => 'Настройки';

  @override
  String get back => 'Назад';

  @override
  String get notifications => 'Уведомления';

  @override
  String get pushNotifications => 'Push-уведомления';

  @override
  String get emailNotifications => 'Email-уведомления';

  @override
  String get alarmNotifications => 'Уведомления об авариях';

  @override
  String get language => 'Язык';

  @override
  String get addDevice => 'Добавить устройство';

  @override
  String get deviceName => 'Название';

  @override
  String get delete => 'Удалить';

  @override
  String get temperature => 'Температура';

  @override
  String get humidity => 'Влажность';

  @override
  String get operatingMode => 'Режим работы';

  @override
  String get targetTemperature => 'Целевая температура';

  @override
  String get intake => 'Приток';

  @override
  String get exhaust => 'Вытяжка';

  @override
  String get airflowRate => 'Поток';

  @override
  String get filter => 'Фильтр';

  @override
  String todayDate(String date) {
    return 'Сегодня, $date';
  }

  @override
  String get presets => 'Пресеты';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get noDevices => 'Нет устройств';

  @override
  String passwordTooShort(int length) {
    return 'Пароль должен содержать минимум $length символов';
  }

  @override
  String nameTooShort(String fieldName) {
    return '$fieldName должно содержать минимум 2 символа';
  }

  @override
  String get enterEmail => 'Введите email';

  @override
  String get enterPassword => 'Введите пароль';

  @override
  String get confirmPasswordRequired => 'Подтвердите пароль';

  @override
  String get passwordOnlyLatin =>
      'Пароль должен содержать только латинские буквы';

  @override
  String get passwordMustContainDigit => 'Должен содержать хотя бы одну цифру';

  @override
  String get passwordMustContainLetter =>
      'Должен содержать хотя бы одну латинскую букву';

  @override
  String get enterName => 'Введите имя';

  @override
  String enterField(String fieldName) {
    return 'Введите $fieldName';
  }

  @override
  String get nameOnlyLetters => 'Только буквы (допускаются пробелы и дефис)';

  @override
  String get invalidEmailFormat => 'Неверный формат email';

  @override
  String get schedule => 'Расписание';

  @override
  String allCount(int count) {
    return 'Все (+$count)';
  }

  @override
  String get noSchedule => 'Нет расписания';

  @override
  String get addScheduleForDevice => 'Добавьте расписание для устройства';

  @override
  String get nowLabel => 'Сейчас';

  @override
  String get alarms => 'Аварии';

  @override
  String get noAlarms => 'Нет аварий';

  @override
  String get systemWorkingNormally => 'Система работает штатно';

  @override
  String get alarmHistory => 'История аварий';

  @override
  String get noNotifications => 'Нет уведомлений';

  @override
  String get monday => 'Понедельник';

  @override
  String get tuesday => 'Вторник';

  @override
  String get wednesday => 'Среда';

  @override
  String get thursday => 'Четверг';

  @override
  String get friday => 'Пятница';

  @override
  String get saturday => 'Суббота';

  @override
  String get sunday => 'Воскресенье';

  @override
  String get mondayShort => 'Пн';

  @override
  String get tuesdayShort => 'Вт';

  @override
  String get wednesdayShort => 'Ср';

  @override
  String get thursdayShort => 'Чт';

  @override
  String get fridayShort => 'Пт';

  @override
  String get saturdayShort => 'Сб';

  @override
  String get sundayShort => 'Вс';

  @override
  String get save => 'Сохранить';

  @override
  String get enable => 'Включить';

  @override
  String get cancel => 'Отмена';

  @override
  String get logout => 'Выйти';

  @override
  String get today => 'Сегодня';

  @override
  String get devices => 'Устройства';

  @override
  String get profile => 'Профиль';

  @override
  String get profileUpdated => 'Профиль обновлён';

  @override
  String get passwordChanged => 'Пароль изменён. Войдите снова.';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get account => 'Аккаунт';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get theme => 'Тема';

  @override
  String get darkThemeLabel => 'Темная';

  @override
  String get lightThemeLabel => 'Светлая';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get currentPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get passwordConfirmation => 'Подтверждение пароля';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get change => 'Сменить';

  @override
  String get allNotifications => 'Все уведомления';

  @override
  String get allAlarms => 'Все аварии';

  @override
  String get justNow => 'Только что';

  @override
  String minutesAgo(int count) {
    return '$count мин назад';
  }

  @override
  String hoursAgo(int count) {
    return '$count ч назад';
  }

  @override
  String daysAgo(int count) {
    return '$count дн назад';
  }

  @override
  String get addFirstEntry => 'Добавьте первую запись';

  @override
  String alarmCode(String code) {
    return 'Код $code';
  }

  @override
  String get activeAlarm => 'АКТИВНА';

  @override
  String get modeAuto => 'Авто';

  @override
  String get modeEco => 'Эко';

  @override
  String get modeNight => 'Ночь';

  @override
  String get modeBoost => 'ТУРБО';

  @override
  String modeFor(String name) {
    return 'Режим $name';
  }

  @override
  String get deviceDeleted => 'Установка удалена';

  @override
  String get nameChanged => 'Название изменено';

  @override
  String get timeSet => 'Время установлено';

  @override
  String get notificationsInDevelopment => 'Уведомления: функция в разработке';

  @override
  String get allDevicesTurnedOff => 'Все устройства выключены';

  @override
  String get addFirstDeviceByMac => 'Добавьте первую установку по MAC-адресу';

  @override
  String get addUnit => 'Добавить установку';

  @override
  String get enterMacAddress => 'Введите MAC-адрес';

  @override
  String get macAddressMustContain12Chars =>
      'MAC-адрес должен содержать 12 символов';

  @override
  String get macAddressOnlyHex => 'MAC-адрес может содержать только 0-9 и A-F';

  @override
  String get deviceMacAddress => 'MAC-адрес устройства';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get addButton => 'Добавить';

  @override
  String get deviceNameExample => 'Например: Гостиная';

  @override
  String get enterDeviceName => 'Введите название установки';

  @override
  String get macAddressDisplayedOnRemote =>
      'MAC-адрес отображается на экране пульта устройства';

  @override
  String get analytics => 'Аналитика';

  @override
  String get devicesWillAppear =>
      'Устройства появятся здесь\nпосле подключения';

  @override
  String get presetComfort => 'Комфорт';

  @override
  String get presetComfortDesc => 'Оптимальный режим';

  @override
  String get presetEco => 'Эко';

  @override
  String get presetEcoDesc => 'Энергосбережение';

  @override
  String get presetNight => 'Ночь';

  @override
  String get presetNightDesc => 'Тихий режим';

  @override
  String get presetTurbo => 'Турбо';

  @override
  String get presetTurboDesc => 'Максимальная мощность';

  @override
  String get presetAway => 'Нет дома';

  @override
  String get presetAwayDesc => 'Минимальный режим';

  @override
  String get presetSleep => 'Сон';

  @override
  String get presetSleepDesc => 'Комфортный сон';

  @override
  String devicesCount(int count) {
    return '$count устройств';
  }

  @override
  String get thisMonth => 'Этот месяц';

  @override
  String get totalTime => 'Общее время';

  @override
  String energyKwh(String value) {
    return '$value кВт⋅ч';
  }

  @override
  String hoursCount(int count) {
    return '$count часов';
  }

  @override
  String get airflow => 'Поток воздуха';

  @override
  String get graphTemperatureLabel => 'Температура';

  @override
  String get graphHumidityLabel => 'Влажность';

  @override
  String get graphAirflowLabel => 'Поток воздуха';

  @override
  String get tempShort => 'Темп';

  @override
  String get humidShort => 'Влаж';

  @override
  String get airflowShort => 'Поток';

  @override
  String get minShort => 'Мин';

  @override
  String get maxShort => 'Макс';

  @override
  String get avgShort => 'Сред';

  @override
  String get cubicMetersPerHour => 'м³/ч';

  @override
  String get readAll => 'Прочитать все';

  @override
  String get later => 'Позже';

  @override
  String get updateNow => 'Обновить сейчас';

  @override
  String get whatsNew => 'Что нового?';

  @override
  String get hide => 'Скрыть';

  @override
  String get errorNoConnection => 'Нет соединения';

  @override
  String get errorServer => 'Ошибка сервера';

  @override
  String errorServerWithCode(int code) {
    return 'Ошибка сервера ($code)';
  }

  @override
  String get errorNotFound => 'Не найдено';

  @override
  String get errorAuthRequired => 'Требуется авторизация';

  @override
  String get errorSomethingWrong => 'Что-то пошло не так';

  @override
  String get errorCheckInternet =>
      'Проверьте подключение к интернету\nи попробуйте снова';

  @override
  String get errorServerProblems =>
      'Проблемы на стороне сервера.\nМы уже работаем над исправлением.';

  @override
  String errorResourceNotFound(String resource) {
    return 'Запрошенные $resource не найдены.\nВозможно, они были удалены.';
  }

  @override
  String get errorSessionExpired =>
      'Ваша сессия истекла.\nПожалуйста, войдите заново.';

  @override
  String get errorUnexpected =>
      'Произошла непредвиденная ошибка.\nПопробуйте повторить попытку.';

  @override
  String get errorNoInternet => 'Нет соединения с интернетом';

  @override
  String get errorServerUnavailable => 'Сервер недоступен';

  @override
  String get errorLoadingFailed => 'Не удалось загрузить устройства';

  @override
  String get emptyNoDevicesTitle => 'Нет устройств';

  @override
  String get emptyNoDevicesMessage =>
      'Устройства появятся здесь\nпосле подключения';

  @override
  String get emptyNothingFound => 'Ничего не найдено';

  @override
  String emptyNoSearchResults(String query) {
    return 'По запросу «$query»\nничего не найдено.\nПопробуйте изменить параметры поиска.';
  }

  @override
  String get emptyNoNotificationsTitle => 'Нет уведомлений';

  @override
  String get emptyNoNotificationsMessage =>
      'У вас пока нет уведомлений.\nНовые уведомления появятся здесь.';

  @override
  String get emptyHistoryTitle => 'История пуста';

  @override
  String get emptyHistoryMessage =>
      'История операций появится\nпосле первых действий.';

  @override
  String get emptyNoScheduleTitle => 'Нет расписания';

  @override
  String get emptyNoScheduleMessage =>
      'Добавьте записи расписания\nдля автоматического управления';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get scheduleAdd => 'Добавить';

  @override
  String get scheduleNewEntry => 'Новая запись';

  @override
  String get scheduleEditEntry => 'Редактировать запись';

  @override
  String get scheduleDeleteConfirm => 'Удалить запись?';

  @override
  String scheduleDeleteMessage(String entry) {
    return 'Запись «$entry» будет удалена.';
  }

  @override
  String get scheduleDayLabel => 'День недели';

  @override
  String get scheduleStartLabel => 'Начало';

  @override
  String get scheduleEndLabel => 'Конец';

  @override
  String get scheduleModeLabel => 'Режим';

  @override
  String get scheduleDayTemp => 'Дневная температура';

  @override
  String get scheduleNightTemp => 'Ночная температура';

  @override
  String get scheduleActive => 'Активно';

  @override
  String scheduleDayNightTemp(int day, int night) {
    return 'День: $day° / Ночь: $night°';
  }

  @override
  String get modeCooling => 'Охлаждение';

  @override
  String get modeHeating => 'Нагрев';

  @override
  String get modeVentilation => 'Вентиляция';

  @override
  String get statusOnline => 'Онлайн';

  @override
  String get statusOffline => 'Оффлайн';

  @override
  String get statusRunning => 'В работе';

  @override
  String get statusStopped => 'Выключен';

  @override
  String get syncedAt => 'Обновлено:';

  @override
  String get statusEnabled => 'Включено';

  @override
  String get statusDisabled => 'Выключено';

  @override
  String get holdToToggle => 'Удерживайте для активации дня';

  @override
  String get selectTime => 'Выбор времени';

  @override
  String get setDateTime => 'Установить дату и время';

  @override
  String get confirm => 'Готово';

  @override
  String get statusResolved => 'РЕШЕНА';

  @override
  String get statusActive => 'АКТИВНА';

  @override
  String get alarmHistoryTitle => 'История аварий';

  @override
  String get alarmHistoryEmpty => 'История аварий пуста';

  @override
  String get alarmNoAlarms => 'Аварий не зафиксировано';

  @override
  String alarmCodeLabel(int code) {
    return 'Код $code';
  }

  @override
  String get alarmOccurredAt => 'Возникла';

  @override
  String get alarmClearedAt => 'Устранена';

  @override
  String get alarmReset => 'Сброс';

  @override
  String get janShort => 'янв';

  @override
  String get febShort => 'фев';

  @override
  String get marShort => 'мар';

  @override
  String get aprShort => 'апр';

  @override
  String get mayShort => 'май';

  @override
  String get junShort => 'июн';

  @override
  String get julShort => 'июл';

  @override
  String get augShort => 'авг';

  @override
  String get sepShort => 'сен';

  @override
  String get octShort => 'окт';

  @override
  String get novShort => 'ноя';

  @override
  String get decShort => 'дек';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsReadAll => 'Все уведомления прочитаны';

  @override
  String get notificationDeleted => 'Уведомление удалено';

  @override
  String get unitSettingsTitle => 'Настройки установки';

  @override
  String get unitSettingsName => 'Название:';

  @override
  String get unitSettingsStatus => 'Статус:';

  @override
  String get unitSettingsNewName => 'Новое название';

  @override
  String get unitSettingsEnterName => 'Введите название';

  @override
  String get unitSettingsRename => 'Переименовать';

  @override
  String get unitSettingsRenameSubtitle => 'Изменить название установки';

  @override
  String get unitSettingsDelete => 'Удалить установку';

  @override
  String get unitSettingsDeleteSubtitle => 'Отвязать устройство от аккаунта';

  @override
  String get unitSettingsDeleteConfirm => 'Удалить установку?';

  @override
  String unitSettingsDeleteMessage(String name) {
    return 'Установка «$name» будет отвязана от вашего аккаунта. Вы сможете снова добавить её по MAC-адресу.';
  }

  @override
  String get unitSettingsSetTime => 'Установить время';

  @override
  String get updateAvailable => 'Доступна новая версия';

  @override
  String updateVersionAvailable(String version) {
    return 'Доступна версия $version';
  }

  @override
  String get updateMessage =>
      'Вышло обновление приложения. Перезагрузите страницу, чтобы получить новые функции и исправления.';

  @override
  String get verifyEmailTitle => 'ПОДТВЕРЖДЕНИЕ EMAIL';

  @override
  String get verifyEmailSent => 'Мы отправили 6-значный код подтверждения на';

  @override
  String get verifyEmailResend => 'Отправить код повторно';

  @override
  String get verifyEmailCodeSent => 'Код отправлен на email';

  @override
  String get tooltipEdit => 'Редактировать';

  @override
  String get tooltipDelete => 'Удалить';

  @override
  String get tooltipAdd => 'Добавить';

  @override
  String get dataResource => 'данные';

  @override
  String get defaultUserName => 'Пользователь';

  @override
  String get heating => 'Нагрев';

  @override
  String get cooling => 'Охлаждение';

  @override
  String get outdoorTemp => 'Температура уличного воздуха';

  @override
  String get indoorTemp => 'Температура воздуха в помещении';

  @override
  String get supplyTempAfterRecup =>
      'Температура приточного воздуха после рекуператора';

  @override
  String get supplyTemp => 'Температура приточного воздуха';

  @override
  String get co2Level => 'Концентрация CO2';

  @override
  String get recuperatorEfficiency =>
      'Температурная эффективность рекуператора';

  @override
  String get freeCooling => 'Свободное охлаждение рекуператора';

  @override
  String get heaterPerformance =>
      'Текущая производительность электрического нагревателя';

  @override
  String get coolerStatus => 'Статус охладителя';

  @override
  String get ductPressure => 'Текущее значение давления в воздуховоде';

  @override
  String get relativeHumidity => 'Относительная влажность';

  @override
  String get outdoor => 'Улица';

  @override
  String get indoor => 'Помещение';

  @override
  String get afterRecup => 'После рекуп.';

  @override
  String get supply => 'Приток';

  @override
  String get efficiency => 'КПД';

  @override
  String get freeCool => 'Охл. рекуп.';

  @override
  String get on => 'ВКЛ';

  @override
  String get off => 'ВЫКЛ';

  @override
  String get heater => 'Нагреватель';

  @override
  String get cooler => 'Охладитель';

  @override
  String get pressure => 'Давление';

  @override
  String get noDeviceSelected => 'Устройство не выбрано';

  @override
  String get modes => 'Режимы';

  @override
  String get modeBasic => 'Базовый';

  @override
  String get modeIntensive => 'Интенсив';

  @override
  String get modeEconomy => 'Эконом';

  @override
  String get modeMaxPerformance => 'Макс.';

  @override
  String get modeKitchen => 'Кухня';

  @override
  String get modeFireplace => 'Камин';

  @override
  String get modeVacation => 'Отпуск';

  @override
  String get modeCustom => 'Свой';

  @override
  String get controls => 'Управление';

  @override
  String get sensors => 'Датчики';

  @override
  String get temperatureSetpoints => 'Уставки температуры';

  @override
  String get fanSpeed => 'Скорость вентиляторов';

  @override
  String get status => 'Статус';

  @override
  String get seeAll => 'Показать всё';

  @override
  String get outdoorTempDesc => 'Температура воздуха снаружи здания';

  @override
  String get indoorTempDesc => 'Температура воздуха внутри помещения';

  @override
  String get supplyTempAfterRecupDesc =>
      'Температура приточного воздуха после теплообмена в рекуператоре';

  @override
  String get supplyTempDesc =>
      'Температура воздуха на выходе из вентиляционной установки';

  @override
  String get co2LevelDesc =>
      'Уровень углекислого газа в помещении. Норма: до 1000 ppm';

  @override
  String get recuperatorEfficiencyDesc =>
      'Эффективность теплообмена в рекуператоре';

  @override
  String get freeCoolingDesc =>
      'Режим бесплатного охлаждения наружным воздухом через рекуператор';

  @override
  String get heaterPerformanceDesc =>
      'Текущая мощность электрического нагревателя';

  @override
  String get coolerStatusDesc => 'Статус работы охладителя воздуха';

  @override
  String get ductPressureDesc => 'Давление воздуха в воздуховоде (Па)';

  @override
  String get humidityDesc => 'Относительная влажность воздуха в помещении';

  @override
  String get unitPoweredOn => 'включен';

  @override
  String get unitPoweredOff => 'выключен';

  @override
  String get unitSelected => 'выбран';

  @override
  String get devicesList => 'Список устройств';

  @override
  String get segmentSelection => 'Выбор сегмента';

  @override
  String noEntriesForDay(String day) {
    return 'Нет записей на $day';
  }

  @override
  String get tapToAdd => 'Нажмите, чтобы добавить';

  @override
  String get quickSensorsTitle => 'Показатели на главной';

  @override
  String get quickSensorsHint => 'Нажмите на показатель, чтобы заменить';

  @override
  String get sensorInteractionHint =>
      'Нажмите для описания • Зажмите для выбора';

  @override
  String get close => 'Закрыть';

  @override
  String get eventLogs => 'Журнал событий';

  @override
  String get eventLogsDescription => 'История изменений настроек устройства';

  @override
  String get logColumnTime => 'Время';

  @override
  String get logColumnType => 'Тип';

  @override
  String get logColumnCategory => 'Категория';

  @override
  String get logColumnProperty => 'Параметр';

  @override
  String get logColumnOldValue => 'Было';

  @override
  String get logColumnNewValue => 'Стало';

  @override
  String get logColumnDescription => 'Описание';

  @override
  String get logTypeSettings => 'Настройка';

  @override
  String get logTypeAlarm => 'Авария';

  @override
  String get filterAll => 'Все';

  @override
  String get logCategoryMode => 'Режим';

  @override
  String get logCategoryTimer => 'Таймер';

  @override
  String get logCategoryAlarm => 'Авария';

  @override
  String get logNoData => 'Нет записей';

  @override
  String get logNoDataHint => 'Попробуйте изменить фильтр';

  @override
  String get logLoadMore => 'Загрузить ещё';

  @override
  String logShowing(int count, int total) {
    return 'Показано: $count из $total';
  }

  @override
  String logPage(int current, int total) {
    return 'Страница $current из $total';
  }

  @override
  String get serviceEngineer => 'Сервис';

  @override
  String get sessionExpired => 'Сессия истекла. Выполняется выход...';
}
