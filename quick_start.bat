@echo off
REM 快速开始脚本 (Windows)

echo === 心愿应用 - 快速开始 ===
echo.

REM 检查Flutter是否安装
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: Flutter未安装
    echo.
    echo 请按照以下步骤安装Flutter:
    echo 1. 访问 https://flutter.dev/docs/get-started/install
    echo 2. 下载Flutter SDK
    echo 3. 解压到合适的位置
    echo 4. 将Flutter添加到PATH环境变量
    echo 5. 运行 flutter doctor 验证安装
    echo.
    pause
    exit /b 1
)

REM 进入项目目录
cd /d "%~dp0"

echo 步骤 1: 创建Flutter项目结构
echo ----------------------------------------
flutter create --org com.wishes --project-name wishes .

if %errorlevel% neq 0 (
    echo 错误: Flutter项目创建失败
    pause
    exit /b 1
)
echo √ Flutter项目结构创建成功
echo.

echo 步骤 2: 安装依赖
echo ----------------------------------------
flutter pub get

if %errorlevel% neq 0 (
    echo 错误: 依赖安装失败
    pause
    exit /b 1
)
echo √ 依赖安装成功
echo.

echo 步骤 3: 检查项目结构
echo ----------------------------------------
flutter analyze

if %errorlevel% neq 0 (
    echo 警告: 项目分析发现问题
) else (
    echo √ 项目分析通过
)
echo.

echo 步骤 4: 配置说明
echo ----------------------------------------
echo 请按照以下步骤完成配置:
echo.
echo 1. 配置拼多多API密钥:
echo    - 申请拼多多开发者账号
echo    - 获取API密钥
echo    - 编辑 .env 文件填入密钥
echo.
echo 2. 添加资源文件:
echo    - 将应用图片放入 assets/images/
echo    - 将应用图标放入 assets/icons/
echo    - 将字体文件放入 assets/fonts/
echo.
echo 3. 运行应用:
echo    flutter run
echo.

echo === 快速开始完成 ===
echo.
echo 详细说明请参考:
echo - README.md - 项目说明
echo - DEVELOPMENT.md - 开发指南
echo - FLUTTER_SETUP.md - Flutter初始化说明
echo - PLATFORM_SETUP.md - 平台配置说明
echo.
pause
