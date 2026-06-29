import 'package:hive_flutter/hive_flutter.dart';

class ApiConfig {
  static const String _configBox = 'api_config';

  // 默认配置
  static String _zhetaokeAppkey = 'c5e70bd48a2e421eaa7ce0d8d167fd22';

  // Getters
  static String get zhetaokeAppkey => _zhetaokeAppkey;

  // API基础URL
  static const String zhetaokeBaseUrl =
      'https://api.zhetaoke.com:10001/api';

  // Setters
  static void setConfig({String? appkey}) {
    if (appkey != null) _zhetaokeAppkey = appkey;
  }

  // 从本地存储加载配置
  static Future<void> loadFromStorage() async {
    final box = await Hive.openBox(_configBox);
    _zhetaokeAppkey =
        box.get('zhetaoke_appkey', defaultValue: _zhetaokeAppkey);
  }

  // 保存配置到本地存储
  static Future<void> saveToStorage() async {
    final box = await Hive.openBox(_configBox);
    await box.put('zhetaoke_appkey', _zhetaokeAppkey);
  }
}
