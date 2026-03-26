import { DiaryEntry, DiaryManager } from '../models/DiaryEntry';
import { WeatherUtil } from '../utils/WeatherUtil';

@Entry
@Component
struct DetailPage {
  @State entry: DiaryEntry | null = null;
  @State isFavorite: boolean = false;

  private entryId: number = -1;
  private diaryManager: DiaryManager = DiaryManager.getInstance();

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.entryId = params['entryId'] ? parseInt(params['entryId']) : -1;
    this.loadEntry();
  }

  loadEntry() {
    this.entry = this.diaryManager.getEntryById(this.entryId);
    if (this.entry) {
      this.isFavorite = this.entry.isFavorite || false;
    }
  }

  toggleFavorite() {
    if (this.entry) {
      this.isFavorite = !this.isFavorite;
      this.diaryManager.updateEntry(this.entry.id, {
        isFavorite: this.isFavorite
      });
    }
  }

  @Builder
  weatherSection() {
    if (!this.entry?.weather) {
      return;
    }

    Row() {
      Text(WeatherUtil.getWeatherIcon(this.entry.weather.condition))
        .fontSize(24)
      Column() {
        Text(WeatherUtil.getWeatherDescription(
          this.entry.weather.condition,
          this.entry.weather.temperature
        ))
          .fontSize(14)
          .fontColor('#1C1C1E')
        if (this.entry.weather.humidity) {
          Text(`湿度 ${this.entry.weather.humidity}%`)
            .fontSize(12)
            .fontColor('#8E8E93')
        }
      }
      .margin({ left: 8 })
    }
    .padding(12)
    .backgroundColor('#F2F2F7')
    .borderRadius(12)
  }

  @Builder
  locationSection() {
    if (!this.entry?.location) {
      return;
    }

    Row() {
      Text('📍')
        .fontSize(20)
      Text(this.entry.location.name)
        .fontSize(14)
        .fontColor('#1C1C1E')
        .margin({ left: 8 })
    }
    .padding(12)
    .backgroundColor('#F2F2F7')
    .borderRadius(12)
  }

  @Builder
  photoGrid() {
    if (!this.entry?.photos || this.entry.photos.length === 0) {
      return;
    }

    Column() {
      ForEach(this.entry.photos, (photo: string, index: number) => {
        Image(photo)
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)
          .margin({ bottom: index < this.entry!.photos.length - 1 ? 8 : 0 })
      }, (photo: string, index: number) => index)
    }
    .width('100%')
  }

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

        Text('日记详情')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)

        Button() {
          Text(this.isFavorite ? '❤️' : '🤍')
            .fontSize(20)
        }
        .type(ButtonType.Plain)
        .onClick(() => {
          this.toggleFavorite();
        })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 12, bottom: 12 })

      Divider()
        .color('#E5E5EA')

      // 内容区
      Scroll() {
        Column() {
          if (this.entry) {
            // 日期信息
            Column() {
              Text(this.getFullDate(this.entry.createdAt))
                .fontSize(14)
                .fontColor('#8E8E93')
              Text(this.getWeekDay(this.entry.createdAt))
                .fontSize(12)
                .fontColor('#C7C7CC')
                .margin({ top: 4 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .padding({ top: 20, bottom: 16 })

            // 标题
            if (this.entry.title && this.entry.title.trim() !== '') {
              Text(this.entry.title)
                .width('100%')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1C1C1E')
                .margin({ bottom: 16 })
                .padding({ left: 16, right: 16 })
            }

            // 天气和位置
            Row() {
              this.weatherSection()
              this.locationSection()
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .justifyContent(FlexAlign.Start)

            // 照片
            this.photoGrid()
              .padding({ left: 16, right: 16, top: 16, bottom: 16 })

            // 正文
            Text(this.entry.content)
              .width('100%')
              .fontSize(16)
              .lineHeight(28)
              .fontColor('#1C1C1E')
              .padding({ left: 16, right: 16, top: 8, bottom: 32 })

            // 创建和更新时间
            Column() {
              Text(`创建于：${this.formatTime(this.entry.createdAt)}`)
                .fontSize(12)
                .fontColor('#C7C7CC')
              Text(`更新于：${this.formatTime(this.entry.updatedAt)}`)
                .fontSize(12)
                .fontColor('#C7C7CC')
                .margin({ top: 4 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
            .padding({ bottom: 24 })
          }
        }
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      // 编辑按钮
      Button() {
        Text('编辑')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
      }
      .width('90%')
      .height(48)
      .backgroundColor('#007AFF')
      .borderRadius(24)
      .margin({ bottom: 16 })
      .onClick(() => {
        router.pushUrl({
          url: 'pages/EditPage',
          params: { entryId: this.entryId }
        });
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  getFullDate(date: Date): string {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = d.getMonth() + 1;
    const day = d.getDate();
    return `${year}年${month}月${day}日`;
  }

  getWeekDay(date: Date): string {
    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return weekDays[new Date(date).getDay()];
  }

  formatTime(date: Date): string {
    const d = new Date(date);
    const hours = d.getHours().toString().padStart(2, '0');
    const minutes = d.getMinutes().toString().padStart(2, '0');
    return `${hours}:${minutes}`;
  }
}
