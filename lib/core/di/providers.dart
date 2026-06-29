import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../storage/secure_storage.dart';
import '../storage/local_storage.dart';
import '../config/api_config.dart';
import '../../data/datasources/remote/pdd_api_datasource.dart';

// 全局Provider
final dioProvider = Provider<Dio>((ref) {
  return DioClient.create();
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

// 拼多多API数据源Provider
final pddApiDataSourceProvider = Provider<PddApiDataSource>((ref) {
  return PddApiDataSource(
    dio: ref.watch(dioProvider),
    clientId: ApiConfig.pddClientId,
    clientSecret: ApiConfig.pddClientSecret,
  );
});
