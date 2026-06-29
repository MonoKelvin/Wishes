import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化本地存储
  await Hive.initFlutter();
  await LocalStorage.initialize();

  runApp(
    const ProviderScope(
      child: WishesApp(),
    ),
  );
}
