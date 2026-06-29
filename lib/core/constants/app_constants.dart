class AppConstants {
  // 应用信息
  static const String appName = '心愿';
  static const String appVersion = '1.0.0';

  // 存储键名
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String lastSyncTimeKey = 'last_sync_time';

  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // 缓存配置
  static const Duration tokenRefreshBefore = Duration(minutes: 5);
  static const Duration cacheValidDuration = Duration(hours: 24);

  // 动画时长
  static const Duration microInteractionDuration = Duration(milliseconds: 150);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration listAnimationDuration = Duration(milliseconds: 350);
  static const Duration elasticAnimationDuration = Duration(milliseconds: 500);
}
