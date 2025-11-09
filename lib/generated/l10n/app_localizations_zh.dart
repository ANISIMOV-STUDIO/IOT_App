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
  String get smartClimateManagement => '智能气候管理';

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
  String get confirmPassword => '确认密码';

  @override
  String get fullName => '全名';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get createAccount => '创建账户';

  @override
  String get signInToAccount => '登录您的账户';

  @override
  String get signUpForAccount => '注册新账户';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get skipAuth => '无需注册继续';

  @override
  String get rememberMe => '记住我';

  @override
  String get termsAndConditions => '条款和条件';

  @override
  String get guestUser => '访客用户';

  @override
  String get registrationComingSoon => '注册功能即将推出';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get skip => '跳过';

  @override
  String get welcomeToBreezHome => '欢迎使用\nBREEZ Home';

  @override
  String get smartHomeClimateControl => '您的智能家居气候控制\n触手可及';

  @override
  String get swipeToContinue => '滑动继续';

  @override
  String get controlYourDevices => '控制您的\n设备';

  @override
  String get manageHvacSystems => '随时随地管理您的所有\nHVAC系统';

  @override
  String get turnOnOffRemotely => '远程开关';

  @override
  String get readyToGetStarted => '准备好\n开始了吗？';

  @override
  String get startControllingClimate => '轻松高效地开始\n控制您的家庭气候';

  @override
  String get getStarted => '开始使用';

  @override
  String get termsPrivacyAgreement => '继续即表示您同意我们的\n服务条款和隐私政策';

  @override
  String get loadingBreezHome => '加载 BREEZ Home';

  @override
  String get home => '主页';

  @override
  String get settings => '设置';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get navigateBack => '返回';

  @override
  String get settingsTitle => '设置';

  @override
  String get appearance => '外观';

  @override
  String get darkTheme => '深色主题';

  @override
  String get useDarkColorScheme => '使用深色配色方案';

  @override
  String get themeChangeNextVersion => '主题更改将在下一个版本中提供';

  @override
  String get units => '单位';

  @override
  String get temperatureUnits => '温度';

  @override
  String get celsius => '摄氏度 (°C)';

  @override
  String get fahrenheit => '华氏度 (°F)';

  @override
  String unitsChangedTo(String unit) {
    return '单位已更改为 $unit';
  }

  @override
  String get notifications => '通知';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get receiveInstantNotifications => '接收即时通知';

  @override
  String get emailNotifications => '电子邮件通知';

  @override
  String get receiveEmailReports => '通过电子邮件接收报告';

  @override
  String notificationsState(String type, String state) {
    return '$type通知$state';
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
    return '语言已更改为 $language';
  }

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get developer => '开发者';

  @override
  String get license => '许可证';

  @override
  String get checkUpdates => '检查更新';

  @override
  String get checkingUpdates => '正在检查更新...';

  @override
  String get deviceManagement => '设备管理';

  @override
  String get search => '搜索';

  @override
  String get scanForDevices => '扫描设备';

  @override
  String get addDevice => '添加设备';

  @override
  String get editDevice => '编辑设备';

  @override
  String get removeDevice => '删除设备';

  @override
  String get deviceName => '设备名称';

  @override
  String get macAddress => 'MAC地址';

  @override
  String get location => '位置';

  @override
  String get notFoundDevice => '未找到\n设备？';

  @override
  String get selectManually => '手动选择';

  @override
  String get deviceUpdated => '设备已更新';

  @override
  String get deviceAdded => '设备添加成功';

  @override
  String get deviceRemoved => '设备删除成功';

  @override
  String get scanQrCode => '扫描二维码';

  @override
  String get processingQrCode => '处理二维码中...';

  @override
  String get invalidQrCode => '无效的二维码';

  @override
  String get deviceDetectedFromQr => '从二维码检测到设备';

  @override
  String get enterMacManually => '或手动输入MAC地址';

  @override
  String get invalidMacFormat => 'MAC地址格式无效（例如：AA:BB:CC:DD:EE:FF）';

  @override
  String get deviceNameMinLength => '设备名称至少需要3个字符';

  @override
  String get adding => '添加中...';

  @override
  String get pullToRefresh => '下拉刷新';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

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
  String get humidity => '湿度';

  @override
  String get airQuality => '空气质量';

  @override
  String get fanSpeed => '风速';

  @override
  String get fan => '送风';

  @override
  String get mode => '模式';

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
  String get mode2 => '模式2';

  @override
  String get humidifierAir => '空气\n加湿器';

  @override
  String get purifierAir => '空气\n净化器';

  @override
  String get lighting => '照明';

  @override
  String get mainLight => '主灯';

  @override
  String get floorLamp => '落地灯';

  @override
  String get unit => '设备';

  @override
  String get notificationsComingSoon => '通知功能即将推出';

  @override
  String get favorite => '收藏';

  @override
  String get activity => '活动';

  @override
  String get seeAll => '查看全部';

  @override
  String get excellent => '优秀';

  @override
  String get good => '良好';

  @override
  String get moderate => '中等';

  @override
  String get poor => '差';

  @override
  String get veryPoor => '很差';

  @override
  String get quickActions => '快捷操作';

  @override
  String get allOn => '全部开启';

  @override
  String get allOff => '全部关闭';

  @override
  String get sync => '同步';

  @override
  String get schedule => '时间表';

  @override
  String get presets => '预设';

  @override
  String error(Object message) {
    return '错误：$message';
  }

  @override
  String get connectionError => '连接错误';

  @override
  String get serverError => '服务器错误';

  @override
  String get permissionRequired => '需要权限';

  @override
  String get somethingWentWrong => '哎呀！出了点问题';

  @override
  String get unableToConnect => '无法连接到服务器。请检查您的互联网连接。';

  @override
  String get serverErrorMessage => '我们这边出了点问题。请稍后再试。';

  @override
  String get permissionRequiredMessage => '此功能需要额外权限才能正常工作。';

  @override
  String get networkConnectionFailed => '网络连接失败。请检查您的互联网连接。';

  @override
  String get requestTimedOut => '请求超时。请重试。';

  @override
  String get failedToConnect => '无法连接到设备服务器';

  @override
  String connectionFailed(String error) {
    return '连接失败：$error';
  }

  @override
  String failedToAddDevice(String error) {
    return '添加设备失败：$error';
  }

  @override
  String failedToRemoveDevice(String error) {
    return '删除设备失败：$error';
  }

  @override
  String failedToLoadMore(String error) {
    return '加载更多项目失败：$error';
  }

  @override
  String get tryAgain => '重试';

  @override
  String get retry => '重试';

  @override
  String get retryConnection => '重试连接';

  @override
  String get refreshing => '刷新中...';

  @override
  String get refreshDevices => '刷新设备';

  @override
  String get retryingConnection => '重试连接';

  @override
  String errorCode(String code) {
    return '错误代码：$code';
  }

  @override
  String get errorCodeCopied => '错误代码已复制到剪贴板';

  @override
  String get technicalDetails => '技术详情';

  @override
  String get doubleTapToRetry => '双击重试';

  @override
  String get loading => '加载中...';

  @override
  String get loadingDevices => '加载设备中...';

  @override
  String get allUnitsLoaded => '所有设备已加载';

  @override
  String get connecting => '连接中...';

  @override
  String get reconnecting => '重新连接中...';

  @override
  String get noDevices => '无设备';

  @override
  String get noDevicesFound => '未找到设备';

  @override
  String get addFirstDevice => '添加您的第一个设备开始使用';

  @override
  String get checkMqttSettings => '请检查MQTT连接设置\n并确保设备在线';

  @override
  String get deviceNotSelected => '未选择设备';

  @override
  String get openDeviceAddition => '打开设备添加屏幕';

  @override
  String get initializingCamera => '初始化相机...';

  @override
  String get cameraAccessRequired => '扫描二维码需要相机访问权限。\n请在浏览器设置中启用相机权限。';

  @override
  String get cameraError => '相机错误';

  @override
  String get cameraErrorMessage => '访问相机时发生错误。';

  @override
  String get webCameraSetupRequired => '网络摄像头扫描需要额外设置。请使用手动输入或从移动设备扫描。';

  @override
  String get cameraView => '相机视图';

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
  String get pleaseAcceptTerms => '请接受条款和条件';

  @override
  String minCharacters(int count) {
    return '最少 $count 个字符';
  }

  @override
  String get atLeast8Characters => '至少8个字符';

  @override
  String get uppercaseLetter => '大写字母';

  @override
  String get lowercaseLetter => '小写字母';

  @override
  String get number => '数字';

  @override
  String get specialCharacter => '特殊字符';

  @override
  String get weak => '弱';

  @override
  String get strong => '强';

  @override
  String get veryStrong => '很强';

  @override
  String editSchedule(String name) {
    return '编辑 $name';
  }

  @override
  String deleteSchedule(String name) {
    return '删除 $name';
  }

  @override
  String get editScheduleTooltip => '编辑时间表';

  @override
  String get deleteScheduleTooltip => '删除时间表';

  @override
  String get success => '成功';

  @override
  String get settingsSaved => '设置已保存。请重启应用以应用更改。';

  @override
  String get presetApplied => '预设已应用';

  @override
  String get allUnitsOn => '所有设备已开启';

  @override
  String get allUnitsOff => '所有设备已关闭';

  @override
  String get settingsSynced => '设置已同步到所有设备';

  @override
  String get scheduleAppliedToAll => '时间表已应用到所有设备';

  @override
  String get errorChangingPower => '更改电源错误';

  @override
  String get errorUpdatingMode => '更新模式错误';

  @override
  String get errorUpdatingFanSpeed => '更新风速时出错';

  @override
  String get errorApplyingPreset => '应用预设错误';

  @override
  String get errorTurningOnUnits => '开启设备时出错';

  @override
  String get errorTurningOffUnits => '关闭设备时出错';

  @override
  String get errorSyncingSettings => '同步设置时出错';

  @override
  String get errorApplyingSchedule => '应用时间表错误';

  @override
  String get connected => '已连接';

  @override
  String get disconnected => '已断开';

  @override
  String get idle => '空闲';

  @override
  String get active => '活跃';

  @override
  String get inactive => '不活跃';

  @override
  String get enabled => '已启用';

  @override
  String get disabled => '已禁用';

  @override
  String get available => '可用';

  @override
  String get unavailable => '不可用';

  @override
  String get maintenance => '维护中';

  @override
  String get activated => '已激活';

  @override
  String get deactivated => '已停用';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get confirm => '确认';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get ok => '确定';

  @override
  String get apply => '应用';

  @override
  String get reset => '重置';

  @override
  String get clear => '清除';

  @override
  String get done => '完成';

  @override
  String get add => '添加';

  @override
  String get remove => '删除';

  @override
  String get filter => '筛选';

  @override
  String get sort => '排序';

  @override
  String get refresh => '刷新';

  @override
  String get logout => '退出登录';

  @override
  String get status => '状态';

  @override
  String get details => '详情';

  @override
  String get more => '更多';

  @override
  String get less => '更少';

  @override
  String get all => '全部';

  @override
  String get none => '无';

  @override
  String get optional => '可选';

  @override
  String get required => '必填';

  @override
  String get info => '信息';

  @override
  String get warning => '警告';

  @override
  String get notification => '通知';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get week => '周';

  @override
  String get month => '月';

  @override
  String get year => '年';

  @override
  String date(String date) {
    return '$date';
  }

  @override
  String get manageRules => '管理规则（即将推出）';

  @override
  String get manageRulesComingSoon => '管理规则（即将推出）';

  @override
  String get addUnitComingSoon => '添加设备功能即将推出';

  @override
  String get livingRoom => '客厅';

  @override
  String get bedroom => '卧室';

  @override
  String get kitchen => '厨房';

  @override
  String get vacuumCleaner => '吸尘器';

  @override
  String get smartBulb => '智能灯泡';

  @override
  String get humidifier => '加湿器';

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

  @override
  String get runDiagnostics => '运行诊断';

  @override
  String get systemHealth => '系统健康';

  @override
  String get supplyFan => '送风扇';

  @override
  String get exhaustFan => '排气扇';

  @override
  String get heater => '加热器';

  @override
  String get recuperator => '热回收器';

  @override
  String get sensors => '传感器';

  @override
  String get normal => '正常';

  @override
  String get sensorReadings => '传感器读数';

  @override
  String get supplyAirTemp => '送风温度';

  @override
  String get outdoorTemp => '室外温度';

  @override
  String get pressure => '压力';

  @override
  String get networkConnection => '网络连接';

  @override
  String get network => '网络';

  @override
  String get signal => '信号';

  @override
  String get ipAddress => 'IP地址';

  @override
  String get notConnected => '未连接';

  @override
  String get notAssigned => '未分配';

  @override
  String get diagnosticsTitle => '诊断';

  @override
  String get diagnosticsRunning => '正在运行系统诊断...';

  @override
  String get diagnosticsComplete => '诊断完成。系统正常。';

  @override
  String get scheduleSaved => '时间表保存成功';

  @override
  String saveError(String error) {
    return '保存错误：$error';
  }

  @override
  String get unsavedChanges => '未保存的更改';

  @override
  String get unsavedChangesMessage => '您有未保存的更改。是否退出而不保存？';

  @override
  String get exit => '退出';

  @override
  String devicesFound(int count) {
    return '$count 个新设备';
  }

  @override
  String deviceFound(int count) {
    return '$count 个新设备';
  }

  @override
  String get notFoundDeviceTitle => '未找到\n设备？';

  @override
  String get selectManuallyButton => '手动选择';

  @override
  String devicesAdded(int count, String plural) {
    return '已添加 $count 个$plural';
  }

  @override
  String get device => '设备';

  @override
  String get devices => '设备';
}
