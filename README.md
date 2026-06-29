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

- Flutter 3.44+
- Dart 3.12+
- Riverpod 3.0+ (状态管理)
- GoRouter (路由管理)
- Dio (网络请求)
- Hive (本地存储)
- flutter_secure_storage (加密存储)

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── app/                         # 应用配置
│   ├── app.dart                 # 根Widget
│   ├── routes.dart              # 路由配置
│   └── theme.dart               # 主题配置
├── core/                        # 核心基础设施
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

1. 安装Flutter SDK 3.44+
2. 安装Dart SDK 3.12+
3. 配置Android Studio或Xcode开发环境

### 安装步骤

1. 克隆项目
```bash
git clone <repository-url>
cd wishes
```

2. 安装依赖
```bash
flutter pub get
```

3. 配置拼多多API密钥

API密钥已在 `lib/core/config/api_config.dart` 中配置完成。如需修改，请编辑该文件：
```dart
static const String pddClientId = 'your_client_id';
static const String pddClientSecret = 'your_client_secret';
```

4. 运行应用
```bash
flutter run
```

### 资源文件

在 `assets/` 目录下添加以下资源：

- `assets/images/` - 应用图片资源
- `assets/icons/` - 应用图标资源
- `assets/fonts/` - 字体文件（PingFang-Regular.ttf, PingFang-Medium.ttf, PingFang-Bold.ttf）

## 开发指南

### 添加新功能

1. 在 `domain/entities/` 中定义实体
2. 在 `domain/repositories/` 中定义仓储接口
3. 在 `domain/usecases/` 中创建用例
4. 在 `data/` 中实现仓储
5. 在 `features/` 中创建UI和Provider

### 状态管理

使用Riverpod进行状态管理：

```dart
// 定义Provider
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

// 在Widget中使用
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    // ...
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

## 测试

运行单元测试：
```bash
flutter test
```

运行集成测试：
```bash
flutter test integration_test/
```

## 构建

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 注意事项

1. 拼多多API需要申请开发者账号和API密钥
2. 部分功能需要真机测试（如OAuth授权）
3. 建议使用最新稳定版Flutter SDK

## 许可证

本项目仅供学习和个人使用。
