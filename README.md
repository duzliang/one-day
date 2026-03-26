# OneDay - 鸿蒙版 DayOne 笔记应用

OneDay 是一款仿照 iOS DayOne 应用设计的鸿蒙 (HarmonyOS) 笔记应用，帮助你记录生活中的每一天。

## 功能特性

### 核心功能
- 📔 **日记管理** - 创建、编辑、删除日记
- 📅 **日期显示** - 清晰的日期和星期展示
- 🔍 **搜索功能** - 快速查找历史日记
- ❤️ **收藏标记** - 标记重要的日记

### 特色功能
- ☀️ **天气记录** - 自动获取当天天气信息
- 📍 **位置标记** - 记录写日记时的位置
- 📷 **照片附件** - 为日记添加照片
- 🌙 **深色模式** - 支持深色主题
- ☁️ **数据同步** - iCloud 同步支持（待实现）
- 🔔 **提醒功能** - 每日写日记提醒

### 数据导出
- 📄 **PDF 导出** - 导出日记为 PDF 格式
- 💾 **本地备份** - 支持数据备份和恢复

## 项目结构

```
one-day/
├── app/                          # 应用配置
│   └── app.json5                 # 应用全局配置
├── entry/                        # 入口模块
│   ├── ets/
│   │   ├── entryability/         # 入口能力
│   │   │   └── EntryAbility.ets
│   │   ├── pages/                # 页面
│   │   │   ├── Index.ets         # 主页面（日记列表）
│   │   │   ├── EditPage.ets      # 编辑页面
│   │   │   ├── DetailPage.ets    # 详情页面
│   │   │   └── SettingsPage.ets  # 设置页面
│   │   ├── models/               # 数据模型
│   │   │   └── DiaryEntry.ets    # 日记模型和管理器
│   │   └── utils/                # 工具类
│   │       ├── WeatherUtil.ets   # 天气工具
│   │       └── LocationUtil.ets  # 位置工具
│   ├── src/main/
│   │   ├── resources/            # 资源文件
│   │   │   ├── base/
│   │   │   │   ├── element/      # 字符串、颜色资源
│   │   │   │   └── profile/      # 配置文件
│   │   │   └── media/            # 媒体资源
│   │   └── module.json5          # 模块配置
│   └── oh-package.json5          # 模块依赖配置
└── build-profile.json5           # 构建配置
```

## 技术栈

- **开发语言**: ArkTS (TypeScript for HarmonyOS)
- **UI 框架**: ArkUI
- **目标系统**: HarmonyOS 5.0+ (API 12)
- **设备类型**: 手机、平板

## 开发环境要求

- DevEco Studio 4.0+
- HarmonyOS SDK API 12+
- Node.js 16+

## 快速开始

### 1. 安装 DevEco Studio

访问 [HarmonyOS 开发者官网](https://developer.harmonyos.com/) 下载并安装 DevEco Studio。

### 2. 配置 SDK

打开 DevEco Studio，配置 HarmonyOS SDK：
- 打开 `File > Settings > SDK Manager`
- 安装 HarmonyOS SDK API 12

### 3. 打开项目

在 DevEco Studio 中打开本项目目录。

### 4. 运行应用

- 连接 HarmonyOS 设备或启动模拟器
- 点击运行按钮或按 `Shift + F10`
- 选择目标设备

## 在真机上运行的步骤

### 步骤 1: 准备设备

1. 在 HarmonyOS 手机上打开 **设置 > 关于手机**
2. 连续点击 **版本号** 7 次，启用开发者模式
3. 返回 **设置 > 系统和更新 > 开发人员选项**
4. 开启 **USB 调试**

### 步骤 2: 连接设备

1. 使用 USB 线连接手机和电脑
2. 在手机上允许 USB 调试授权

### 步骤 3: 在 DevEco Studio 中运行

1. 打开 DevEco Studio
2. 顶部工具栏选择你的设备
3. 点击 **Run** 按钮 (绿色三角形)
4. 等待应用安装并启动

### 步骤 4: 使用 hdc 命令运行（可选）

```bash
# 进入项目目录
cd one-day

# 查看连接的设备
hdc list targets

# 构建并安装应用
npm run build
hdc install entry/build/default/outputs/default/entry-default-signed.hap

# 启动应用
hdc shell aa start -a EntryAbility -b com.oneday.notes
```

## 截图预览

### 主页面
- 日记列表展示
- 搜索功能
- 底部导航栏

### 编辑页面
- 标题和内容输入
- 天气和位置自动获取
- 照片添加

### 详情页面
- 完整日记展示
- 天气和位置信息
- 照片浏览

### 设置页面
- 深色模式切换
- 同步设置
- 导出选项

## 待实现功能

- [ ] 相机拍照功能
- [ ] 相册选择功能
- [ ] 真实的天气 API 接入
- [ ] 真实的地理位置 API
- [ ] iCloud/云空间同步
- [ ] PDF 导出功能
- [ ] 日记标签系统
- [ ] 日历视图
- [ ] 密码锁保护

## 许可证

Apache-2.0 License

## 致谢

灵感来自 [Day One](https://dayoneapp.com/) 应用
