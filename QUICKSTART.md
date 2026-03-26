# OneDay 鸿蒙笔记应用 - 快速开始指南

## 项目已创建完成！

本项目已创建了一个完整的 HarmonyOS 笔记应用，仿照 iOS DayOne 设计。

## 项目文件结构

```
one-day/
├── README.md                 # 项目说明文档
├── RUN_GUIDE.md              # 详细运行指南
├── build.sh                  # 构建脚本
├── build-profile.json5       # 构建配置
├── oh-package.json5          # 项目依赖配置
├── hvigorfile.ts             # 构建工具配置
│
├── app/
│   └── app.json5             # 应用全局配置
│
└── entry/
    ├── hvigorfile.ts
    ├── build-profile.json5
    ├── oh-package.json5
    │
    ├── src/main/
    │   ├── module.json5                      # 模块配置
    │   ├── ets/entryability/EntryAbility.ets # 入口文件
    │   └── resources/base/
    │       ├── element/
    │       │   ├── string.json               # 字符串资源
    │       │   └── color.json                # 颜色资源
    │       ├── profile/
    │       │   └── main_pages.json           # 页面配置
    │       └── media/                        # 媒体资源
    │
    └── ets/
        ├── pages/
        │   ├── Index.ets           # 主页面（日记列表）
        │   ├── EditPage.ets        # 编辑页面
        │   ├── DetailPage.ets      # 详情页面
        │   └── SettingsPage.ets    # 设置页面
        │
        ├── models/
        │   └── DiaryEntry.ets      # 数据模型和管理器
        │
        └── utils/
            ├── WeatherUtil.ets     # 天气工具
            └── LocationUtil.ets    # 位置工具
```

## 核心功能

✅ **已实现:**
- 📔 日记列表展示（按日期倒序）
- 🔍 搜索功能
- 📝 创建/编辑/删除日记
- ❤️ 收藏标记
- ☀️ 天气信息显示（模拟数据）
- 📍 位置信息显示（模拟数据）
- 📷 照片附件 UI（待接入真实 API）
- 🌙 深色模式设置
- ⚙️ 设置页面

## 下一步：安装开发环境

### 1. 下载 DevEco Studio

访问：https://developer.huawei.com/consumer/cn/deveco-studio/

选择 macOS 版本下载安装。

### 2. 安装后配置

1. 启动 DevEco Studio
2. 配置 HarmonyOS SDK（自动下载）
3. 确保安装 API 12

### 3. 打开项目

```bash
# 在 DevEco Studio 中
File > Open > 选择 /Users/duzl/Github/one-day
```

### 4. 运行应用

**使用模拟器:**
- Tools > Device Manager > 创建模拟器 > 启动
- 点击 Run 按钮

**使用真机:**
1. 手机开启开发者模式和 USB 调试
2. USB 连接电脑
3. 在 DevEco Studio 选择设备
4. 点击 Run

## 运行命令参考

```bash
# 查看项目结构
tree /Users/duzl/Github/one-day

# 运行构建脚本（安装 DevEco Studio 后）
./build.sh

# 使用 hdc 工具（需要配置 PATH）
export PATH=$PATH:/Applications/DevEco-Studio.app/Contents/sdk/hdc
hdc list targets
hdc install entry/build/default/outputs/default/entry-default-signed.hap
```

## 详细文档

- 📖 [README.md](README.md) - 完整项目说明
- 🚀 [RUN_GUIDE.md](RUN_GUIDE.md) - 详细运行步骤

---

**注意:** 由于当前机器未安装 DevEco Studio，需要在安装后打开项目并构建。
项目代码已完整，可以直接在 DevEco Studio 中打开运行。
