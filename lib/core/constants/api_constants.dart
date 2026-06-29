import '../config/api_config.dart';

class ApiConstants {
  // 拼多多API基础配置 - 从统一配置获取
  static String get pddBaseUrl => ApiConfig.pddBaseUrl;
  static String get pddAuthUrl => ApiConfig.pddAuthUrl;

  // API端点
  static const String goodsSearch = 'pdd.ddk.goods.search';
  static const String goodsDetail = 'pdd.ddk.goods.detail';

  // 请求参数
  static const String clientIdKey = 'client_id';
  static const String clientSecretKey = 'client_secret';
  static const String accessTokenKey = 'access_token';
  static const String timestampKey = 'timestamp';
  static const String signKey = 'sign';
  static const String typeKey = 'type';

  // 响应字段
  static const String goodsSearchResponse = 'goods_search_response';
  static const String goodsDetailResponse = 'goods_detail_response';
  static const String goodsListKey = 'goods_list';
  static const String totalKey = 'total';
}
