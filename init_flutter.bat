@echo off
REM Flutter项目初始化脚本 (Windows)

echo === Flutter项目初始化脚本 ===
echo.

REM 检查Flutter是否安装
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: Flutter未安装或未添加到PATH
    echo 请先安装Flutter SDK: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM 显示Flutter版本
echo Flutter版本:
flutter --version
echo.

REM 检查Dart版本
echo Dart版本:
dart --version
echo.

REM 进入项目目录
cd /d "%~dp0"

echo 当前目录: %cd%
echo.

REM 创建Flutter项目结构
echo 正在创建Flutter项目结构...
flutter create --org com.wishes --project-name wishes .

if %errorlevel% neq 0 (
    echo 错误: Flutter项目创建失败
    pause
    exit /b 1
)

echo Flutter项目结构创建成功
echo.

REM 安装依赖
echo 正在安装依赖...
flutter pub get

if %errorlevel% neq 0 (
    echo 错误: 依赖安装失败
    pause
    exit /b 1
)

echo 依赖安装成功
echo.

REM 检查项目结构
echo 检查项目结构...
flutter analyze

if %errorlevel% neq 0 (
    echo 警告: 项目分析发现问题，请检查代码
) else (
    echo 项目分析通过
)

echo.
echo === 初始化完成 ===
echo.
echo 下一步:
echo 1. 配置拼多多API密钥: 编辑 .env 文件
echo 2. 添加资源文件: 将图片和字体放入 assets/ 目录
echo 3. 运行应用: flutter run
echo.
pause
