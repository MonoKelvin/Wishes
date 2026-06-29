# 开发指南

## 环境配置

### 1. 安装Flutter SDK

```bash
# 下载Flutter SDK
# https://flutter.dev/docs/get-started/install

# 验证安装
flutter --version
flutter doctor
```

### 2. 配置开发工具

#### Android Studio
1. 安装Android Studio
2. 安装Flutter和Dart插件
3. 配置Android SDK

#### VS Code
1. 安装VS Code
2. 安装Flutter扩展
3. 安装Dart扩展

### 3. 配置拼多多API

1. 访问拼多多开放平台：https://open.pinduoduo.com/
2. 注册开发者账号
3. 创建应用获取API密钥
4. 在项目中配置API密钥

## 项目配置

### 1. 安装依赖

```bash
cd wishes
flutter pub get
```

### 2. 配置环境变量

复制 `.env.example` 为 `.env` 并填入配置：

```bash
cp .env.example .env
```

编辑 `.env` 文件：

```
PDD_CLIENT_ID=your_client_id_here
PDD_CLIENT_SECRET=your_client_secret_here
APP_ENV=development
APP_DEBUG=true
```

### 3. 添加资源文件

在 `assets/` 目录下添加：

- `assets/images/` - 应用图片资源
- `assets/icons/` - 应用图标资源
- `assets/fonts/` - 字体文件

## 开发流程

### 1. 创建新功能

```bash
# 创建新分支
git checkout -b feature/new-feature

# 开发功能...

# 提交代码
git add .
git commit -m "feat: add new feature"

# 推送到远程
git push origin feature/new-feature
```

### 2. 代码规范

- 遵循Dart代码规范
- 使用flutter_lints进行代码检查
- 运行代码检查：

```bash
flutter analyze
```

### 3. 测试

```bash
# 运行单元测试
flutter test

# 运行集成测试
flutter test integration_test/
```

## 构建和发布

### Android

```bash
# 调试版本
flutter build apk --debug

# 发布版本
flutter build apk --release

# App Bundle（推荐）
flutter build appbundle --release
```

### iOS

```bash
# 调试版本
flutter build ios --debug

# 发布版本
flutter build ios --release
```

## 调试技巧

### 1. 使用Flutter Inspector

```bash
flutter run --debug
```

在VS Code中：
1. 按F5启动调试
2. 使用Flutter Inspector查看Widget树

### 2. 日志输出

```dart
import 'package:logger/logger.dart';

final logger = Logger();
logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

### 3. 热重载

```bash
# 运行应用
flutter run

# 按r进行热重载
# 按R进行热重启
```

## 常见问题

### 1. 依赖冲突

```bash
# 清除缓存
flutter clean
flutter pub get
```

### 2. Android构建失败

```bash
# 清除Gradle缓存
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### 3. iOS构建失败

```bash
# 清除Pod缓存
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

## 项目结构说明

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

## 贡献指南

1. Fork项目
2. 创建功能分支
3. 提交代码
4. 创建Pull Request

## 联系方式

如有问题，请提交Issue或联系开发团队。
