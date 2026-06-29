#!/bin/bash

# Flutter项目初始化脚本

echo "=== Flutter项目初始化脚本 ==="
echo ""

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "错误: Flutter未安装或未添加到PATH"
    echo "请先安装Flutter SDK: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# 显示Flutter版本
echo "Flutter版本:"
flutter --version
echo ""

# 检查Dart版本
echo "Dart版本:"
dart --version
echo ""

# 进入项目目录
cd "$(dirname "$0")"

echo "当前目录: $(pwd)"
echo ""

# 创建Flutter项目结构
echo "正在创建Flutter项目结构..."
flutter create --org com.wishes --project-name wishes .

if [ $? -ne 0 ]; then
    echo "错误: Flutter项目创建失败"
    exit 1
fi

echo "Flutter项目结构创建成功"
echo ""

# 安装依赖
echo "正在安装依赖..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "错误: 依赖安装失败"
    exit 1
fi

echo "依赖安装成功"
echo ""

# 检查项目结构
echo "检查项目结构..."
flutter analyze

if [ $? -ne 0 ]; then
    echo "警告: 项目分析发现问题，请检查代码"
else
    echo "项目分析通过"
fi

echo ""
echo "=== 初始化完成 ==="
echo ""
echo "下一步:"
echo "1. 配置拼多多API密钥: 编辑 .env 文件"
echo "2. 添加资源文件: 将图片和字体放入 assets/ 目录"
echo "3. 运行应用: flutter run"
echo ""
