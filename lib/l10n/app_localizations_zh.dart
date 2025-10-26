// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'HVAC控制';

  @override
  String get home => '主页';

  @override
  String get settings => '设置';

  @override
  String get hvacControl => 'HVAC控制';

  @override
  String activeDevices(int count, int total) {
    return '$count/$total 活跃';
  }

  @override
  String get connectionError => '连接错误';

  @override
  String get retryConnection => '重试连接';

  @override
  String get noDevicesFound => '未找到设备';

  @override
  String get checkMqttSettings => '请检查MQTT连接设置\n并确保设备在线';

  @override
  String get loadingDevices => '加载设备中...';

  @override
  String get power => '电源';

  @override
  String get on => '开';

  @override
  String get off => '关';

  @override
  String get temperature => '温度';

  @override
  String get adjustTargetTemperature => '调整目标温度';

  @override
  String get deviceIsOff => '设备已关闭';

  @override
  String get target => '目标';

  @override
  String current(String temp) {
    return '当前：$temp°C';
  }

  @override
  String get min => '最小';

  @override
  String get max => '最大';

  @override
  String get operatingMode => '运行模式';

  @override
  String get selectHvacMode => '选择HVAC运行模式';

  @override
  String get cooling => '制冷';

  @override
  String get heating => '制热';

  @override
  String get auto => '自动';

  @override
  String get fan => '送风';

  @override
  String get coolDownToTarget => '冷却至目标温度';

  @override
  String get heatUpToTarget => '加热至目标温度';

  @override
  String get autoAdjustTemperature => '自动调节温度';

  @override
  String get circulateAir => '循环空气，不制冷/制热';

  @override
  String get fanSpeed => '风速';

  @override
  String get adjustAirflow => '调整气流强度';

  @override
  String get low => '低';

  @override
  String get medium => '中';

  @override
  String get high => '高';

  @override
  String get gentleAirflow => '轻柔气流，静音运行';

  @override
  String get balancedAirflow => '平衡气流和噪音水平';

  @override
  String get maximumAirflow => '最大气流，快速制冷/制热';

  @override
  String get autoAdjustSpeed => '根据温度自动调节';

  @override
  String get powerLevel => '功率';

  @override
  String get temperatureHistory => '温度历史';

  @override
  String get last24Hours => '最近24小时';

  @override
  String get average => '平均';

  @override
  String get appearance => '外观';

  @override
  String get theme => '主题';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '系统';

  @override
  String get language => '语言';

  @override
  String get english => 'English';

  @override
  String get russian => 'Русский';

  @override
  String get chinese => '中文';

  @override
  String get connection => '连接';

  @override
  String get mqttSettings => 'MQTT设置';

  @override
  String get configureMqtt => '配置MQTT代理连接';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get hvacUnit => 'HVAC设备';

  @override
  String error(String message) {
    return '错误：$message';
  }
}
