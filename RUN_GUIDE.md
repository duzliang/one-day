# 一、安装鸿蒙开发工具

## 1. 下载 DevEco Studio

访问 HarmonyOS 开发者官网下载页面：
https://developer.huawei.com/consumer/cn/deveco-studio/

选择适合你操作系统的版本：
- macOS (Intel/Apple Silicon)
- Windows
- Linux

## 2. 安装 DevEco Studio

### macOS
```bash
# 下载完成后，拖动 DevEco Studio 到 Applications 文件夹
# 首次启动需要配置 JDK，选择内置 JDK 即可
```

### Windows
```
运行安装程序，按向导完成安装
```

### Linux
```bash
# 解压安装包
tar -xzf DevEco-Studio-*.tar.gz
# 进入目录启动
cd DevEco-Studio-*/bin
./deveco-studio.sh
```

## 3. 配置 SDK

启动 DevEco Studio 后：

1. 打开 `File > Settings` (macOS: `DevEco Studio > Settings`)
2. 导航到 `SDK Manager`
3. 安装以下组件：
   - HarmonyOS SDK API 12
   - Device Manager (设备管理器)
   - Emulator (模拟器，可选)

4. 接受许可协议
5. 等待下载完成

---

# 二、在鸿蒙手机上运行应用的步骤

## 方法一：使用 DevEco Studio（推荐）

### 步骤 1: 准备手机

1. 打开 **设置 > 关于手机**
2. 连续点击 **版本号** 7 次，直到提示"您已处于开发者模式"
3. 返回 **设置 > 系统和更新 > 开发人员选项**
4. 开启 **USB 调试**
5. 开启 **仅充电模式下允许 ADB 调试**

### 步骤 2: 连接手机

1. 使用 USB 线连接手机和电脑
2. 手机上弹出"允许 USB 调试"对话框，点击 **允许**
3. 在 DevEco Studio 中，点击顶部工具栏的设备选择器
4. 选择你的设备

### 步骤 3: 运行应用

1. 在 DevEco Studio 中打开项目
2. 点击绿色 **Run** 按钮 (或按 `Shift + F10`)
3. 等待编译和安装
4. 应用会自动启动

---

## 方法二：使用 hdc 命令行工具

### 步骤 1: 找到 hdc 工具

```bash
# macOS 默认位置
/Applications/DevEco-Studio.app/Contents/sdk/hdc

# 添加到 PATH
export PATH=$PATH:/Applications/DevEco-Studio.app/Contents/sdk/hdc
```

### 步骤 2: 查看连接的设备

```bash
hdc list targets
```

### 步骤 3: 构建应用

```bash
# 在项目根目录
cd /Users/duzl/Github/one-day

# 使用 hvigor 构建
hvigorw assembleHap
```

### 步骤 4: 安装应用

```bash
# 安装 HAP 文件
hdc install entry/build/default/outputs/default/entry-default-signed.hap
```

### 步骤 5: 启动应用

```bash
# 启动 EntryAbility
hdc shell aa start -a EntryAbility -b com.oneday.notes
```

---

## 方法三：使用模拟器

如果没有真机，可以使用 DevEco Studio 内置模拟器：

1. 打开 `Tools > Device Manager`
2. 点击 **Local Emulator** 标签
3. 点击 **Create Emulator**
4. 选择设备类型（推荐选择 Phone）
5. 选择系统镜像（选择 API 12）
6. 点击 **Create**
7. 点击 **Start** 启动模拟器
8. 在 DevEco Studio 中选择模拟器运行应用

---

# 三、常见问题解决

## 问题 1: 设备未识别

```bash
# macOS
# 检查 USB 连接
hdc list targets

# 如果未显示设备，尝试重启 hdc
hdc kill
hdc start
```

## 问题 2: 签名错误

1. 打开 `File > Project Structure`
2. 选择 `Project > Signing Configs`
3. 勾选 `Automatically generate signature`
4. 点击 OK

## 问题 3: 安装失败

```bash
# 清除应用数据后重试
hdc shell bm uninstall -n com.oneday.notes

# 重新安装
hdc install entry/build/default/outputs/default/entry-default-signed.hap
```

---

# 四、调试应用

## 查看日志

```bash
# 使用 hilog 查看应用日志
hdc shell hilog

# 过滤特定应用的日志
hdc shell hilog | grep "com.oneday.notes"
```

## 使用 HiLog

在代码中添加日志：

```typescript
console.info('MyTag', 'This is info log');
console.error('MyTag', 'This is error log');
```

---

# 五、发布应用

1. 配置发布签名
2. 构建 Release 版本
3. 生成 AppGallery Connect 所需的 App 包
4. 提交到华为应用市场
