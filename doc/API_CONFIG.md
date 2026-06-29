# API配置说明

## 拼多多API密钥配置

### 配置位置

所有API密钥集中配置在单一文件中：

```
lib/core/config/api_config.dart
```

### 当前配置

```dart
class ApiConfig {
  // 拼多多API配置
  static const String pddClientId = '1a611aeba8a6499baae38b50570925b1';
  static const String pddClientSecret = '9717baa2b3036426eb495bc2f27aeecd959e2e0e';

  // API基础URL
  static const String pddBaseUrl = 'https://open-api.pinduoduo.com/api/router';
  static const String pddAuthUrl = 'https://mms.pinduoduo.com/open.html';
}
```

### 配置说明

| 配置项 | 说明 | 当前值 |
|--------|------|--------|
| pddClientId | 拼多多应用Client ID | 1a611aeba8a6499baae38b50570925b1 |
| pddClientSecret | 拼多多应用Client Secret | 9717baa2b3036426eb495bc2f27aeecd959e2e0e |
| pddBaseUrl | API基础URL | https://open-api.pinduoduo.com/api/router |
| pddAuthUrl | 授权页面URL | https://mms.pinduoduo.com/open.html |

## 配置引用关系

```
lib/core/config/api_config.dart          # 唯一配置源
        ↓
lib/core/constants/api_constants.dart    # 引用API URL配置
        ↓
lib/core/di/providers.dart               # 创建PddApiDataSource实例
        ↓
lib/features/*/providers/*.dart          # 使用Provider获取实例
```

## 修改配置

如需修改API密钥，只需编辑 `lib/core/config/api_config.dart` 文件：

```dart
class ApiConfig {
  // 修改为新的API密钥
  static const String pddClientId = 'new_client_id';
  static const String pddClientSecret = 'new_client_secret';

  // API基础URL（通常不需要修改）
  static const String pddBaseUrl = 'https://open-api.pinduoduo.com/api/router';
  static const String pddAuthUrl = 'https://mms.pinduoduo.com/open.html';
}
```

## 安全注意事项

1. **不要提交到公开仓库**：`.gitignore` 已配置忽略 `.env` 文件
2. **生产环境使用环境变量**：建议使用环境变量或配置服务管理密钥
3. **定期更换密钥**：建议定期更换API密钥以确保安全

## 相关文件

- `lib/core/config/api_config.dart` - API配置（唯一配置源）
- `lib/core/constants/api_constants.dart` - API常量（引用配置）
- `lib/core/di/providers.dart` - 依赖注入（创建API实例）
- `.env` - 环境变量配置（备用）

## 故障排除

### 问题：API请求失败

**检查项：**
1. 确认API密钥是否正确
2. 确认网络连接是否正常
3. 确认拼多多API服务是否可用

### 问题：配置未生效

**解决方案：**
1. 清除构建缓存：`flutter clean`
2. 重新安装依赖：`flutter pub get`
3. 重新运行应用：`flutter run`

### 问题：找不到配置文件

**检查项：**
1. 确认文件路径是否正确：`lib/core/config/api_config.dart`
2. 确认文件名是否正确
3. 确认文件是否已保存
