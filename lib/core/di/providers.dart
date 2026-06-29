import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../storage/local_storage.dart';
import '../../data/datasources/remote/platform_api.dart';
import '../../data/datasources/remote/zhetaoke_taobao_datasource.dart';

// 全局Provider
final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create();
});

// 平台API数据源（折淘客）
final platformApiProvider = Provider<PlatformApiDataSource>((ref) {
  return ZhetaokeTaobaoDataSource(dio: ref.read(dioProvider));
});
