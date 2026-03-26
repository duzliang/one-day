@Entry
@Component
struct SettingsPage {
  @State darkMode: boolean = false;
  @State icloudSync: boolean = false;
  @State enableNotifications: boolean = true;
  @State reminderTime: string = '21:00';
  @State exportFormat: string = 'PDF';

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button() {
          Text('‹')
            .fontSize(28)
            .fontColor('#007AFF')
        }
        .type(ButtonType.Plain)
        .onClick(() => {
          router.back();
        })

        Text('设置')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)

        Empty()
          .width(44)
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 12, bottom: 12 })

      Divider()
        .color('#E5E5EA')

      // 设置列表
      Scroll() {
        Column() {
          // 外观设置
          this.settingGroup('外观', [
            this.switchSetting('深色模式', 'darkMode', this.darkMode),
            this.navigationSetting('主题颜色', '蓝色')
          ])

          // 同步设置
          this.settingGroup('同步与备份', [
            this.switchSetting('iCloud 同步', 'icloudSync', this.icloudSync),
            this.navigationSetting('立即备份', '立即备份'),
            this.navigationSetting('恢复数据', '从备份恢复')
          ])

          // 提醒设置
          this.settingGroup('提醒', [
            this.switchSetting('每日提醒写日记', 'enableNotifications', this.enableNotifications),
            this.navigationSetting('提醒时间', this.reminderTime)
          ])

          // 导出设置
          this.settingGroup('导出与分享', [
            this.navigationSetting('导出所有日记', `PDF 格式`),
            this.navigationSetting('分享单篇日记', ''),
            this.navigationSetting('导出格式', this.exportFormat)
          ])

          // 关于
          this.settingGroup('关于', [
            this.navigationSetting('版本', '1.0.0'),
            this.navigationSetting('检查更新', '已是最新版本'),
            this.navigationSetting('隐私政策', ''),
            this.navigationSetting('开源许可', '')
          ])

          // 危险操作
          this.settingGroup('', [
            this.destructiveSetting('清除所有数据', '删除本地所有日记数据')
          ])

          Empty()
            .height(32)
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#F2F2F7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F7')
  }

  @Builder
  settingGroup(title: string, children: Builder) {
    Column() {
      if (title !== '') {
        Text(title)
          .fontSize(13)
          .fontColor('#8E8E93')
          .padding({ left: 16, top: 16, bottom: 8 })
      }

      Column() {
        children()
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
    }
    .width('100%')
  }

  @Builder
  switchSetting(title: string, key: string, value: boolean) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor('#1C1C1E')

      Blank()

      Toggle({ type: ToggleType.Switch, isOn: value })
        .selectedColor('#007AFF')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }

  @Builder
  navigationSetting(title: string, value: string) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor('#1C1C1E')

      Blank()

      Text(value)
        .fontSize(14)
        .fontColor('#8E8E93')

      Text('›')
        .fontSize(20)
        .fontColor('#C7C7CC')
        .margin({ left: 8 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }

  @Builder
  destructiveSetting(title: string, subtitle: string) {
    Row() {
      Column() {
        Text(title)
          .fontSize(16)
          .fontColor('#FF3B30')
        Text(subtitle)
          .fontSize(12)
          .fontColor('#FF3B30')
          .opacity(0.7)
      }
      .alignItems(HorizontalAlign.Start)

      Blank()
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }
}
