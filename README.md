# 心愿 - 购物心愿清单管理应用

一个Flutter应用，帮助用户管理购物心愿清单，支持从拼多多同步收藏商品。

## 功能特性

- 拼多多账号授权登录
- 收藏商品一键同步
- 创建和管理心愿项目
- 商品分类管理
- 采购进度追踪
- 深色/浅色模式支持

## 技术栈

| 类别 | 技术 | 版本 |
|------|------|------|
| 框架 | Flutter | 3.44.4 |
| 语言 | Dart | 3.12.2 |
| 状态管理 | Riverpod | 3.0.3 |
| 路由管理 | GoRouter | 14.8.1 |
| 网络请求 | Dio | 5.7.0 |
| 本地存储 | Hive | 2.2.3 |
| 加密存储 | flutter_secure_storage | 9.2.4 |
| Android SDK | Android 16 | API 36 |
| Gradle | Gradle | 8.14 |
| Android Gradle Plugin | AGP | 8.11.1 |
| Kotlin | Kotlin | 2.2.20 |

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── app/                         # 应用配置
│   ├── app.dart                 # 根Widget
│   ├── routes.dart              # 路由配置
│   └── theme.dart               # 主题配置
├── core/                        # 核心基础设施
│   ├── config/                  # API配置
│   ├── constants/               # 常量定义
│   ├── di/                      # 依赖注入
│   ├── network/                 # 网络配置
│   ├── storage/                 # 存储配置
│   ├── utils/                   # 工具类
│   └── error/                   # 错误处理
├── domain/                      # 领域层
│   ├── entities/                # 实体类
│   ├── repositories/            # 仓储接口
│   └── usecases/                # 用例
├── data/                        # 数据层
│   ├── datasources/             # 数据源
│   ├── repositories/            # 仓储实现
│   └── mappers/                 # 数据映射
└── features/                    # 功能模块
    ├── auth/                    # 认证模块
    ├── home/                    # 首页模块
    ├── project/                 # 项目模块
    ├── product/                 # 商品模块
    └── sync/                    # 同步模块
```

## 开始使用

### 前置条件

1. 安装 Flutter SDK 3.44+
2. 安装 Android Studio
3. 配置 Android SDK 36
4. 创建 Android 模拟器或连接真机

### 安装步骤

1. 克隆项目
```bash
git clone https://github.com/MonoKelvin/Wishes.git
cd Wishes
```

2. 安装依赖
```bash
flutter pub get
```

3. 配置拼多多API密钥

API密钥在 `lib/core/config/api_config.dart` 中配置：
```dart
static const String pddClientId = 'your_client_id';
static const String pddClientSecret = 'your_client_secret';
```

4. 运行应用
```bash
flutter run
```

### 国内镜像配置

如果遇到依赖下载问题，可以配置国内镜像：

```bash
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

## 开发指南

### 添加新功能

1. 在 `domain/entities/` 中定义实体
2. 在 `domain/repositories/` 中定义仓储接口
3. 在 `domain/usecases/` 中创建用例
4. 在 `data/` 中实现仓储
5. 在 `features/` 中创建UI和Provider

### 状态管理

使用Riverpod 3.0进行状态管理：

```dart
// 定义Provider
final myProvider = AsyncNotifierProvider<MyNotifier, MyState>(() {
  return MyNotifier();
});

// 在Widget中使用
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return state.when(
      data: (data) => Text(data.toString()),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 路由管理

使用GoRouter进行路由管理：

```dart
// 在routes.dart中定义路由
GoRoute(
  path: '/detail/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return DetailScreen(id: id);
  },
);

// 导航
context.push('/detail/123');
context.pop();
```

## 构建

### Android
```bash
# Debug版本
flutter build apk --debug

# Release版本
flutter build apk --release

# App Bundle
flutter build appbundle --release
```

## 平台支持

| 平台 | 状态 |
|------|------|
| Android | ✅ 支持 |
| iOS | 🚧 计划中 |
| Web | 🚧 计划中 |
| Windows | 🚧 计划中 |
| macOS | 🚧 计划中 |
| Linux | 🚧 计划中 |

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。
