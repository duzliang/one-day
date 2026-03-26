#!/usr/bin/env bash

# OneDay 项目构建脚本
# 用于在命令行构建 HarmonyOS 应用

set -e

echo "========================================"
echo "  OneDay - HarmonyOS 应用构建脚本"
echo "========================================"
echo ""

# 检查 DevEco Studio 是否安装
DEVICO_PATH="/Applications/DevEco-Studio.app/Contents/sdk"
if [ ! -d "$DEVICO_PATH" ]; then
    echo "错误：未找到 DevEco Studio SDK"
    echo ""
    echo "请先安装 DevEco Studio:"
    echo "1. 访问 https://developer.huawei.com/consumer/cn/deveco-studio/"
    echo "2. 下载并安装 DevEco Studio"
    echo "3. 配置 HarmonyOS SDK"
    echo ""
    exit 1
fi

# 添加 hdc 到 PATH
export PATH="$DEVICO_PATH/toolchains:$DEVICO_PATH/hdc:$PATH"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "错误：需要安装 Node.js"
    exit 1
fi

echo "✓ 环境检查通过"
echo ""

# 检查依赖
echo "正在检查依赖..."
if [ ! -d "node_modules" ]; then
    echo "正在安装依赖..."
    npm install
fi

echo "✓ 依赖安装完成"
echo ""

# 构建项目
echo "正在构建项目..."
if command -v hvigorw &> /dev/null; then
    ./hvigorw assembleHap
else
    echo "提示：hvigorw 不可用，尝试使用 npm 构建"
    npm run build 2>/dev/null || echo "注意：需要在 DevEco Studio 中打开项目以完成构建"
fi

echo ""
echo "========================================"
echo "  构建完成!"
echo "========================================"
echo ""
echo "输出文件位置:"
echo "  entry/build/default/outputs/default/"
echo ""
echo "在真机上运行:"
echo "  1. 确保手机已开启 USB 调试"
echo "  2. 连接手机"
echo "  3. 运行：hdc list targets"
echo "  4. 运行：hdc install entry/build/default/outputs/default/entry-default-signed.hap"
echo ""
